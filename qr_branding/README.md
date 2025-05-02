[copyright]: # (Copyright 2020 Wirepath Home Systems, LLC. All rights reserved.)

#  QR Code Implementation Guide


#### Using QR Codes to Identify and Download Device Drivers in Composer Express (CE)

Composer Express version 2.9.0 and later support the ability for a device driver to be downloaded by way of scanning a Quick Response code (QR code). QR codes are useful as they can be placed on a product, product packaging, within documentation or embedded on a product webpage.  When scanned within the Composer Express (CE) environment, they not only provide a way to download the correct driver, but also offer a convenient way to build a project at an offsite location.

For example, when an installer using Composer Express scans a Control4 QR code, CE reads the code and provides the ability for a driver to connect to the code. Composer Express will then download the driver and also provide the ability to place that driver in a desired room within the project.

The use of QR codes to download drivers is recommended for any device except those that are controller with an IP or ZigBee driver. For IP controlled devices, Control4 strongly encourages manufacturers to implement Control4's Simple Device Discovery Protocol (SDDP) to offer an easy driver download identification experience. For a ZigBee device, when its identification process is initiated, then Composer Express will automatically discover it and the associated driver will be downloaded into the project.


#### Creating QR Codes
Numerous QR Code generation utilities are available and acceptable for creating a QR code to support driver downloads.  Most support the ability to create a code for numerous items such as URLs, images or any number of file types.

For the purposes of a creating a QR code for driver download, the utility needs to support text to QR creation. The text that comprises the QR code includes three parameters: the manufacturer name, the device model number and the driver name.

For example, when the following text is entered into a QR code generator the code to the right is created:

![qr_1]


It is important to note that the name of the driver defined in the text of the QR code must exactly match the text defined in the driver's name XML element. Using the example above, control4_device would need to match the driver's XML of:

`<name>control4_device.c4z</name>`

Driver names with either .c4z or .c4i extensions can be included in the QR code.

Once the QR code is created, it needs to be scaled and branded. The guidelines for scaling and branding the QR code can be found within the DriverWorks SDK in the following directory:

`DriverWorks SDK\Documentation\QR Branding`

For example, the code created for the example in this document would look like this:

![qr_2]


#### QR Codes and ComposerExpress
The dealer or installer experience when using QR codes to add device drivers is very straightforward. With the project loaded and the Design page open, the "+" button is selected to Add a Device.

![qr_3]

From the Add Device page, the Scan QR Code button is selected:

![qr_4]

The mobile device is held approximately 8" from the QR code to initiate the scan process:

![qr_5]

When the code is scanned, the Add Device page is displayed. At this point, the installer can select the room where the device will reside and rename the driver if desired.

![qr_6]

When the Add Device button is selected, the driver is downloaded to the controller and installed into the project. It is then ready for identification and configuration.



## Copyright
Copyright 2022 Snap One, LLC. All rights reserved. Control4 and Snap AV and their respective logos are registered trademarks or trademarks of Wirepath Home Systems, LLC, dba “Control4” and/or dba “SnapAV” in the United States and/or other countries. Other names and brands may be claimed as the property of their respective owners. All specifications subject to change without notice.


[qr_1]:https://github.com/snap-one/docs-driverworks/raw/media/images/qr_1.png
[qr_2]:https://github.com/snap-one/docs-driverworks/raw/media/images/qr_2.png
[qr_3]:https://github.com/snap-one/docs-driverworks/raw/media/images/qr_3.png
[qr_4]:https://github.com/snap-one/docs-driverworks/raw/media/images/qr_4.png
[qr_5]:https://github.com/snap-one/docs-driverworks/raw/media/images/qr_5.png
[qr_6]:https://github.com/snap-one/docs-driverworks/raw/media/images/qr_6.png
