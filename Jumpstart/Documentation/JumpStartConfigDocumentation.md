Update

> *This is an optional entry that can be used to specify the auto-update
> fields in the driver.xml file.*

Possible sub-elements of Update are:

> AutoUpdate
>
> *This is a Boolean string that specifies the value that should be
> included in the \<auto_update\> tag included in the driver.xml file.
> If this is not included, the value will default to “True”.*
>
> ForceAutoUpdate
>
> *This is a Boolean string that specifies the value that should be
> included in the \<force_auto_update\> tag included in the driver.xml
> file. If this is not included, the value will default to “True”.*
>
> MinimumAutoUpdateVersion
>
> *This is an integer string that specifies the minimum version of the
> driver that will require an automatic update. It will be the value
> included in the \<minimum_auto_update_version\> tag. If this is not
> included, the value will default to “1”.*
>
> MinimumOSVersion
>
> *This is a string that specifies the minimum version of the OS needed
> for the forced auto update. It will be the value included in the
> \<minimum_os_version\> tag. If this is not included, the value will
> default to “3.0.0”.*

**Example**:

> "Update": {
>
> "AutoUpdate": "True",
>
> "ForceAutoUpdate": "True",
>
> "MinimumAutoUpdateVersion": "1",
>
> "MinimumOSVersion": "3.0.0"
>
> },

Serial

> *This is an optional entry that can be used to specify the default
> binding id and settings for any serial connections included in the
> driver.*
>
> Possible sub-elements for Serial are:
>
> DefaultBindingID  
> *This integer value specifies the binding id of the first serial
> connection defined in the driver. If this is not included, the value
> will default to 1. If a binding id is already in use, the value will
> be incremented until an unused value is found.*
>
> BaudRate
>
> This is an integer that specifies the default baud rate listed in the
> \<serialsettings\> capability tag in driver.xml. If this is not
> included, the value will default to 9600.
>
> DataBits
>
> *This is an integer that specifies the data bits value listed in the
> \<serialsettings\> capability tag in driver.xml. If this is not
> included, the value will default to 8.*

StopBits

> *This is an integer that specifies the stop bits value listed in the
> \<serialsettings\> capability tag in driver.xml. If this is not
> included, the value will default to 1.*
>
> Parity
>
> *This is a string that specifies the parity value listed in the
> \<serialsettings\> capability tag in driver.xml. Legal values are
> “even”, “odd”, and “none”. If this is not included, the value will
> default to “none”.*

FlowControl

> *This is a string that specifies the flow control value listed in the
> \<serialsettings\> capability tag in driver.xml. If this is not
> included, the value will default to “none”.*

**Example**:

> "Serial": {
>
> "DefaultBindingID": 1,
>
> "BaudRate": 19200,
>
> "DataBits": 8,
>
> "StopBits": 1,
>
> "Parity": "even",
>
> "FlowControl": "none"
>
> },

IR

> *This is an optional entry that can be used to specify the default
> starting binding id for any IR connections included in the driver.*
>
> Possible sub-element for IR is:
>
> DefaultBindingID  
> *This integer value specifies the binding id of the first IR
> connection defined in the driver. If this is not included, the value
> will default to 1. If a binding id is already in use, the value will
> be incremented until an unused value is found.*

**Example**:

> "IR": {
>
> "DefaultBindingID": 1
>
> },

Zigbee

> *This is an optional entry that can be used to specify the default
> starting binding id for any Zigbee connections included in the
> driver.*
>
> Possible sub-element for Zigbee is:
>
> DefaultBindingID  
> *This integer value specifies the binding id of the first Zigbee
> connection defined in the driver. If this is not included, the value
> will default to 6001. If a binding id is already in use, the value
> will be incremented until an unused value is found.*

**Example**:

> "Zigbee": {
>
> "DefaultBindingID": 6001
>
> },

IP

> *This is an optional entry that can be used to specify the default
> starting binding id for any IP connections included in the driver.*
>
> Possible sub-element for IP is:
>
> DefaultBindingID  
> *This integer value specifies the binding id of the first IP
> connection defined in the driver. If this is not included, the value
> will default to 6001. If a binding id is already in use, the value
> will be incremented until an unused value is found.*

