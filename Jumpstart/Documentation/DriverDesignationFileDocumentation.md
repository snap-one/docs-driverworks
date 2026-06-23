A driver designation file is a required Json file used as input to
JumpStart. This file will provide the basic information to JumpStart for
it to generate a basic C4Z driver file.

**Example:**

C:\\ python JumpStart.py SampleDriverFiles/AcmeTV.json

The information is provided by Json elements beginning at the root
level.

DriverName

> *This is a string value and will be the name of the generated C4Z
> driver file. If it is not included, the value will default to
> “Unknown”.*

**Example**:

"DriverName": "tv-ACME",

Copyright

> *This is a string value that will be included in the copyright notice
> in the header of each of the generated source files and in the
> driver.xml file. If it is not included, the value will default to “”.*

**Example**:

"Copyright": "ACME Electronics LLC.",

Manufacturer

> *This is a string value that will be included in the \<manufacturer\>
> tag in the driver.xml file. If it is not included, the value will
> default to “”.*

**Example**:

"Manufacturer": "ACME",

Creator

> *This is a string value that will be included in the \<creator\> tag
> in the driver.xml file. If it is not included, the value will default
> to “”.*

**Example**:

"Creator": "Control4",

Name

> *This is a string value that will be included in the \<name\> tag in
> the driver.xml file. If it is not included, the value will default to
> “Unknown”. This in turn, is the value that Composer will use to name a
> device when an instance of the driver is added to the project.*

**Example**:

"Name": "ACME Pretend TV",

Model

> *This is a string value that will be included in the \<model\> tag in
> the driver.xml file. If it is not included, the value will default to
> “”.*

**Example**:

"Model": "VAST-WASTELAND 64",

Encrypt

> *This is a string Boolean value that will indicate whether the driver
> should be encrypted. If this is True, ‘encryption=”2”’ will be added
> to the script attributes in driver.xml. (Note that if you use
> CreateC4Z to build the driver, it will set or clear the encryption
> flag at build time.) If not included, the value will default to
> “False”.*

**Example**:

"Encrypt": "True",

UseCommandQueue

> *This is an optional Boolean tag that specifies if the developer
> wishes to include a standard command queue in the driver. If it is set
> to “True” the file <u>command_queue.lua</u> will be included in the
> list of generated files. If not included, the value will default to
> “True”.*

**Example**:

"UseCommandQueue": "True",

MiniApps

> *If the driver includes some type of AV, MiniApp connections may be
> desired. This is an array of strings that will specify the desired
> MiniApp names.*

**Example**:

"MiniApps": \[

"MiniApp 1",

"MiniApp 2",

"MiniApp 3"

\],

Properties

> *This is an array of Json elements that specify additional properties
> that should appear on the properties page. All properties are required
> to have a “Name” and “Type” field. All properties may optionally
> designate “Default”, “ReadOnly” and “Tooltip” fields, even though
> “Default” and/or “ReadOnly” make little sense for certain property
> types. LABEL properties will always be “ReadOnly”. All other property
> types will default to “Not ReadOnly” if the field is not specified.*
>
> *If a property is “Not ReadOnly” JumpStart it will also insert stub
> routines into the source code to handle the property change.*
>
> *Currently the supported property types are:*
>
> STRING
>
> RANGED_INTEGER
>
> RANGED_FLOAT
>
> LIST
>
> DYNAMIC_LIST
>
> COLOR_SELECTOR
>
> VARIABLE_SELECTOR
>
> DEVICE_SELECTOR
>
> LABEL
>
> *RANGED_INTEGER and RANGED_FLOAT properties will require “Min” and
> “Max” fields.*
>
> *LIST properties will require a “ListMembers” field that is an array
> of string values to include in the list.*
>
> *VARIABLE_SELECTOR properties will require a “VariableType” field to
> specify which type of variables it is using. Valid values are:*
> string*,* boolean*,* number*,* float*,* device*,* media*,* user*, and*
> all*.*
>
> *DEVICE_SELECTOR properties will require an “Items” field that is an
> array of strings that are driver name files. The property will filter
> for devices that are instances of the drivers listed.*

**Examples**:

