
# **Welcome to the DriverWorks Software Development Kit!**

![Logo][logo]

The DriverWorks Software Development Kit (SDK) provides dealers and partners with the ability to independently develop custom two-way (Serial & Network) drivers to incorporate new devices into the Control4 environment or to customize existing drivers. DriverWorks uses the Lua programming language, which is delivered within the Composer software application and within the Control4 OS. Completed drivers do not require platform or version-specific compiling. The development kit consists of the Lua Development Environment (included within Composer and the OS), several documentation resources as well sample drivers and code examples.

This area is focused on the delivery of documentation, code samples and some utilities which will help facilitate the development of a DriverWorks driver. However, this is one piece of a larger driver development platform. Not included in this area are:

- SDDP Documentation and Sample Code: SDDP provides automatic device discovery and device pairing with the Conrol4 O.S. For more information regarding SDDP, please see the [sddp][sddp] folder.

- Composer Pro: A licensed version of Composer Pro running on a controller is required for driver modeling and testing.

- Driver Certification: Offers a no-cost opportunity for your products to be formally tested in Control4's certification lab. Once we certify your product drivers interoperate seamlessly with the Control4 platform, then we can collaborate with your company on numerous, beneficial marketing activities. For more information, please see the [driver_certification][driver_certification] folder.

The above components play an important role in ensuring that your driver has complete integration within the Control4 O.S. Use of them requires signing Control4's SDK License Agreement. For more information regarding the licensing agreement, please contact us at: <busdev@control4.com>.

## Getting Started with DriverWorks

**New to DriverWorks?** You'll find [An Introduction to DriverWorks][intro] to be useful reading. The SDK also includes an online, Micro-Certification featuring courses that help a developer learn the concepts required to begin creating drivers for use in Control4 systems. To access the videos, please see the [Education Portal][education].

## DriverWorks Documentation

You are encouraged to review the SDK development documentation through the links provided below. This will ensure that you are using the latest driver development content possible. Significant enhancements and deprecations to the documentation are listed in the What's New sections in each of the repositories.

### DriverWorks Fundamentals

The [DriverWorks Fundamentals Guide][fundamentals] is intended to provide an overview of the fundamental components that make up a device driver as well as the architectural layers that a device driver interacts with. Additionally, The Fundamentals Guide contains Proxy-specific information that falls outside of the functions defined in the proxy documentation.

### DriverWorks Proxy Documentation

Documentation for each of the supported Control4 Proxies can be found using the links below in the table below. Note that if supporting content exists for a specific proxy, it can be found in the [Proxy Specific][fundamentals_proxy_specific] area of the Fundamentals Guide.

|  |   |  |  |
| --- | --- | --- | --- |
| [Amplifier][pp_amplifier] | [Disc Changer][pp_disc]  | [Pool][pp_pool] |  [TV][pp_tv] |
| [Amplifier Nav EQ][pp_amplifier-nav-eq] | [DVD Player][pp_dvd]  | [Projector][pp_projector]| [UI Button][pp_uibutton] |
| [Audio Switch][pp_audioswitch] | [Fan][pp_fan] | [Receiver][pp_receiver] | [XM Tuner][pp_xm]|
| [Audio Video Switch][pp_avswitch]  | [Media Player][pp_mediaplayer]| [Relay][pp_relay] | |
| [Blind][pp_blind] | [Intercom][pp_intercom] | [Satellite Receiver][pp_satellite] | |
| [Camera][pp_camera] | [Keypad][pp_keypad]  | [Security][pp_security]  | |
| [CD Player][pp_cd] | [Light V2][pp_lightv2]  | [Thermostat][pp_tstat] | |
| [Contact][pp_contact] | [Lock][pp_lock] | [Tuner][pp_tuner] | |

### DriverWorks APIs

The [DriverWorks API Reference Guide][api] details each of the Interfaces supported through the DriverWorks SDK. These Interfaces include numerous APIs that can be leveraged by your driver to facilitate communication between the driver and the Control4 O.S.

