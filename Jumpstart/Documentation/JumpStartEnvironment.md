The JumpStartEnvironment.json file contains settings used by JumpStart
to configure the environment for the initial generation of the new
driver. Generally, the settings in this file would be consistent for a
given developer’s environment and not need to change with each new
driver generated. They will not affect the final driver product, just
the processes the developer likes to use.

A different Json file with the same format can optionally be given as a
second parameter to JumpStart. If the second file is not specified,
JumpStart will attempt to open JumpStartEnvironment.json. If that file
doesn’t exist, then each field will just use its default value.

**Example:**

C:\\ python3 JumpStart.py DriverFiles/AcmeTV.json AltEnv.json

The Json elements in the file are:

General

> *The sub-elements in General tell JumpStart where to find information,
> where to store files, and settings for the initial generation of the
> driver source code.*
>
> Possible sub-elements of General are:
>
> TemplateDir
>
> *This is a string that tells JumpStart where to find the Control 4
> template code. JumpStart assumes that the drivers will be generated
> from this code. These files can be located anywhere that can be
> reached by a valid path string. Copies will be made of the needed
> template code files and stored in the generated source code
> directories for the new C4Z driver. If this element is not included,
> its default value will be “”.*
>
> WorkDir
>
> *This is a string that specifies the name of the parent directory
> where JumpStart will create the source code for the new driver.
> JumpStart will create a directory with the same name as the new driver
> and then create driver-specific files there and copy the needed
> template directories in as subdirectories. If this value is not
> included, its default value will be “”.*
>
> IncludeLuaCheck
>
> *This is a Boolean string that specifies whether JumpStart should
> generate files to support Luacheck. LuaCheck is a command-line tool
> for linting and static analysis of Lua Code. It can be found at
> <https://luarocks.org/modules/mpeterv/luacheck> Some developers have
> found it useful to use this tool. If this value is “True”, then
> JumpStart will generate a .luacheckrc file that Luacheck can use to
> check the source code. It will also generate a validate.bat file that
> can be used to call Luacheck on all the source files. If this value is
> not included, its default value will be “False”.*

**Example**:

> "General": {
>
> "TemplateDir": "..\\drivers-template-code",
>
> "WorkDir": "NewDrivers",
>
> "IncludeLuacheck": "True",
>
> },

Build

> *This is an optional entry that can be used to generate files for the
> developer’s preferred build method.*
>
> Possible sub-elements of Build are:
>
> BuildMethod
>
> *This specifies the preferred build program. Supported methods are
> <u>DriverPackager</u> and <u>CreateC4Z</u>. If this entry is not
> included, the build method will default to “custom” and no special
> build files will be generated.*
>
> *If <u>DriverPackager</u> is specified, then a c4zproj file and a
> squishy file will be generated.*
>
> *If <u>CreateC4Z</u> is specified, then a cc4zmanifest file will be
> generated.*
>
> AdditionalFiles
>
> *This specifies any additional files that the developer may want to
> have included in the source directory. The files are specified by path
> names that JumpStart can access and are copied into the source
> directory. Any text strings in the source files of ^@JSPROJ^ will be
> replaced by the target name of the driver.*

**Example**:

> "Build": {
>
> "BuildMethod": "CreateC4Z",
>
> "AdditionalFiles":\[
>
> "ExtraBatchFiles\\dev.bat",
>
> "ExtraBatchFiles\\rel.bat",
>
> "ExtraBatchFiles\\rel.sh"
>
> \]
>
> },
