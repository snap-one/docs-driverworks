# Sample Light Driver for Driverworks Training

This is a *very* simple driver to demonstrate a couple of key concepts for working with Control4 drivers in Driverworks.

The driver emulates a basic dimmable light.  The actual connection to a light API is left for a future exercise.

The [Light V2 Proxy](https://snap-one.github.io/docs-driverworks-proxyprotocol/#light-v2-capabilities) is used in this driver to provide a user interface and some simple Driverworks callbacks to capture and process.

The `driver.xml` and `driver.c4zproj` files have been created already.  You will need to use the [DriverPackager](https://github.com/snap-one/drivers-driverpackager) tool to create any modified .c4z files for loading onto your controller.

The aim for this driver is to make a driver that can respond to the commands from Navigator and correctly set the feedback.  This will demonstrate the `ReceivedFromProxy` callback and the `C4:SendToProxy` function calls which are the primary interaction points for any driver that implements a proxy.

The three named lua files (`1 - minimal skeleton.lua`, `2 - initial basic handlers.lua` and `3 - handle navigator.lua`) show the three early stages of development most drivers will go through when initially investigating a new proxy or API:

- `1 - minimal skeleton.lua` shows a bare skeleton (which leverages some of the functions that the `handlers.lua` file from one of the [provided template repositories](https://github.com/snap-one/drivers-common-public) that Control4 publishes).  This skeleton file won't do much when interacting with the driver except print out to the Lua Output window when things happen that might be worth capturing.
- `2 - initial basic handlers.lua` adds some handlers for some of the properties, actions and proxy calls that the driver should expect to handle to continue with development.  In particular, the Set Online handler enables/disables whether the rest of the system will be able to interact with the proxy, as per the [proxy documentation](https://snap-one.github.io/docs-driverworks-proxyprotocol/#min-on)
- `3 - handle navigator.lua` adds a handler for the command that will be received to control the light.  This can be triggered either by interacting with a Control4 UI, or by double clicking on the light in Composer (this is called the "Control-Control" for Reasons Immemorial).

As an exercise for the reader, there are other properties to implement handlers for, and these can be extended to add setup for the proxy.
