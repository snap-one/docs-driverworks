#! /usr/bin/env python

from __future__ import print_function
import argparse
import sys
import os
import re
import xml.etree.ElementTree as ET
import codecs


class CreatePO(object):
	def __init__(self):

		parser = argparse.ArgumentParser(description= """Creates a PO file from an MSP driver and set of lua files.
			Leave off all arguments to process the current folder and output a driver.po file. The driver.po will be placed
			into www/translations. Limitations: Currently only single line gettext methods are supported. The text must be inside
			double quotes.""")
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

		if not self.directory:
			self.directory = os.getcwd()

		if not self.output:
			self.output = "www/translations/driver.po"

		if self.dryrun:
			self.verbose = True


	def log(self, *args):
		if self.verbose:
			print(*args)

	def main(self):
		luaFiles = []
		msgStrings = set()
		for root, _, files in os.walk(self.directory):
			for filename in files:
				_, fileExtension = os.path.splitext(filename)
				if fileExtension == ".lua" and filename not in self.excludedFiles:
					fullPath = os.path.join(root, filename)
					luaFiles.append(fullPath)

		# Process the explicitly included files
		luaIncludedFiles = []
		xmlIncludedFiles = ["driver.xml"]
		for filename in self.includedFiles:
			_, extension = os.path.splitext(filename)
			if extension == ".xml":
				xmlIncludedFiles.append(filename)
			else:
				fullPath = os.path.join(self.directory, filename)
				luaIncludedFiles.append(fullPath)

		luaFiles.extend(luaIncludedFiles)

		exp = re.compile (r'gettext\s+?\(([\'"])(.*?)\1', re.IGNORECASE)

		for filename in luaFiles:
			self.log("Processing:", filename)
			with codecs.open(filename, "r", 'utf-8') as luaFile:
				for i, line in enumerate(luaFile.readlines()):
					for m in re.finditer(exp, line):
						self.log("line:", i, m.group(2))
						msgStrings.add(m.group(2))

		#self.log("Strings:", msgStrings)

		# Find the driver.xml and look for all of the occurences of named items like buttons, etc...

		for filename in xmlIncludedFiles:
			driverPath = os.path.join(self.directory, filename)
			self.processXmlFile(driverPath, msgStrings)

		self.log(msgStrings)

		outputDir = os.path.dirname(self.output)

		if outputDir and not os.path.exists(outputDir):
			os.makedirs(outputDir)

		if not self.dryrun:
			self.log("Writing to:", self.output)
			with codecs.open(self.output, "w", "utf-8") as poFile:
				for msg in msgStrings:
					if msg != None:
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
		self.addNodeTextToList(names, msgStrings)

		self.log("\nFinding Action EditProperty help text:")
		names = root.findall(".//UI/Actions/Action/EditProperty[@helpText]")
		self.addAttribToList(names, msgStrings, "helpText")

		self.log("\nFinding Action Filter names:")
		names = root.findall(".//UI/Actions/Action/Filters/Filter/Name")
		self.addNodeTextToList(names, msgStrings)

		self.log("\nFinding Tab Names:")
		names = root.findall(".//UI/Tabs/Tab/Name")
		self.addNodeTextToList(names, msgStrings)

		self.log("\nFinding Notification Button Names:")
		names = root.findall(".//UI/DriverNotifications/Notification/Buttons/Button/Name")
		self.addNodeTextToList(names, msgStrings)

		self.log("\nFinding Search Filter Names:")
		names = root.findall(".//UI/Search/Filters/SearchFilter/Name")
		self.addNodeTextToList(names, msgStrings)

		self.log("\nFinding Settings Screen Labels:")
		names = root.findall(".//UI/Screens/Screen//Label")
		self.addNodeTextToList(names, msgStrings)

		self.log("\nFinding Settings Screen Headers:")
		names = root.findall(".//UI/Screens/Screen//HeaderTxt")
		self.addNodeTextToList(names, msgStrings)

		self.log("\nFinding Settings Screen Button Names:")
		names = root.findall(".//UI/Screens/Screen//Button/Name")
		self.addNodeTextToList(names, msgStrings)

		self.log("\nFinding Settings Screen ComboBox Item Values:")
		names = root.findall(".//UI/Screens/Screen//ComboBox//Item/Value")
		self.addNodeTextToList(names, msgStrings)


	def addNodeTextToList(self, nodes, msgSet):
		for node in nodes:
			self.log(node.text)
			msgSet.add(node.text)

	def addAttribToList(self, nodes, msgSet, attribName):
		for node in nodes:
			self.log(node.attrib[attribName])
			msgSet.add(node.attrib[attribName])



if __name__ == "__main__":
    cpo = CreatePO()
    sys.exit(cpo.main())