**Example**:

> "IP": {
>
> "DefaultBindingID": 6001
>
> },

Url

> *This is an optional entry that can be used to specify the default
> starting binding id and settings for any URL connections included in
> the driver.*
>
> Possible sub-elements for URL are:
>
> DefaultBindingID  
> *This integer value specifies the binding id of the first URL
> connection defined in the driver. If this is not included, the value
> will default to 6001. If a binding id is already in use, the value
> will be incremented until an unused value is found.*
>
> DefaultHTTPPort
>
> *This integer value specifies the default value of the HTTPPort. If it
> is not included, the value will be 80.*
>
> DefaultRTSPPort
>
> *This integer value specifies the default value of the RTSPPort. If it
> is not included, the value will be 554.*
>
> DefaultAuthenticationRequired
>
> *This Boolean string specifies the default value for whether
> authentication is required. If it is not included, the value will be
> “True”.*
>
> DefaultAuthenticationType
>
> *This string specifies the default type of authentication. If it is
> not included, the value will be “BASIC”.*
>
> DefaultUserName
>
> *This string specifies the default username. If it is not included,
> the value will be “admin”.*
>
> DefaultPassword
>
> *This string specifies the default password. If it is not included,
> the value will be “pass”.*

**Example**:

> "Url": {
>
> "DefaultBindingID": 6001,
>
> "DefaultHTTPPort": 80,
>
> "DefaultRTSPPort": 554,
>
> "DefaultAuthenticationRequired": "True",
>
> "DefaultAuthenticationType": "BASIC",
>
> "DefaultUserName": "admin",
>
> "DefaultPassword": "pass"
>
> },

Network

> *This is an optional entry that can be used to specify the default
> starting binding id and settings for any Network connections included
> in the driver.*
>
> Possible sub-elements for Network are:
>
> DefaultBindingID  
> *This integer value specifies the binding id of the first Network
> connection defined in the driver. If this is not included, the value
> will default to 6000. If a binding id is already in use, the value
> will be incremented until an unused value is found.*
>
> DefaultUserName
>
> *This string specifies the default username. If it is not included,
> the value will be “”.*
>
> DefaultPassword
>
> *This string specifies the default password. If it is not included,
> the value will be “”.*
>
> DefaultIPAddress
>
> *This string value specifies the default network address. If it is not
> included, the value will be “0.0.0.0”.*
>
> DefaultIPPort
>
> *This integer value specifies the default network port. If it is not
> included, the value will be 0.*
>
> DefaultBroadcastBindingID
>
> *This integer value specifies the binding id of the first Network
> broadcasting connection defined in the driver. If this is not
> included, the value will default to 6002. If a binding id is already
> in use, the value will be incremented until an unused value is found.*
>
> DefaultBroadcastPort
>
> *This integer value specifies the default broadcasting port. If it is
> not included, the value will be 9.*
>
> "Network": {
>
> "DefaultBindingID": 6000,
>
> "DefaultUserName": "admin",
>
> "DefaultPassword": "pass",
>
> "DefaultIPAddress": "127.0.0.1",
>
> "DefaultIPPort": 80,
>
> "DefaultBroadcastBindingID": 6002,
>
> "DefaultBroadcastPort": 9
>
> },

MiniApp

> *This is an optional entry that can be used to specify the default
> starting binding id for any MiniApp connections included in the
> driver.*
>
> Possible sub-element for IP is:
>
> DefaultBindingID  
> *This integer value specifies the binding id of the first MiniApp
> connection defined in the driver. If this is not included, the value
> will default to 3100. If a binding id is already in use, the value
> will be incremented until an unused value is found.*

**Example**:

> "MiniApp": {
>
> "DefaultBindingID": 3100
>
> },

AV

