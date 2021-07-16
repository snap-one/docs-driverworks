[copyright]: # (Copyright 2020 Wirepath Home Systems, LLC. All rights reserved.)

# **Welcome to the DriverWorks Software Development Kit!**

![Logo][logo]

The DriverWorks Software Development Kit (SDK) provides dealers and partners with the ability to independently develop custom two-way (Serial & Network) drivers to incorporate new devices into the Control4 environment or to customize existing drivers. DriverWorks uses the Lua programming language, which is delivered within the Composer software application and within the Control4 OS. Completed drivers do not require platform or version-specific compiling. The development kit consists of the Lua Development Environment (included within Composer and the OS), several documentation resources as well sample drivers and code examples.

This area is focused on the delivery of documentation, code samples and some utlities which will help facilitate the deveopment of a DriverWorks driver. However, this is one piece of a larger driver deveopment platform. Not included in this area are:

- SDDP Documentation and Sample Code: SDDP provides automatic device discovery and device pairing with the Conrol4 O.S. For more information regarding SDDP, please see the [sddp][12] folder.

- Composer Pro: A licensed version of Composer Pro running on a controller is required for driver modeling and testing.

- Driver Certification: Offers a no-cost opportunity for your products to be formally tested in Control4’s certification lab. Once we certify your product drivers interoperate seamlessly with the Control4 platform, then we can collaborate with your company on numerous, benefitial marketing activities. For more information, please see the [driver_certification][13] folder.

The above components play an important role in ensuring that your driver has complete integration within the Control4 O.S. Use of them requires signing Control4's SDK License Agreement. For more information regarding the licensing agreement, please contact us at: busdev@control4.com.


## Getting Started with DriverWorks

If you are new to the DriverWorks SDK you will find [An Introduction to DriverWorks][1] to be useful reading.


## DriverWorks Documentation

- The DriverWorks Fundamentals Guide can be found [here][2].

- The DriverWorks Proxy and Protocol Guide can be found [here][3].

- The DriverWorks API Reference Guide can be found [here][4].

- The DriverWorks KNX Implementation Guide can be found [here][5].

- The Zigbee Implementation content can be found [here][16].

You are encouraged to review the SDK documentation through the links provided above. This will ensure that you are using the latest driver development content possible. Significant enhancements and deprecations to the documentation are listed in the What's New sections of the repositories. If needed, the DriverWorks documentation content can be downloaded and reviewed offline. Please keep in mind that working from previously downloaded content may not always reflect the latest SDK content.

_From Chrome:_

An entire guide can be saved as an HTML file from the Chrome toolbar under: File --> Save Page As and selecting the "Webpage, Complete" option.


_From Safari:_

An entire guide can be saved as a Web Archive file from the Safari toolbar under: File --> Save As.. and selecting Web Archive as the format.


## Additional DriverWorks Development Resources

The directories at the top of this page contain various resources to support your driver development efforts. They include:


#### Driver Development Templates
The SDK includes numerous Driver Development Templates to help jump start your development efforts. Please see the [driver_development_templates][7] directory for the current list of supported templates.


#### Icon Templates

The DriverWorks SDK provides templates and instructions on how to create icons that will blend in with the default icons inside Control4 interfaces. Conforming to these guidelines ensures that custom icons feel like part of the system. For more information, please see the [icon_templates][6] folder.


#### Media Service Proxy

Control4’s Media Service Proxy (MSP) provides a layer of commands, notifications, events and other data handling elements that will support the development of drivers for media-based services and devices. For more information, please see the [media_service_proxy folder][8].


#### QR Branding

Composer Express supports the ability for a device driver to be downloaded by way of scanning a Quick Response code (QR code). QR codes are useful as they can be placed on a product, product packaging, within documentation or embedded on a product webpage. For more information, please see the [qr_branding][9] folder.


#### Sample Drivers

The DriverWorks SDK provides code examples as well as sample drivers which are useful in understanding some of the more complex areas of device driver development. The examples found here are referred to throughout the SDK documentation. The [sample_drivers][10] directory serves a collection area for that code.


#### Table Logger Utility

The Table Logger utility has been provided to assist driver developers in identifying areas within their driver that may be using a growing amount of memory. The utility is executed from within ComposerPro at the driver level on the Lua tab. For more information, please see the [table_logger_utility][11] folder.


#### Control4 Logo Usage

Use of the Control4 logo requires review of the logo Style Guide. In addition to the Style Guide, several asset folders are provided in the control4-logo.zip file. These include logo samples in.png, jpg and .eps formats. Please see the [control4_logo_usage][15] folder for more information.

#### DriverPackager

Driver Packager is a Python utility used to create individual .c4z files from source code. For more information please see: https://github.com/control4/drivers-driverpackager

[1]:	https://control4.github.io/docs-driverworks-introduction/#introduction
[2]:	https://control4.github.io/docs-driverworks-fundamentals/#introduction
[3]:	https://control4.github.io/docs-driverworks-proxyprotocol/#introduction
[4]:	https://control4.github.io/docs-driverworks-api/#introduction
[5]:  https://control4.github.io/docs-driverworks-knx/#knx-and-control4
[logo]: https://github.com/control4/docs-driverworks/blob/media/images/logo1.png?raw=true
[6]: https://github.com/control4/docs-driverworks/tree/master/icon_templates
[7]: https://github.com/control4/docs-driverworks/tree/master/driver_development_templates
[8]: https://github.com/control4/docs-driverworks/tree/master/media_service_proxy
[9]: https://github.com/control4/docs-driverworks/tree/master/qr_branding
[10]: https://github.com/control4/docs-driverworks/tree/master/sample_drivers
[11]: https://github.com/control4/docs-driverworks/tree/master/table_logger_utility
[12]: https://github.com/control4/docs-driverworks/tree/master/sddp
[13]: https://github.com/control4/docs-driverworks/tree/master/driver_certification
[14]: https://github.com/control4/docs-driverworks/tree/master/sdk_licensing_agreement
[15]: https://github.com/control4/docs-driverworks/tree/master/control4_logo_usage
[16]: https://control4.github.io/docs-zigbee/#overview
