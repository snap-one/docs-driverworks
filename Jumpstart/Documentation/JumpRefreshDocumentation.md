JumpRefresh is a program that is a companion tool to JumpStart. While
JumpStart will create source code for a new driver, JumpRefresh will
only copy template files that are not intended to be changed by the
developer into the driver’s source code. The intention is that the
developer can update his driver to the latest template code without
overwriting the changes and addition that he added to the code after its
initial creation.

The program takes the name of a .jumprefresh file as a parameter. The
file is a JSon file that has the information about where the template
code is located and where the source directory for the driver source
code is located. It also has a list of which proxy and communication
modules should be updated.

Example of executing JumpRefresh:

python JumpRefresh.py avswitch-ACME.jumprefresh

Example of file contents:

{

"TemplateDir": "\\develop\\control4\\DriverDev\\drivers-template-code",

"DriverDir": "C:\\develop\\avswitch-ACME",

"Proxies": \[

> "AV Switch"

\],

"Communications": \[

> "serial"

\]

}
