# Amazon Fire TV

This driver enables control of an Amazon Fire TV.

The driver allows transport control of the Fire TV.  It also provides metadata feedback of the currently active app, and selection of any of the installed apps on the Fire TV.

Universal Minidrivers are supported by this driver.

The Fire TV Apps component of this driver shows all apps installed on the Fire TV.  Adding to or removing from this page can be done by installing or deleting apps from the Fire TV using the Fire TV on-screen Apps page.

No additional hardware is required to control the Fire TV, and ADB debugging does NOT need to be enabled.

**This driver requires Control OS 3.0.0 or later to operate.**

**This driver requires the Fire TV system to be updated to the latest firmware version.**

## Notes

The [original Fire TV box](https://developer.amazon.com/docs/fire-tv/device-specifications-fire-tv-pendant-box.html?v=ftvgen1) cannot be controlled by this driver.

While this driver can be used to control the Fire TV media playback functions on a Fire TV Edition

At this time, the MSP "Grid View" of apps that are installed on the Fire TV (named Fire TV Apps) is unavailable.  The driver cannot show or list the apps that are installed on the Fire TV.

## Installation

### Pre-Control4 Setup

**NOTE**: The holder of the Amazon account must be the one to join the Fire TV to their account (this is done automatically if they purchase direct from Amazon) and perform the initial setup.  This is an Amazon requirement.  DO NOT ask the customer for their Amazon credentials.

Install, commission and test the Fire TV.  Make sure the Fire TV device is fully functional before integrating with Control4.  It is not possible to do any configuration of the Fire TV from the Control4 driver.

Please ensure that you "Check for Updates" on the Settings > My Fire TV > About page, until the screen shows "Your Fire TV is up to date.

### Adding the Driver

You must add and configure one Fire TV driver to the project for each Fire TV you wish to control.

### Properties

#### Driver Version [READONLY]

Displays the version of the driver currently running and installed on the.

#### Debug Mode [ **Off** | On ]

Set this to On if technical support needs you to capture logs from the driver.

#### Fire TV [READONLY]

Displays the Fire TV that this driver is set to control.

#### Fire TV Selector [DYNAMIC LIST]

Select from the drop down list the Fire TV that this driver should control.

#### Passthrough Mode [ **Off** | On ]

Set this to On if you want a selected Universal Minidrver to remain the selected source in a room.

#### On Power Off [ **Do Nothing** | Home | Off ]

Choose what command to send to the Fire TV when a Power Off command is received.

#### On Power On [ **Do Nothing** | Home ]

Choose what command to send to the Fire TV when a Power On command is received.  The driver will always send a "wakeup" command before sending the selected command.

#### MENU, GUIDE, INFO, CANCEL, PVT, STAR, POUND Buttons [ Do Nothing | Home | Back | Menu ]

Set which command should be sent to the Fire TV when the specified button press is received by the Fire TV driver.

### Actions

#### Rescan For Fire TVs

This action triggers a new discovery scan for Fire TV devices on the local network.  It is not normally required as this happens regularly, but during troubleshooting may be useful to force the scan immediately.

### Hiding Devices

All Fire TV App Switcher components will be automatically hidden for you when a Refresh Navigators is issued.  The Fire TV Apps component will also be hidden at the same time.

## Support

For support on this driver please contact Control4 technical support or your local Control4 distributor.

### Troubleshooting

The most likely cause of a problem with the Fire TV integration is not being in the latest firmware.  Please ensure that the Fire TV has the latest firmware installed on the Settings page.

If the Settings page reports that no new firmware is available, try power cycling the Fire TV (remove the power from the Fire TV to do this).  This will trigger a rediscovery in the driver.

### Auto Update

This driver supports Auto Update when using Control4 OS 3.0.0 or later.  To configure this feature, select the Drivers > Manage Drivers option from the Composer menu bar and switch to the Auto Update tab.

## CHANGELOG

12

- Initial release