"Properties": \[

> { "Name": "Book Title",
>
> "Type":"STRING",
>
> "ReadOnly": "False",
>
> "Default":"-"
>
> },
>
> { "Name": "Snow Depth",
>
> "Type":"RANGED_INTEGER",
>
> "ReadOnly": "True",
>
> "Default":"3",
>
> "Min":"1",
>
> "Max":"15"
>
> },
>
> { "Name": "Choose State",
>
> "Type":"LIST",
>
> "ReadOnly": "False",
>
> "Default":"Idaho",
>
> "ListMembers": \[
>
> "Idaho",
>
> "Illinois",
>
> "Indiana",
>
> "Iowa",
>
> \],
>
> "Tooltip": "States that begin with an I."
>
> },
>
> { "Name": "Separate Label 1",
>
> "Type":"LABEL",
>
> "Default":"--- Other Properties ---",
>
> "Tooltip": "Properties type separator"
>
> },
>
> { "Name": "Str1",
>
> "Type":"STRING",
>
> "ReadOnly": "False",
>
> "Default":"First Try",
>
> "Tooltip": "First String"
>
> },
>
> { "Name": "Str2",
>
> "Type":"STRING",
>
> "ReadOnly": "True",
>
> "Default":"Second Chance",
>
> "Tooltip": "Second String"
>
> },

{ "Name": "ColorSel1",

> "Type":"COLOR_SELECTOR",
>
> "Default":"255, 0, 0",
>
> "Tooltip": "Test Color Select"
>
> },
>
> { "Name": "DynList1",
>
> "Type":"DYNAMIC_LIST",
>
> "Tooltip": "Test Dynamic List"
>
> },
>
> { "Name": "VarSel1",
>
> "Type":"VARIABLE_SELECTOR",
>
> "VariableType": "boolean",
>
> "Tooltip": "Test Var Select b"
>
> },
>
> { "Name": "VarSel2",
>
> "Type":"VARIABLE_SELECTOR",
>
> "VariableType": "string",
>
> "Tooltip": "Test Var Select s"
>
> },
>
> { "Name": "VarSel3",
>
> "Type":"VARIABLE_SELECTOR",
>
> "VariableType": "number",
>
> "Tooltip": "Test Var Select n"
>
> },
>
> { "Name": "VarSel4",
>
> "Type":"VARIABLE_SELECTOR",
>
> "VariableType": "float",
>
> "Tooltip": "Test Var Select f"
>
> },
>
> { "Name": "VarSel5",
>
> "Type":"VARIABLE_SELECTOR",
>
> "VariableType": "device",
>
> "Tooltip": "Test Var Select d"
>
> },
>
> { "Name": "VarSel6",
>
> "Type":"VARIABLE_SELECTOR",
>
> "VariableType": "media",
>
> "Tooltip": "Test Var Select m"
>
> },
>
> { "Name": "VarSel7",
>
> "Type":"VARIABLE_SELECTOR",
>
> "VariableType": "user",
>
> "Tooltip": "Test Var Select u"
>
> },
>
> { "Name": "VarSel8",
>
> "Type":"VARIABLE_SELECTOR",
>
> "VariableType": "all",
>
> "Tooltip": "Test Var Select a"
>
> },
>
> { "Name": "DevSel1",
>
> "Type":"DEVICE_SELECTOR",
>
> "MultiSelect": "True",
>
> "Items":\["light.c4i", "lock.c4i"\],
>
> "Tooltip": "Test Dev Select 1"
>
> },
>
> { "Name": "DevSel2",
>
> "Type":"DEVICE_SELECTOR",
>
> "MultiSelect": "False",
>
> "Items":\["tv.c4i", "appletv.c4i"\],
>
> "Tooltip": "Test Dev Select 2"
>
> },
>
> { "Name": "DevSel3",
>
> "Type":"DEVICE_SELECTOR",
>
> "Items":\["tv.c4i", "appletv.c4i"\],
>
> "Tooltip": "Test Dev Select 3"
>
> }

\],

Actions

> *This is an array of strings that will specify any items that you wish
> to appear on the Actions tab. It will also insert stub routines into
> the source code to handle them*

**Example**:

"Actions": \[

"Action 1",

"Action 2"

\]

Events

> *This is an array of Json elements that will specify possible system
> events that your driver can trigger. Each Json element will have a
> string for the event name and a string for the event description.
> These will show up in the programming tab in Composer so that system
> programming sequences can be triggered. It will also insert stub
> routines into the source code to trigger them*

**Example**:

"Events": \[

> {
>
> "Name": "Event 1",
>
> "Description": "This is the first event"
>
> },
>
> {
>
> "Name": "Event 2",
>
> "Description": "This is the second event"
>
> }
>
> \]

Commands

