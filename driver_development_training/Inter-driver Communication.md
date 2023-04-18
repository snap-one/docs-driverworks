# Inter-driver Communication

## Introduction

This training module will expand on the definition of proxy and protocol drivers, using previous examples and adding new demonstrations of communicating between different instances of drivers in a project.  This will primarily be done using the InterDriver Communications (IDC) [Client](https://github.com/snap-one/docs-driverworks/blob/master/sample_drivers/idc_client.c4z) and [Controller](https://github.com/snap-one/docs-driverworks/blob/master/sample_drivers/idc_controller.c4z) drivers available from [this repository](https://github.com/snap-one/docs-driverworks) as an example environment.

## Setup

- Download the IDC [Client](https://github.com/snap-one/docs-driverworks/blob/master/sample_drivers/idc_client.c4z) and [Controller](https://github.com/snap-one/docs-driverworks/blob/master/sample_drivers/idc_controller.c4z) drivers if you have not done so already. Ensure that the filenames saved are `idc_client.c4z` and `idc_controller.c4z`, and that they do not contain any additional characters (for example, Windows will often append a `(1)` to the first part of a filename if you already have the file downloaded).
- Open Composer Pro, and connect to your controller.
- Click the `Driver` menu item, the select `Add or Update Driver or Agent`
- Navigate to the downloaded `idc_client.c4z` file, and click `Open`
  - If you already have the latest version of this driver on your system, you will see a dialog titled `Overwrite Driver or Agent` - click `Yes` to ensure that you have the latest downloaded version.
- You should now see a dialog titled `Update Succeeded`
- Repeat these steps for the `idc_controller.c4z` driver.
- Create a new room in your project, and rename it `Lua IDC Testing`
- On the `Search` tab in the `System Design` view in Composer, make sure that `Local` is checked, and then search for `IDC`
- Add one copy of the `InterDriver Comms Controller` driver to your project into the `Lua IDC Testing` room.
- Select the newly added `InterDriver Comms Controller` driver
- On the `Actions` tab, select `Add Client Devices`
- For the `ID_1` option, enter `Test1` and then click `OK`.  This will add a driver named `Client Test1 - AutoAdded` to the project.
- Add the TV driver of your choice to this room.  For this demonstration, we will use the `Insignia NS-LCD46` driver available in the Online driver database.
- On the `Connections` view in Composer, connect the HDMI output of the `Client Test1 - AutoAdded` media player to the HDMI 1 input on your TV driver.
- On the `System Design` view in Copmoser, select the `Lua IDC Testing` room and confirm that the `Client Test1 - AutoAdded` device is visible in Available Audio Sources and Available Video Sources for the room.
- Refresh Navigators from Composer

## Initial demonstration

The IDC Client driver is a media player driver, so has a UI visible on Navigator.  We haven't defined a protocol for this driver to do any media playback control on a physical device; instead, we're using it to demonstrate how to send commands from one driver to another.

The IDC Client driver is set up to send all commands it receives onwards to the IDC Controller driver.  There are two possible ways of doing this:

- using the `IDC Connection` connection between the drivers (visible on the `Connections` tab in Composer when selecting either the `IDC Controller` or `IDC Client` driver)
- using a direct-to-driver command that uses the driver ID of the IDC Controller driver.

Both of these are used by the IDC client driver; which one is used is chosen randomly by default
