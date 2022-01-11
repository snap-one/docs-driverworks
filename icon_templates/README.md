# Icon Templates Guide


#### Creating Control4 Compatible icons using Templates

Control4 Interfaces give customers control over the technology in their home. To a customer, the software interface "is" the system. 

Iconography is an important part of experience. To provide an elegant product designed for customers with luxury taste, icons should provide a good experience. Icons need to look similar. They should also consistent in size and style. 

For this purpose, Control4 is providing templates and instructions on how to create icons that will blend in with the default icons inside Control4 interfaces. Conforming to these guidelines insures that custom icons feel like part of the system, and not look out of place. 

Use the Adobe Illustrator, Photoshop, or Sketch templates to create your icons. If you are unfamiliar with these tools, seek assistance from someone that knows how to use the tools.


#### What is the difference between Devices and Services?
Devices are physical components of equipment integrated into a Control4 System. 

Services are recognized brands that customers used based on drivers provided by Control4 
(e.g., Tidal driver). Services may also be supported through hardware devices that are 
connected to the Control4 system (e.g., Vudu mini driver linked to a Roku media player).  


#### Device Icon Design Guidelines

![it_1]

- Artwork for device icons should be simplified and vector-based (not a photo) and represent the device’s most recognizable or signature shape and color(s). This may include the products logo as it appears on the device.

- Because the device’s name will likely be displayed below the icon, placing additional text or logos on the device icon beyond what is actually on the physical device may be redundant and is discouraged.


#### Service Icon Design Guidelines

![it_2]

- Artwork used for service icons should have a simple, clear, app-like appearance. Usually displaying an icon or logo mark. 

- Service icons may be any shape. 

- If an icon or logo is complex, a background shape may be used to improve visibility. 

- Control4 uses square icons for services. 

If the service is accessed via a particular hardware device, Control4 will typically use the full brand mark with logo bug and logo type to distinguish from a "native" service on the Control4 system. For example, Pandora is offered as native service and shows the "P" icon. The Pandora service played through Roku is shown with the full brand mark with icon and 
logotype on the icon.


![it_3]

Spotify Example:

![it_4]

#### Illustrator Directions

Artwork is Horizontally centered to container and offset from the top. This is done in consideration of the 3-dimensional shadow introduced in 3.0. 

![it_5]

1. Open the provided Illustrator template named “Device & Service Icon Template 3.0.ai” 

2. Edit Group of choice “Shadowed Shaped or Squared Group” by double clicking its instance in either artboard, Import or create your artwork within the Blue Grid as in the sample. 

3. Make sure after exiting isolation mode that in the appearance panel the group has a “Drop Shadow fx” attached to it. If the effect is missing, add it by going to: Effect \> Stylize \> Drop Shadow.

![it_6]


Once the effect is added or confirmed that it exist, time to export...

4. Select File \> Export \> Export for Screens. 

5. Choose Artboard containing your artwork. 

6. Export to  (path of your choice).

7.  Export Artboard  (Sizes should be pre-loaded). 

8. Verify the icons appear correctly visually and the file names are correct

Before you begin, you may choose to hide placeholder graphics or toggle their visibility in the Layers palette. (Window \> Layers)


#### Photoshop Directions

Artwork is Horizontally centered to container and offset from the top. This is done in consideration of the 3-dimensional shadow introduced in 3.0. 

![it_5]


Open the provided Photoshop template named “Device & Service Icon Template 3.0.psd” 

1. Edit Artwork (Edit Me) by double clicking layer thumbnail and Applying your artwork within the Blue Grid as in the sample.  

2. Select All Layers in Export Group 

3. Right Click \> Export As... 

4. Export All... 

5. Verify the  icons appear correctly visually and the file names are correct.

![it_7]


#### Sketch Directions

Artwork is Horizontally centered to container and offset from the top. This is done in consideration of the 3-dimensional shadow introduced in 3.0. 

![it_5]

Open the provided Photoshop template named “Device & Service Icon Template 3.0.sketch” 

1. Edit Symbol by Double Clicking Symbol of Choice - Applying your artwork within the Blue Grid as in the sample.  

2. Select Artboard containing your artwork. 

3. From the export panel (Right Side) - Export Selected...  


#### Icon Sizing Requirements 

The current requirement for device icons is to include artwork at the following sizes: 70x70, 90x90, 300x300, 512x512, and 1024x1024. Android and iOS devices use the larger artwork on higher resolution devices.  This recommendation is applicable to all drivers that utilize the `<display_icons>` XML tag. This includes drives using Experience Buttons supported through the UI Button Proxy. 

For all icons used with the Media Service Proxy (or if your device icon is used in the MSP itself) you should include the standard set of 20x20 through 140x140 pixel resolutions for each icon. The larger icon set is due to the MSP icons being used in many different locations throughout the UI. See the Media Service Proxy Driver Development documentation included in this SDK for more information. Media Service Proxy drivers should also include the branding icon at the sizes outlined above.

#### Sample Icons 
Please see sample icons that are included on the layers in the templates. These examples will show you the placement of the icons, size, shadows, and more.

![it_8]

## Copyright
Copyright 2022 Snap One, LLC. All Rights Reserved.


[it_1]:https://github.com/control4/docs-driverworks/raw/media/images/it_1.png
[it_2]:https://github.com/control4/docs-driverworks/raw/media/images/it_2.png
[it_3]:https://github.com/control4/docs-driverworks/raw/media/images/it_3.png
[it_4]:https://github.com/control4/docs-driverworks/raw/media/images/it_4.png
[it_5]:https://github.com/control4/docs-driverworks/raw/media/images/it_5.png
[it_6]:https://github.com/control4/docs-driverworks/raw/media/images/it_6.png
[it_7]:https://github.com/control4/docs-driverworks/raw/media/images/it_7.png
[it_8]:https://github.com/control4/docs-driverworks/raw/media/images/it_8.png