> *This is an array of Json elements that will specify possible commands
> that can be sent to this driver via programming. Each Json element
> will have a string for the command name and a string for the command
> description.*
>
> *Optionally, there can also be a list of parameters for the command.
> Each element in the parameters list will be a JSon dictionary with the
> information for one parameter. Each parameter will have an element for
> the parameter name and an element for its type. Currently supported
> parameter types are:*
>
> *STRING*
>
> *Requires no additional information.*
>
> *RANGED_INTEGER*
>
> *Requires a “Minimum” element and a “Maximum” element.*
>
> *LIST*
>
> *Requires an “Items” element which is a list of all the possible
> values that this parameter can take on.*
>
> *DEVICE_SELECTOR*
>
> *Requires an “Items” element which is a list of all the possible
> device types (designated by their c4i or c4z file name) that this
> parameter can target.*
>
> *Optionally, it can have a “Multiselect” Boolean element which
> specifies whether multiple instances of a given device type can be
> selected.*
>
> *COLOR_SELECTOR*
>
> *Requires no additional information.*
>
> *These will show up in the programming tab in Composer under “Device
> Specific Commands” which is part of the Commands tab. It will also
> insert stub routines into the source code to handle the commands when
> they are called.*

**Example**:

"Commands": \[

{

"Name": "Command 1",

"Description": "This is the first command"

},

{

"Name": "Command 2",

"Description": "This is the second command",

"Params": \[

{

"Name": "HitPoints",

"Type": "RANGED_INTEGER",

"Default": "12",

"Minimum": "3",

"Maximum": "27"

},

{

"Name": "Dwarves",

"Type": "LIST",

"Default": "Sneezy",

"Items": \[

"Happy",

"Sleepy",

"Grumpy",

"Sneezy",

"Bashful",

"Dopey",

"Doc"

\]

},

{

"Name": "Email",

"Type": "STRING"

},

{

"Name": "Rooms",

"Type": "DEVICE_SELECTOR",

"Multiselect": "True",

"Items": \[

"roomdevice.c4i"

\]

},

{

"Name": "Color",

"Type": "COLOR_SELECTOR"

}

\]

}

\]

Communications

> *This is an array of Json elements that specify the desired means of
> communication for the driver. If the driver will have multiple ways of
> communicating, there should be one element per method. Each method
> will have two sub-elements*
>
> ComType
>
> *This is a string value that specifies the name of the communication
> method. Supported values are: Serial, Network, IP, URL, Zigbee, IR,
> and Custom.*
>
> ComSettings
>
> *This is an element that can contain sub-elements of settings for the
> specific communication method. The key/value pairs in ComSettings will
> be different for each communication type. If no values are entered,
> then the values will default to the values specified in
> JumpStartConfig.json.*

**Examples**:

"Communications": \[

{

"ComType": "Network",

"ComSettings": {}

},

{

"ComType": "Serial",

"ComSettings": {}

},

{

"ComType": "IR",

"ComSettings": {}

}

\]

=================================================================

"Communications": \[

{

"ComType": "Zigbee",

"ComSettings": {}

}

\]

=================================================================

"Communications": \[

{

"ComType": "Network",

"ComSettings": {

"Address": "192.168.1.1",

"Port": 82

}

},

{

"ComType": "Serial",

"ComSettings": {

"BaudRate": 19200,

"DataBits": 8,

"StopBits": 1

}

},

{

"ComType": "IR",

"ComSettings": {}

}

\],

=================================================================

Proxies

> *This is an array of Json elements. Each element contains the
> information for a proxy that will be included in the driver. If the
> driver only has one proxy, this array will only have one element.*
>
> *Sub-elements in the proxy information element are:*
>
> Proxy
>
> *This lists the proxy type. This will cause the template code for this
> type of proxy to be pulled into the C4Z file. Supported proxy types
> are <u>Amplifier</u>, <u>Audio Switch</u>, <u>AV Switch</u>,
> <u>Light</u>, <u>Lock</u>, <u>Media Player</u>, <u>Pool</u>,
> <u>Receiver</u>, <u>Security Panel</u>, <u>Security Partition</u>,
> <u>Tuner</u>, and <u>TV</u>. You may also specify <u>Combo</u> so that
> no template proxy code will be pulled in. If multiple instances of a
> proxy are included, the code and capabilities will only be included in
> the file once.*
>
> Name
>
> *This is the name of this instance of the proxy as it will show up in
> Composer and in Navigators.*
>
> AVConnections
>
> *This is only relevant if the proxy type is one of the AV type of
> proxies. This will be a collection of information blocks for different
> groups of AV binding types. The connection groups are*:
>
> AudioVideoInputs
>
> VideoOnlyInputs
>
> AudioOnlyInputs
>
> AudioVideoOutputs
>
> VideoOnlyOutputs
>
> AudioOnlyOutputs
>
> *Each one of these groups will contain an array of elements that will
> specify the information for each desired connection.*
>
> Each connection element will contain a sub-element for:
>
> Name
>
> *This will be the name of the connection as it appears in the
> driver.xml file and then in Composer.*
>
> Attributes
>
> *This will be an array of information elements for the connection.*
>
> *The most common elements are:*
>
> VideoClasses
>
> AudioClasses
>
> *Each of these element types are arrays of string that specifies the
> types of connection classes for the particular connection. If these
> are not listed, the connections class lists will be taken from the
> default lists specified in JumpStartConfig.json.*

