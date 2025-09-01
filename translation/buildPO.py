#! /usr/bin/env python3

__copyright__ = "Copyright 2025 Snap One, LLC. All Rights Reserved."

import argparse
import sys
import os
import re
from operator import itemgetter
from lxml import etree as ET
import codecs
import json


class CreatePO(object):
	def __init__(self):

		parser = argparse.ArgumentParser(description= """Creates a PO file from a driver and set of lua files.
			Leave off all arguments to process the current folder and output a driver.po file. The driver.po will be placed
			into www/translations. Limitations: Currently only single line gettext methods are supported. The text must be inside
			single quotes.""")
		parser.add_argument("-d", "--directory", help = "The driver directory that contains .lua files and a driver.xml")
		parser.add_argument("-o", "--output", help = "The output filename")
		parser.add_argument("-v", "--verbose", action="store_true", help = "Enable verbose")
		parser.add_argument("--dry-run", dest="dryrun", action="store_true", help = "Dry run. Don't write output file. Useful for debugging. This will also set verbose to true")
		parser.add_argument("--exclude", dest="excludedFiles", action="append", help = "Add to the list of excluded files. Files in this list will not be processed.")
		parser.add_argument("--include", dest="includedFiles", action="append", help = "Add to the list of included files. Files in this list are explicity processed. Note the filetype is used to determine how the file will be processed")

		args = parser.parse_args()

		self.verbose = args.verbose
		self.directory = args.directory
		self.output = args.output
		self.dryrun = args.dryrun
		self.excludedFiles = set(args.excludedFiles or [])
		self.includedFiles = args.includedFiles or []
		self.excludedFiles.add ('squished.lua')
		self.filename = ''
		self.displayName = ''

		if not self.directory:
			self.directory = os.getcwd()

		if not self.output:
			self.output = "www/translations/driver.po"

		if self.dryrun:
			self.verbose = True


	def log(self, *args):
		if self.verbose:
			print(*args)

	def finditer_with_line_numbers(self, pattern, string, flags=0):
		"""
		A version of ``re.finditer`` that returns ``(match, line_number)`` pairs.
		"""
		import re

		matches = list(re.finditer(pattern, string, flags))
		if matches:
			end = matches[-1].start()
			# -1 so a failed `rfind` maps to the first line.
			newline_table = {-1: 0}
			for i, m in enumerate(re.finditer("\\n", string), 1):
				# Don't find newlines past our last match.
				offset = m.start()
				if offset > end:
					break
				newline_table[offset] = i

			# Failing to find the newline is OK, -1 maps to 0.
			for m in matches:
				newline_offset = string.rfind("\n", 0, m.start())
				line_number = newline_table[newline_offset]
				yield (m, line_number)

	def main(self):
		luaFiles = []
		msgStrings = {}
		for root, _, files in os.walk(self.directory):
			for filename in files:
				_, fileExtension = os.path.splitext(filename)
				if fileExtension == ".lua" and filename not in self.excludedFiles:
					fullPath = os.path.join(root, filename)
					luaFiles.append(fullPath)

		# Process the explicitly included files
		luaIncludedFiles = []
		xmlIncludedFiles = ["driver.xml"]
		jsonIncludedFiles = ["driver.json"]
		for filename in self.includedFiles:
			_, extension = os.path.splitext(filename)
			if extension == ".xml":
				xmlIncludedFiles.append(filename)
			elif extension == ".json":
				jsonIncludedFiles.append(filename)
			else:
				fullPath = os.path.join(self.directory, filename)
				luaIncludedFiles.append(fullPath)

		luaFiles.extend(luaIncludedFiles)

		exp = re.compile (r'(?s)gettext \(([\'"])(.*?)\1')

		for filename in luaFiles:
			self.log("Processing:", filename)
			if os.path.exists (filename):
				with codecs.open(filename, "r", 'utf-8') as luaFile:
					luaFileSource = (luaFile.read())
					for m, line_number in self.finditer_with_line_numbers(exp, luaFileSource):
						msgStr = m.group(2)
						if (not msgStr in msgStrings):
							msgStrings [msgStr] = []
						msgStrings [msgStr].append ((filename, line_number + 1))

		#self.log("Strings:", msgStrings)

		# These are metadata items for resource repository

		for filename in jsonIncludedFiles:
			self.log("Processing:", filename)
			if os.path.exists (filename):
				with codecs.open(filename, "r", 'utf-8') as jsonFile:
					jsonData = json.load(jsonFile)

					self.filename = jsonData ['fileName']
					self.displayName = jsonData ['displayName']

					msgStr = jsonData ['displayName']
					if (not msgStr in msgStrings):
						msgStrings [msgStr] = []
					msgStrings [msgStr].append ((filename, 'displayName'))

					msgStr = jsonData ['model']
					if (not msgStr in msgStrings):
							msgStrings [msgStr] = []
					msgStrings [msgStr].append ((filename, 'model'))

					msgStr = jsonData ['category']
					if (not msgStr in msgStrings):
						msgStrings [msgStr] = []
					msgStrings [msgStr].append ((filename, 'category'))

					msgStr = jsonData ['description']
					if (not msgStr in msgStrings):
						msgStrings [msgStr] = []
					msgStrings [msgStr].append ((filename, 'description'))

		# Find the driver.xml and look for all of the occurences of named items like buttons, etc...

		for filename in xmlIncludedFiles:
			driverPath = os.path.join(self.directory, filename)
			self.processXmlFile(driverPath, msgStrings)

		self.log(msgStrings)

		if not self.dryrun:
			self.log("Writing to:", self.output)
			#if (len(msgStrings) > 0):
			outputDir = os.path.dirname(self.output)

			if outputDir and not os.path.exists(outputDir):
				os.makedirs(outputDir)

			with codecs.open(self.output, "w", "utf-8") as poFile:

				poFile.write(u'msgid ""\n')
				poFile.write(u'msgstr ""\n')
				poFile.write(u'"File: ' + self.filename + '\\n"\n')
				poFile.write(u'"Name: ' + self.displayName + '\\n"\n')
				poFile.write(u'"Content-Type: text/plain; charset=UTF-8\\n"\n')
				poFile.write(u'"Language: en\\n"\n\n')

				for msg in sorted (msgStrings):
					contextInfo = []
					for msgInfo in msgStrings [msg]:
						filename = os.path.relpath (msgInfo [0], self.directory)
						line_number = str (msgInfo [1])
						contextInfo.append (filename + ':' + line_number)
					context = ', '.join (sorted (contextInfo))

					poFile.write(u'#: ' + context + '\n')
					poFile.write(u'msgid "' + msg + '"\n')
					poFile.write(u'msgstr "' + msg + '"\n\n')
		return 0

	def processXmlFile(self, filename, msgStrings):
		ET.register_namespace("xsi", "http://www.w3.org/2001/XMLSchema-instance")
		tree = ET.parse(filename)
		#nsmap = dict((k, v) for k, v in tree.nsmap.items() if k)

		root = tree.getroot()

		self.log("\nFinding Action names:")
		names = root.findall(".//UI/Actions/Action/Name")
		self.addNodeTextToList(names, msgStrings, filename)

		self.log("\nFinding Action EditProperty help text:")
		names = root.findall(".//UI/Actions/Action/EditProperty[@helpText]")
		self.addAttribToList(names, msgStrings, "helpText", filename)

		self.log("\nFinding Action Filter names:")
		names = root.findall(".//UI/Actions/Action/Filters/Filter/Name")
		self.addNodeTextToList(names, msgStrings, filename)

		self.log("\nFinding Tab Names:")
		names = root.findall(".//UI/Tabs/Tab/Name")
		self.addNodeTextToList(names, msgStrings, filename)

		self.log("\nFinding Notification Button Names:")
		names = root.findall(".//UI/DriverNotifications/Notification/Buttons/Button/Name")
		self.addNodeTextToList(names, msgStrings, filename)

		self.log("\nFinding Search Filter Names:")
		names = root.findall(".//UI/Search/Filters/SearchFilter/Name")
		self.addNodeTextToList(names, msgStrings, filename)

		self.log("\nFinding Settings Screen Labels:")
		names = root.findall(".//UI/Screens/Screen//Label")
		self.addNodeTextToList(names, msgStrings, filename)

		self.log("\nFinding Settings Screen Headers:")
		names = root.findall(".//UI/Screens/Screen//HeaderTxt")
		self.addNodeTextToList(names, msgStrings, filename)

		self.log("\nFinding Settings Screen Button Names:")
		names = root.findall(".//UI/Screens/Screen//Button/Name")
		self.addNodeTextToList(names, msgStrings, filename)

		self.log("\nFinding Settings Screen ComboBox Item Values:")
		names = root.findall(".//UI/Screens/Screen//ComboBox//Item/Value")
		self.addNodeTextToList(names, msgStrings, filename)


	def addNodeTextToList(self, nodes, msgStrings, filename):
		for node in nodes:
			self.log(node.text)
			msgStr = node.text
			if (not msgStr in msgStrings):
				msgStrings [msgStr] = []
			msgStrings [msgStr].append ((filename, node.sourceline))

	def addAttribToList(self, nodes, msgStrings, attribName, filename):
		for node in nodes:
			self.log(node.attrib[attribName])
			msgStr = node.attrib[attribName]
			if (not msgStr in msgStrings):
				msgStrings [msgStr] = []
			msgStrings [msgStr].append ((filename, node.sourceline))

if __name__ == "__main__":
    cpo = CreatePO()
    sys.exit(cpo.main())