> *This specifies the default classes that should be associated with
> different types of AV bindings that are specified in the driver.*
>
> Possible sub-elements for AV are:
>
> DefaultVideoInputClasses
>
> *Specifies an array of strings that should be used as the class types
> for any video input bindings listed in the driver. Typical values are
> COMPONENT, COMPOSIT, and HDMI. If not specified, the default value
> will be \[\].*
>
> DefaultVideoOutputClasses
>
> *Specifies an array of strings that should be used as the class types
> for any video output bindings listed in the driver. Typical values are
> COMPONENT, COMPOSIT, and HDMI. If not specified, the default value
> will be \[\].*
>
> DefaultAudioInputClasses
>
> *Specifies an array of strings that should be used as the class types
> for any audio input bindings listed in the driver. Typical values are
> DIGITAL_COAX, DIGITAL_OPTICAL, and STEREO. If not specified, the
> default value will be \[\].*
>
> DefaultAudioOutputClasses
>
> *Specifies an array of strings that should be used as the class types
> for any audio output bindings listed in the driver. Typical values are
> SPEAKER and STEREO. If not specified, the default value will be \[\].*
>
> **Example**:
>
> "AV": {
>
> "DefaultVideoInputClasses": \[
>
> "COMPONENT",
>
> "COMPOSITE",
>
> "HDMI"
>
> \],
>
> "DefaultVideoOutputClasses": \[
>
> "COMPONENT",
>
> "COMPOSITE",
>
> "HDMI"
>
> \],
>
> "DefaultAudioInputClasses": \[
>
> "DIGITAL_COAX",
>
> "DIGITAL_OPTICAL",
>
> "STEREO"
>
> \],
>
> "DefaultAudioOutputClasses": \[
>
> "SPEAKER",
>
> "STEREO"
>
> \]
>
> },

Proxies

> *This will specify information for each of the supported proxies. Some
> proxies will have some settings associated with them. The should all
> have a list of the proxy capabilities with desired default values.*
>
> Possible sub-elements for Proxies contain information for individual
> proxies. They are:
>
> Amplifier
>
> (See AVSwitch)
>
> Audio Switch
>
> (See AVSwitch)
>
> AVSwitch
>
> The possible sub-element for AVSwitch is:
>
> Capabilities
>
> *This lists the default capabilities that should be specified for this
> proxy.*
>
> Light
>
> Possible sub-elements for Light are:
>
> ButtonLinkBindingIDBase
>
> *This integer value is the starting binding id for any button link
> bindings that may be associated with the light device.*
>
> Capabilities
>
> *This lists the default capabilities that should be specified for this
> proxy.*
>
> Lock
>
> The possible sub-element for Lock is:
>
> Capabilities
>
> *This lists the default capabilities that should be specified for this
> proxy.*
>
> MediaPlayer
>
> Possible sub-elements for MediaPlayer are:
>
> HasAudio
>
> *This is a Boolean string value that specifies whether media player
> proxies support audio. If not specified, the value defaults to
> “True”.*
>
> HasVideo
>
> *This is a Boolean string value that specifies whether media player
> proxies support video. If not specified, the value defaults to
> “True”.*
>
> Capabilities
>
> *This lists the default capabilities that should be specified for this
> proxy.*
>
> Receiver
>
> The possible sub-element for Receiver is:
>
> Capabilities
>
> *This lists the default capabilities that should be specified for this
> proxy.*
>
> SecurityPanel
>
> The possible sub-element for SecurityPanel is:
>
> Capabilities
>
> *This lists the default capabilities that should be specified for this
> proxy.*
>
> SecurityPartition
>
> Possible sub-elements for SecurityPartition are:
>
> Buttons
>
> *This is an arrow of elements for buttons A – D which may match the
> buttons on a security keypad. These buttons will show up on the
> Navigator interface. Each button element has values for:*
>
> tag
>
> *The XML tag label that will be in driver.xml associated with this
> button.*
>
> Visible
>
> *A Boolean string value that specifies whether this button is visible
> in Navigator.*
>
> Label
>
> *A string value that specifies how the button will show up in
> Navigator.*
>
> Capabilities
>
> *This lists the default capabilities that should be specified for this
> proxy.*
>
> Tuner
>
> Possible sub-elements for Tuner are:
>
> HasVideo
>
> *This is a Boolean string value that specifies whether tuner proxies
> support video. If not specified, the value defaults to “False”.*
>
> HasAM
>
> *This is a Boolean string value that specifies whether tuner proxies
> support AM radio. If not specified, the value defaults to “True”.*
>
> HasFM
>
> *This is a Boolean string value that specifies whether tuner proxies
> support FM radio. If not specified, the value defaults to “True”.*
>
> Capabilities
>
> *This lists the default capabilities that should be specified for this
> proxy.*
>
> Tv
>
> The possible sub-element for Tv is:
>
> Capabilities
>
> *This lists the default capabilities that should be specified for this
> proxy.*