### DriverWorks XML

The [DriverWorks XML Reference Guide][xml] provides definitions for the XML elements supported in DriverWorks drivers.

### DriverWorks KNX

Control4 supports integration with devices through standardized KNX control network topology. The [DriverWorks KNX Implementation Guide][knx] provides instruction on how to do this. The KNX protocol supports a wide variety of home automation applications including:

- Lighting control
- Heating/ventilation & Air Conditioning control
- Shutter/Blind & Shading control
- Alarm Monitoring
- Energy Management & Electricity/Gas/Water metering
- Audio & video distribution

### DriverWorks and Zigbee

Control4 supports integration with Zigbee devices and DriverWorks includes a [Zigbee Implementation Guide][zigbee].

## Additional DriverWorks Development Resources

The directories at the top of this page contain various resources to support your driver development efforts. They include:

### Driver Development Templates

The SDK includes Driver Development Templates and a utility called JumpStart to accelerate your driver development efforts. Please see the [driver template repository][templates] for more information on how to leverage these templates.

### DriverPackager

Driver Packager is a Python utility used to create individual .c4z files from source code. For more information, please see the [GitHub repository for Driver Packager](https://github.com/snap-one/drivers-driverpackager)

### Icon Templates

The DriverWorks SDK provides templates and instructions on how to create icons that will blend in with the default icons inside Control4 interfaces. Conforming to these guidelines ensures that custom icons feel like part of the system. For more information, please see the [icon_templates][icon_templates] folder.

### Media Service Proxy

Control4's Media Service Proxy (MSP) provides a layer of commands, notifications, events and other data handling elements that will support the development of drivers for media-based services and devices. For more information, please see the [media_service_proxy folder][msp].

### QR Branding

Composer Express supports the ability for a device driver to be downloaded by scanning a Quick Response code (QR code). QR codes are useful as they can be placed on a product, product packaging, within documentation or embedded on a product webpage. For more information, please see the [qr_branding][qr_branding] folder.

### Sample Drivers

The DriverWorks SDK provides code examples as well as sample drivers which are useful in understanding some of the more complex areas of device driver development. The examples found here are referred to throughout the SDK documentation. The [sample_drivers][sample_drivers] directory serves a collection area for that code.

### Table Logger Utility

The Table Logger utility has been provided to assist driver developers in identifying areas within their driver that may be using a growing amount of memory. The utility is executed from within ComposerPro at the driver level on the Lua tab. For more information, please see the [table_logger_utility][table_logger] folder.

### Webview Styleguide

A comprehensive guide of elements used in the Control4 OS3 to assist 3rd party webview developers to achieve a seamless experience in their contribution to extend the system for the end user. For more information, please see the [webview_styleguide][webview_styleguide] folder.

### Control4 Logo Usage

Use of the Control4 logo requires review of the logo Style Guide. In addition to the Style Guide, several asset folders are provided in the control4-logo.zip file. These include logo samples in.png, jpg and .eps formats. Please see the [control4_logo_usage][logo_usage] folder for more information.

### Viewing the SDK Content Offline

If needed, the DriverWorks documentation content can be downloaded and reviewed offline. Please keep in mind that working from previously downloaded content may not always reflect the latest SDK content.

_From Chrome:_ An entire guide can be saved as an HTML file from the Chrome toolbar under: File --> Save Page As and selecting the "Webpage, Complete" option.

_From Safari:_ An entire guide can be saved as a Web Archive file from the Safari toolbar under: File --> Save As and selecting Web Archive as the format.

[intro]: https://snap-one.github.io/docs-driverworks-introduction
[fundamentals]: https://snap-one.github.io/docs-driverworks-fundamentals/
[api]: https://snap-one.github.io/docs-driverworks-api
[knx]:  https://snap-one.github.io/docs-driverworks-knx
[logo]: https://github.com/snap-one/docs-driverworks/blob/media/images/logo.png?raw=true
[icon_templates]: https://github.com/snap-one/docs-driverworks/tree/master/icon_templates
[templates]: https://github.com/snap-one/drivers-template-code-public
[msp]: https://github.com/snap-one/docs-driverworks/tree/master/media_service_proxy
[qr_branding]: https://github.com/snap-one/docs-driverworks/tree/master/qr_branding
[sample_drivers]: https://github.com/snap-one/docs-driverworks/tree/master/sample_drivers
[table_logger]: https://github.com/snap-one/docs-driverworks/tree/master/table_logger_utility
[sddp]: https://github.com/snap-one/docs-driverworks/tree/master/sddp
[driver_certification]: https://github.com/snap-one/docs-driverworks/tree/master/driver_certification
[logo_usage]: https://github.com/snap-one/docs-driverworks/tree/master/control4_logo_usage
[zigbee]: https://snap-one.github.io/docs-zigbee
[webview_styleguide]: https://github.com/snap-one/docs-driverworks/tree/master/webview%20styleguide%20
[education]: https://education.control4.com/enrollments/172695720/details
[pp_amplifier]: https://snap-one.github.io/docs-driverworks-proxyprotocol-amplifier
[pp_amplifier-nav-eq]: https://github.com/snap-one/docs-driverworks-proxyprotocol-amplifier-nav-eq
[pp_audioswitch]: https://snap-one.github.io/docs-driverworks-proxyprotocol-audioswitch
[pp_avswitch]: https://snap-one.github.io/docs-driverworks-proxyprotocol-avswitch
[pp_blind]: https://snap-one.github.io/docs-driverworks-proxyprotocol-blind
[pp_camera]: https://snap-one.github.io/docs-driverworks-proxyprotocol-camera
[pp_cd]: https://snap-one.github.io/docs-driverworks-proxyprotocol-cd
[pp_fan]: https://snap-one.github.io/docs-driverworks-proxyprotocol-fan
[pp_contact]: https://snap-one.github.io/docs-driverworks-proxyprotocol-contact
[pp_disc]: https://snap-one.github.io/docs-driverworks-proxyprotocol-disc
[pp_dvd]: https://snap-one.github.io/docs-driverworks-proxyprotocol-dvd
[pp_mediaplayer]: https://snap-one.github.io/docs-driverworks-proxyprotocol-mediaplayer
[pp_intercom]: https://snap-one.github.io/docs-driverworks-proxyprotocol-intercom
[pp_keypad]: https://snap-one.github.io/docs-driverworks-proxyprotocol-keypad
[pp_lightv2]: https://snap-one.github.io/docs-driverworks-proxyprotocol-lightv2
[pp_lock]: https://snap-one.github.io/docs-driverworks-proxyprotocol-lock
[pp_pool]: https://snap-one.github.io/docs-driverworks-proxyprotocol-pool
[pp_projector]: https://snap-one.github.io/docs-driverworks-proxyprotocol-projector
[pp_receiver]: https://snap-one.github.io/docs-driverworks-proxyprotocol-receiver
[pp_relay]: https://snap-one.github.io/docs-driverworks-proxyprotocol-relay
[pp_satellite]: https://snap-one.github.io/docs-driverworks-proxyprotocol-satellite
[pp_security]: https://snap-one.github.io/docs-driverworks-proxyprotocol-security
[pp_tstat]: https://snap-one.github.io/docs-driverworks-proxyprotocol-tstat
[pp_tuner]: https://snap-one.github.io/docs-driverworks-proxyprotocol-tuner
[pp_tv]: https://snap-one.github.io/docs-driverworks-proxyprotocol-tv
[pp_uibutton]: https://snap-one.github.io/docs-driverworks-proxyprotocol-uibutton
[pp_xm]: https://snap-one.github.io/docs-driverworks-proxyprotocol-xm
[fundamentals_proxy_specific]: https://snap-one.github.io/docs-driverworks-fundamentals/#proxy-specific-information
[xml]: https://snap-one.github.io/docs-driverworks-xml/#beta-xml-documentation
