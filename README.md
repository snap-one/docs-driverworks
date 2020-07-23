# **Welcome to the DriverWorks Software Development Kit!**

The DriverWorks Software Development Kit (SDK) provides dealers and partners with the ability to independently develop custom two-way (Serial & Network) drivers to incorporate new devices into the Control4 environment or to customize existing drivers. DriverWorks uses the Lua programming language, which is delivered within the Composer software application and within the Control4 OS. Completed drivers do not require platform or version-specific compiling. The development kit consists of the Lua Development Environment (included within Composer and the OS), several documentation resources as well sample drivers and code example.

If you are new to the SDK you will find [An Introduction to DriverWorks][1] to be useful reading.


**The latest version of the DriverWorks SDK is 3.2.0. Currently, 3.2.0 is in a beta state. While use of the beta version of the SDK is encouraged and feedback welcome, changes will continue to be made to the contents of the SDK until an official release is delivered. Anticipation of these changes should be considered in your development efforts when using this version of the SDK.**


## DriverWorks Documentation

- The 3.2.0 DriverWorks Fundamentals Guide can be found [here][2].

- The 3.2.0 DriverWorks Proxy and Protocol Guide can be found [here][3].

- The 3.2.0 DriverWorks API Reference Guide can be found [here][4].


## DriverWorks Development Resources

The directories above contain various resources to support your driver development efforts. They include:

#### Driver Development Templates
The SDK includes numerous Driver Development Templates to help jump start your development efforts. Currently, the following Proxies are supported with a Template:

- AV Switch
- Blind
- Doorstation
- DVD
- Generic Proxy
- IP Camera
- Lock
- Pool
- Projector
- Receiver
- Security Controller
- Thermostat
- TV

#### Icon Templates

The DriverWorks SDK provides templates and instructions on how to create icons that will blend in with the default icons inside Control4 interfaces. Conforming to these guidelines insures that custom icons feel like part of the system. 

#### Media Service Proxy

#### QR Branding

Composer Express supports the ability for a device driver to be downloaded by way of scanning a Quick Response code (QR code). QR codes are useful as they can be placed on a product, product packaging, within documentation or embedded on a product webpage.  When scanned within the Composer Express (CE) environment, they not only provide a way to download the correct driver, but also offer a convenient way to build a project at an offsite location.


#### Sample Drivers

#### Table Logger Utility

[1]:	https://control4.github.io/docs-driverworks-introduction/#introduction
[2]:	https://control4.github.io/docs-driverworks-fundamentals/#introduction
[3]:	https://control4.github.io/docs-driverworks-proxyprotocol/#introduction
[4]:	https://control4.github.io/docs-driverworks-api/#introduction