**Example**:

> "Proxies": {
>
> "AVSwitch": {
>
> "Capabilities": {
>
> "can_downclass": "True",
>
> "can_switch": "True",
>
> "can_upclass": "True",
>
> "can_switch_separately": "False",
>
> "requires_separate_switching": "False",
>
> "has_discrete_balance_control": "True",
>
> "has_discrete_bass_control": "True",
>
> "has_discrete_input_select": "True",
>
> "has_discrete_loudness_control": "True",
>
> "has_discrete_mute_control": "True",
>
> "has_discrete_treble_control": "True",
>
> "has_discrete_volume_control": "True",
>
> "has_toad_input_select": "True",
>
> "has_toggle_loudness_control": "True",
>
> "has_toggle_mute_control": "True",
>
> "has_up_down_balance_control": "True",
>
> "has_up_down_bass_control": "True",
>
> "has_up_down_treble_control": "True",
>
> "has_up_down_volume_control": "True",
>
> "has_video_sense_control": "True"
>
> }
>
> },
>
> "Light": {
>
> "ButtonLinkBindingIDBase": 300,
>
> "Capabilities": {
>
> "dimmer": "True",
>
> "on_off": "True",
>
> "set_level": "True",
>
> "ramp_level": "True",
>
> "min_max": "True",
>
> "click_rates": "True",
>
> "click_rate_min": "250",
>
> "hold_rates": "True",
>
> "hold_rate_min": "1000",
>
> "cold_start": "True",
>
> "has_leds": "True",
>
> "supports_broadcast_scenes": "True",
>
> "supports_multichannel_scenes": "False",
>
> "hide_proxy_properties": "False",
>
> "hide_proxy_events": "False",
>
> "has_button_events": "True",
>
> "advanced_scene_support": "True",
>
> "load_group_support": "True",
>
> "buttons_are_virtual": "False",
>
> "has_load": "True",
>
> "max_power": "0",
>
> "min_power": "-7"
>
> }
>
> },
>
> "Lock": {
>
> "Capabilities": {
>
> "is_management_only": "False",
>
> "has_admin_code": "True",
>
> "has_schedule_lockout": "True",
>
> "has_auto_lock_time": "True",
>
> "auto_lock_time_values": "0",
>
> "auto_lock_time_display_values": "OFF",
>
> "has_log_items_count": "True",
>
> "log_item_count_values": "5",
>
> "has_lock_modes": "False",
>
> "lock_modes_values": "normal",
>
> "has_log_failed_attempts": "False",
>
> "has_wrong_code_attempts": "False",
>
> "wrong_code_attempts_values": "1",
>
> "has_shutout_timer": "False",
>
> "shutout_timer_values": "5",
>
> "shutout_timer_display_values": "5sec",
>
> "has_language": "False",
>
> "language_values": "English",
>
> "has_volume": "True",
>
> "has_one_touch_locking": "False",
>
> "has_daily_schedule": "True",
>
> "has_date_range_schedule": "True",
>
> "max_users": "30",
>
> "has_settings": "True",
>
> "has_custom_settings": "False",
>
> "has_internal_history": "True",
>
> "can_edit_user": "True",
>
> "can_edit_user_pin": "True",
>
> "can_add_remove_user": "True"
>
> }
>
> },
>
> "MediaPlayer": {
>
> "HasAudio": "True",
>
> "HasVideo": "True",
>
> "Capabilities": {
>
> "has_http_playback": "True",
>
> "has_discrete_volume_control": "True",
>
> "has_discrete_mute_control": "True"
>
> }
>
> },
>
> "Receiver": {
>
> "Capabilities": {
>
> "has_discrete_volume_control": "True",
>
> "has_up_down_volume_control": "True",
>
> "has_discrete_input_select": "True",
>
> "has_toad_input_select": "True",
>
> "has_discrete_surround_mode_select": "True",
>
> "has_toad_surround_mode_select": "True",
>
> "has_discrete_bass_control": "True",
>
> "has_up_down_bass_control": "True",
>
> "has_discrete_treble_control": "True",
>
> "has_up_down_treble_control": "True",
>
> "has_discrete_balance_control": "True",
>
> "has_up_down_balance_control": "True",
>
> "has_discrete_loudness_control": "True",
>
> "has_toggle_loudness_control": "True",
>
> "has_discrete_mute_control": "True",
>
> "has_toggle_mute_control": "True",
>
> "surround_modes":
> "\<surround_mode\>\<id\>22620\</id\>\<name\>Stereo\</name\>\</surround_mode\>\<surround_mode\>\<id\>22624\</id\>\<name\>THX\</name\>\</surround_mode\>"
>
> }
>
> },
>
> "SecurityPanel": {
>
> "Capabilities": {
>
> "can_set_time": "True",
>
> "can_activate_partitions": "True"
>
> }
>
> },
>
> "SecurityPartition": {
>
> "Buttons": \[
>
> { "tag": "button_A", "visible": "True", "label": "Button A" },
>
> { "tag": "button_B", "visible": "True", "label": "B" },
>
> { "tag": "button_C", "visible": "True", "label": "C" },
>
> { "tag": "button_D", "visible": "False", "label": "D" }
>
> \],
>
> "Capabilities": {
>
> "ui_version": "2",
>
> "supports_virtual_keypad": "True",
>
> "has_fire": "True",
>
> "has_medical": "False",
>
> "has_police": "False",
>
> "has_panic": "True",
>
> "star_label": "\*",
>
> "pound_label": "#",
>
> "arm_states": "Stay,Away",
>
> "functions": ""
>
> }
>
> },
>
> "Tuner": {
>
> "HasVideo": "False",
>
> "HasAM": "True",
>
> "HasFM": "True",
>
> "Capabilities": {
>
> "selection_delay": "0",
>
> "has_discrete_input_select": "True",
>
> "has_toad_input_select": "True",
>
> "has_tune_up_down": "True",
>
> "has_search_up_down": "True",
>
> "has_discrete_preset": "True",
>
> "has_preset_up_down": "True",
>
> "preset_count": "3",
>
> "has_discrete_channel_select": "True",
>
> "has_channel_up_down": "True",
>
> "preface_band_with_tuner": "True",
>
> "rf_network_type": "AMFM"
>
> }
>
> },
>
> "Tv": {
>
> "Capabilities": {
>
> "has_discrete_volume_control": "True",
>
> "has_up_down_volume_control": "True",
>
> "has_discrete_input_select": "True",
>
> "has_toad_input_select": "True",
>
> "has_discrete_channel_select": "True",
>
> "has_channel_up_down": "True",
>
> "has_discrete_bass_control": "True",
>
> "has_up_down_bass_control": "True",
>
> "has_discrete_treble_control": "True",
>
> "has_up_down_treble_control": "True",
>
> "has_discrete_balance_control": "True",
>
> "has_up_down_balance_control": "True",
>
> "has_discrete_loudness_control": "True",
>
> "has_toggle_loudness_control": "True",
>
> "has_discrete_mute_control": "True",
>
> "has_toggle_mute_control": "True",
>
> "has_audio": "True",
>
> "requires_channel_after_input": "True"
>
> }
>
> }
>
> }
