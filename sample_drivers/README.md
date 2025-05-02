# Sample Drivers

This directory contains several fully-working example drivers to demonstrate more advanced Driverworks functionality. Each driver is presented both as an immediate .c4z file to use in Composer, as well as the source Lua, XML and .c4zproj files to test creation of the driver with your own toolchain.

- `drivers-common-public`: This is a Git submodule of the Driverworks libraries [available on GitHub](https://github.com/snap-one/drivers-common-public). It is included here to make the .c4zproj build files for several of these drivers work.
- `dlna-example`: Based on a limited, early prototype of the My Music (DLNA) driver (which is also available unencrypted in the Composer online database), this driver shows how to create a listening server on a dynamic port that can then be used for callbacks on DLNA/SSDP subscribes.
- `driver-init`: Demonstrates the new-in-OS3.2 features on the `OnDriverInit`, `OnDriverLateInit` and `OnDriverDestroyed` Driverworks functions to indicate *why* the function is being called.
- `generic_http`: Demonstrator driver for the `url.lua` library.
- `generic_tcp`: Simple driver demonstrating using dynamic client sockets in Driverworks
- `idc_client` and `idc_controller`: Demonstrator drivers for best practices when creating a "controller" type driver that handles connection to a hub (or cloud API) with "client" devices. Shows how to discover dynamic IDs of client devices and send commands directly to the right device rather than broadcasting to all client devices.
- `oauth_example`: Demonstrator driver for the `auth_code_grant.lua` library. Note that using this library (and so this example) requires an API key from Control4; please contact your Control4 representative for more details.
- `ssdp_example`: Demonstrator driver for the `ssdp.lua` library.
- `thermostat_v2`: Sample XML files for the Extras and Preset features of the Thermsotat v2 proxy.
- `variable_parser`: Listens to a specific variable on a specific device. When that variable changes, provides `NUMBER`, `STRING` and `BOOL` variables to match , allowing for conversion from a `NUMBER` to a `STRING` (and possibly vice-versa). Also includes capabilities for matching a Lua pattern to a `STRING` variable and providing captured output on additional variables.
- `websocket`: Demonstrator driver for the `websocket.lua` library.
- `sample_custom_select` - This driver is intended to support the Custom Select implementation documentation found here: https://snap-one.github.io/docs-driverworks-fundamentals/#custom-select-implementation