**Examples**:

"Proxies": \[

{

"Proxy": "TV",

"Name": "AcmeTV",

"AVConnections": {

"AudioVideoInputs": \[

{

"Name": "AV",

"Attributes": {

"VideoClasses": \[

"COMPOSITE"

\],

"AudioClasses": \[

"STEREO"

\]

}

},

{

"Name": "INPUT CBL/SAT",

"Attributes": {}

},

{

"Name": "INPUT PC",

"Attributes": {}

},

{

"Name": "INPUT STRM BOX",

"Attributes": {}

}

\],

"AudioOnlyInputs": \[\],

"VideoOnlyInputs": \[

{

"Name": "Antenna TV (ATV)",

"Attributes": {

"VideoClasses": \[

"RF_UHF_VHF"

\]

}

},

{

"Name": "CABLE TV (CATV)",

"Attributes": {

"VideoClasses": \[

"RF_CABLE"

\]

}

},

{

"Name": "HDMI 1",

"Attributes": {

"VideoClasses": \[

"HDMI"

\]

}

},

{

"Name": "HDMI 2",

"Attributes": {

"VideoClasses": \[

"HDMI"

\]

}

}

\],

"AudioVideoOutputs": \[\],

"AudioOnlyOutputs": \[

{

"Name": "Output",

"Attributes": {

"AudioClasses": \[

"DIGITAL_OPTICAL"

\]

}

},

{

"Name": "Audio Out 2",

"Attributes": {}

}

\],

"VideoOnlyOutputs": \[\]

}

}

\],

===============================================================

"Proxies": \[

{

"Proxy": "Receiver",

"Name": "ACME Receiver",

"AVConnections": {

"AudioVideoInputs": \[

{

"Name": "INPUT CBL/SAT",

"Attributes": {}

},

{

"Name": "INPUT GAME",

"Attributes": {}

},

{

"Name": "INPUT PC",

"Attributes": {}

},

{

"Name": "INPUT EXTRA1",

"Attributes": {}

},

{

"Name": "INPUT EXTRA2",

"Attributes": {}

},

{

"Name": "INPUT EXTRA3",

"Attributes": {}

},

{

"Name": "INPUT BD/DVD",

"Attributes": {}

},

{

"Name": "INPUT PHONO",

"Attributes": {}

},

{

"Name": "INPUT CD",

"Attributes": {}

},

{

"Name": "INPUT STRM BOX",

"Attributes": {}

},

{

"Name": "INPUT TV",

"Attributes": {}

}

\],

"AudioOnlyInputs": \[

{

"Name": "Audio In 1",

"Attributes": {}

},

{

"Name": "Audio In 2",

"Attributes": {}

},

{

"Name": "Audio In 3",

"Attributes": {}

}

\],

"VideoOnlyInputs": \[

{

"Name": "INPUT AUX",

"Attributes": {

"VideoClasses": \[

"HDMI"

\]

}

},

{

"Name": "Video In 2",

"Attributes": {}

}

\],

"AudioVideoOutputs": \[

{

"Name": "Main Output",

"Attributes": {}

},

{

"Name": "Zone2 Output",

"Attributes": {

"VideoClasses": \[

"HDMI"

\]

}

}

\],

"AudioOnlyOutputs": \[

{

"Name": "Zone3 Output",

"Attributes": {

"AudioClasses": \[

"STEREO"

\]

}

}

\],

"VideoOnlyOutputs": \[

{

"Name": "Video Out 3",

"Attributes": {}

}

\]

}

},

{

"Proxy": "Tuner",

"Name": "AM/FM Tuner"

},

{

"Proxy": "Media Player",

"Name": "ACME Net"

}

\],

=================================================================

"Proxies": \[

{

"Proxy": "Light",

"Name": "AcmeLight"

}

\],

=================================================================

"Proxies": \[

{

"Proxy": "Lock",

"Name": "AcmeLock"

}

\],

=================================================================

"Proxies": \[

{

"Proxy": "Pool",

"Name": "AcmePool"

}

\],

=================================================================
