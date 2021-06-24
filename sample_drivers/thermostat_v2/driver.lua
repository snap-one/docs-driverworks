capabilities from C4BaseThermostatV2.cpp

int TempValue;
if(ExtractCapability(s_CapHeatMin, TempValue))  { m_HeatSetPoint.SetMinValue(TempValue); }
if(ExtractCapability(s_CapHeatMax, TempValue))  { m_HeatSetPoint.SetMaxValue(TempValue); }
single_setpoint_.SetMaxValue(TempValue); // Single Setpoint Hospitality
if(ExtractCapability(s_CapCoolMin, TempValue))  { m_CoolSetPoint.SetMinValue(TempValue); }
if(ExtractCapability(s_CapCoolMax, TempValue))  { m_CoolSetPoint.SetMaxValue(TempValue); }
single_setpoint_.SetMinValue(TempValue); // Single Setpoint Hospitality

std::string CapWorkString;
if(ExtractCapability("hvac_modes", CapWorkString))	{ m_HvacMode.SetModesList(CapWorkString);	}
if(ExtractCapability("fan_modes", CapWorkString))	{ m_FanMode.SetModesList(CapWorkString);	}
if(ExtractCapability("hold_modes", CapWorkString))	{ m_HoldMode.SetModesList(CapWorkString);	}
if(ExtractCapability("hvac_states", CapWorkString))	{ m_HvacState.SetModesList(CapWorkString);	}
if(ExtractCapability("fan_states", CapWorkString))	{ m_FanState.SetModesList(CapWorkString);	}

ExtractCapability("can_lock_buttons", m_CanLockButtons);
ExtractCapability("has_remote_sensor", m_HasRemoteSensor);
ExtractCapability("can_set_backlight", m_CanControlBacklight);
ExtractCapability("has_time_settings", m_HasTimeSettings);
ExtractCapability("can_change_fan_count", m_CanChangeFanCount);

// Single Setpoint Hospiality
ExtractCapability(s_CapSingleSetpoint, can_single_setpoint_);
if (can_single_setpoint_)
{
		setpoint_mode_.set_setpoint_mode(1L); // set it to 1 by default
}
ExtractCapability(s_CapIsMultifan, is_multifan_);

bool WorkBool;
ExtractCapability(s_CapEmergencyHeat, WorkBool);
m_HvacMode.SetEmergencyHeatFlag(WorkBool);
ExtractCapability(s_CapHasDRLC, WorkBool);
m_HvacMode.SetDRLCFlag(WorkBool);

ExtractCapability(s_CapHasVacationMode, m_HasVacationMode);
ExtractCapability(s_CapCanChangeVirtualSwitches, m_CanChangeVirtualSwitches);

if(ExtractCapability(s_CapFanModeCount, TempValue))
{
	m_FanCount.SetHeatFanCount(TempValue);
	m_FanCount.SetCoolFanCount(TempValue);
}

ExtractCapability(s_CapScheduling, m_ScheduleEnabled);







// Capabilties from thermostatV2.cpp
const std::string thermostatV2::s_CanCalibrateStr       = "can_calibrate";
const std::string thermostatV2::s_CanCoolCapStr         = "can_cool";
const std::string thermostatV2::s_CanDoAutoCapStr       = "can_do_auto";
const std::string thermostatV2::s_CanHeatCapStr         = "can_heat";
const std::string thermostatV2::s_CanLockButtonsCapStr  = "can_lock_buttons";
const std::string thermostatV2::s_FanModesCapStr        = "fan_modes";
const std::string thermostatV2::s_FanStatesCapStr       = "fan_states";
                                                     // = "has_drlc" is missing. It's in the Proxy guide.
const std::string thermostatV2::s_HasRemoteSensorCapStr = "has_remote_sensor";
const std::string thermostatV2::s_HasVacationModeCapStr = "has_vacation_mode";
const std::string thermostatV2::s_HoldModesCapStr       = "hold_modes";
const std::string thermostatV2::s_HVACModesCapStr       = "hvac_modes";
const std::string thermostatV2::s_HVACStatesCapStr      = "hvac_states";
const std::string thermostatV2::s_ScheduleDayInfoStr    = "schedule_day_info";
const std::string thermostatV2::s_ScheduleDefaultCapStr = "schedule_default";
const std::string thermostatV2::s_ScheduleEntryStr      = "schedule_entry";
const std::string thermostatV2::s_HasScheduleCapStr     = "scheduling";
const std::string thermostatV2::s_SetpointCoolMaxCapStr = "setpoint_cool_max";
const std::string thermostatV2::s_SetpointCoolMaxFCapStr = "setpoint_cool_max_f";
const std::string thermostatV2::s_SetpointCoolMaxCCapStr = "setpoint_cool_max_c";
const std::string thermostatV2::s_SetpointCoolMinCapStr = "setpoint_cool_min";
const std::string thermostatV2::s_SetpointCoolMinFCapStr = "setpoint_cool_min_f";
const std::string thermostatV2::s_SetpointCoolMinCCapStr = "setpoint_cool_min_c";
const std::string thermostatV2::s_SetpointCoolResFCapStr = "setpoint_cool_resolution_f";
const std::string thermostatV2::s_SetpointCoolResCCapStr = "setpoint_cool_resolution_c";
const std::string thermostatV2::s_SetpointHeatCoolDeadbandFCapStr = "setpoint_heatcool_deadband_f";
const std::string thermostatV2::s_SetpointHeatCoolDeadbandCCapStr = "setpoint_heatcool_deadband_c";
const std::string thermostatV2::s_SetpointHeatMaxCapStr = "setpoint_heat_max";
const std::string thermostatV2::s_SetpointHeatMaxFCapStr = "setpoint_heat_max_f";
const std::string thermostatV2::s_SetpointHeatMaxCCapStr = "setpoint_heat_max_c";
const std::string thermostatV2::s_SetpointHeatMinCapStr = "setpoint_heat_min";
const std::string thermostatV2::s_SetpointHeatMinFCapStr = "setpoint_heat_min_f";
const std::string thermostatV2::s_SetpointHeatMinCCapStr = "setpoint_heat_min_c";
const std::string thermostatV2::s_SetpointHeatResFCapStr = "setpoint_heat_resolution_f";
const std::string thermostatV2::s_SetpointHeatResCCapStr = "setpoint_heat_resolution_c";
const std::string thermostatV2::s_SetpointSingleMaxFCapStr = "setpoint_single_max_f";
const std::string thermostatV2::s_SetpointSingleMaxCCapStr = "setpoint_single_max_c";
const std::string thermostatV2::s_SetpointSingleMinFCapStr  = "setpoint_single_min_f";
const std::string thermostatV2::s_SetpointSingleMinCCapStr  = "setpoint_single_min_c";
const std::string thermostatV2::s_SetpointSingleResFCapStr  = "setpoint_single_resolution_f";
const std::string thermostatV2::s_SetpointSingleResCCapStr  = "setpoint_single_resolution_c";

const std::string thermostatV2::s_HasTemperatureCapStr  =	"has_temperature";
const std::string thermostatV2::s_HasOutdoorTemperatureCapStr  = "has_outdoor_temperature";
const std::string thermostatV2::s_HasHumidityCapStr			= "has_humidity";
const std::string thermostatV2::s_CanHumidifyCapStr         = "can_humidify";
const std::string thermostatV2::s_CanDehumidifyCapStr       = "can_dehumidify";
const std::string thermostatV2::s_HumidityModesCapStr       = "humidity_modes";
const std::string thermostatV2::s_HumidityStatesCapStr      = "humidity_states";
const std::string thermostatV2::s_HumiditySetpointsDeadbandCapStr = "setpoint_humidity_deadband";
const std::string thermostatV2::s_SetpointHumidifyMinCapStr = "setpoint_humidify_min";
const std::string thermostatV2::s_SetpointHumidifyMaxCapStr = "setpoint_humidify_max";
const std::string thermostatV2::s_SetpointHumidifyResCapStr = "setpoint_humidify_resolution";
const std::string thermostatV2::s_SetpointDehumidifyMinCapStr = "setpoint_dehumidify_min";
const std::string thermostatV2::s_SetpointDehumidifyMaxCapStr = "setpoint_dehumidify_max";
const std::string thermostatV2::s_SetpointDehumidifyResCapStr = "setpoint_dehumidify_resolution";
const std::string thermostatV2::s_CanPresetCapStr			= "can_preset";
const std::string thermostatV2::s_CanPresetScheduleCapStr	= "can_preset_schedule";
const std::string thermostatV2::s_PresetFieldsCapStr		= "preset_fields";
const std::string thermostatV2::s_HasExtrasCapStr			= "has_extras";
const std::string thermostatV2::s_HasSingleSetpointCapStr	= "has_single_setpoint";
const std::string thermostatV2::s_CanIncDecSetpointsCapStr	= "can_inc_dec_setpoints";
const std::string thermostatV2::s_TemperatureMinFCapStr		= "current_temperature_min_f";
const std::string thermostatV2::s_TemperatureMaxFCapStr		= "current_temperature_max_f";
const std::string thermostatV2::s_TemperatureMinCCapStr		= "current_temperature_min_c";
const std::string thermostatV2::s_TemperatureMaxCCapStr		= "current_temperature_max_c";
const std::string thermostatV2::s_TemperatureResFCapStr		= "current_temperature_resolution_f";
const std::string thermostatV2::s_TemperatureResCCapStr		= "current_temperature_resolution_c";
const std::string thermostatV2::s_OutdoorTemperatureResFCapStr		= "outdoor_temperature_resolution_f";
const std::string thermostatV2::s_OutdoorTemperatureResCCapStr		= "outdoor_temperature_resolution_c";
const std::string thermostatV2::s_HasConnectionStatusCapStr = "has_connection_status";
const std::string thermostatV2::s_CanChangeScaleCapStr = "can_change_scale";




dynamic capabilities from thermostatV2.cpp

	std::string CanHeatStr = rMessage.getParam("CAN_HEAT");
	if(!CanHeatStr.empty() && m_CanHeat != IsTrue(CanHeatStr))
	{
		m_CanHeat = IsTrue(CanHeatStr);
	 	SendDataToUISimple("can_heat", m_CanHeat);
	}

	std::string CanCoolStr = rMessage.getParam("CAN_COOL");
	if(!CanCoolStr.empty() && m_CanCool != IsTrue(CanCoolStr))
	{
		m_CanCool = IsTrue(CanCoolStr);
	 	SendDataToUISimple("can_cool", m_CanCool);
	}

	std::string CanAutoStr = rMessage.getParam("CAN_AUTO");
	if(!CanAutoStr.empty() && m_CanDoAuto != IsTrue(CanAutoStr))
	{
		m_CanDoAuto = IsTrue(CanAutoStr);
	 	SendDataToUISimple("can_do_auto", m_CanDoAuto);
	}

	std::string HeatSetpointMinFStr = rMessage.getParam("HEAT_SETPOINT_MIN_F");
	if(!HeatSetpointMinFStr.empty() && m_HeatSetPointMin_F != StringToDecimal(HeatSetpointMinFStr))
	{
		m_HeatSetPointMin_F = StringToDecimal(HeatSetpointMinFStr);
		SendDataToUISimple(s_SetpointHeatMinFCapStr,m_HeatSetPointMin_F);
	}
	std::string HeatSetpointMinCStr = rMessage.getParam("HEAT_SETPOINT_MIN_C");
	if(!HeatSetpointMinCStr.empty() && m_HeatSetPointMin_C != StringToDecimal(HeatSetpointMinCStr))
	{
		m_HeatSetPointMin_C = StringToDecimal(HeatSetpointMinCStr);
		SendDataToUISimple(s_SetpointHeatMinCCapStr,m_HeatSetPointMin_C);
	}

	std::string HeatSetpointMaxFStr = rMessage.getParam("HEAT_SETPOINT_MAX_F");
	if(!HeatSetpointMaxFStr.empty() && m_HeatSetPointMax_F != StringToDecimal(HeatSetpointMaxFStr))
	{
		m_HeatSetPointMax_F = StringToDecimal(HeatSetpointMaxFStr);
		SendDataToUISimple(s_SetpointHeatMaxFCapStr,m_HeatSetPointMax_F);
	}
	std::string HeatSetpointMaxCStr = rMessage.getParam("HEAT_SETPOINT_MAX_C");
	if(!HeatSetpointMaxCStr.empty() && m_HeatSetPointMax_C != StringToDecimal(HeatSetpointMaxCStr))
	{
		m_HeatSetPointMax_C = StringToDecimal(HeatSetpointMaxCStr);
		SendDataToUISimple(s_SetpointHeatMaxCCapStr,m_HeatSetPointMax_C);
	}

	std::string HeatSetpointResFStr = rMessage.getParam("HEAT_SETPOINT_RESOLUTION_F");
	if(!HeatSetpointResFStr.empty() && m_HeatSetPointRes_F != StringToDecimal(HeatSetpointResFStr))
	{
		m_HeatSetPointRes_F = StringToDecimal(HeatSetpointResFStr);
		SendDataToUISimple(s_SetpointHeatResFCapStr,m_HeatSetPointRes_F);
	}
	std::string HeatSetpointResCStr = rMessage.getParam("HEAT_SETPOINT_RESOLUTION_C");
	if(!HeatSetpointResCStr.empty() && m_HeatSetPointRes_C != StringToDecimal(HeatSetpointResCStr))
	{
		m_HeatSetPointRes_C = StringToDecimal(HeatSetpointResCStr);
		SendDataToUISimple(s_SetpointHeatResCCapStr,m_HeatSetPointRes_C);
	}

	std::string HeatCoolSetpointsDeadbandFStr = rMessage.getParam("HEATCOOL_SETPOINTS_DEADBAND_F");
	if(!HeatCoolSetpointsDeadbandFStr.empty() && m_HeatCoolSetPointsDeadband_F != StringToDecimal(HeatCoolSetpointsDeadbandFStr))
	{
		m_HeatCoolSetPointsDeadband_F = StringToDecimal(HeatCoolSetpointsDeadbandFStr);
		SendDataToUISimple(s_SetpointHeatCoolDeadbandFCapStr,m_HeatCoolSetPointsDeadband_F);
	}
	std::string HeatCoolSetpointsDeadbandCStr = rMessage.getParam("HEATCOOL_SETPOINTS_DEADBAND_C");
	if(!HeatCoolSetpointsDeadbandCStr.empty() && m_HeatCoolSetPointsDeadband_C != StringToDecimal(HeatCoolSetpointsDeadbandCStr))
	{
		m_HeatCoolSetPointsDeadband_C = StringToDecimal(HeatCoolSetpointsDeadbandCStr);
		SendDataToUISimple(s_SetpointHeatCoolDeadbandCCapStr,m_HeatCoolSetPointsDeadband_C);
	}

	std::string CoolSetpointMinFStr = rMessage.getParam("COOL_SETPOINT_MIN_F");
	if(!CoolSetpointMinFStr.empty() && m_CoolSetPointMin_F != StringToDecimal(CoolSetpointMinFStr))
	{
		m_CoolSetPointMin_F = StringToDecimal(CoolSetpointMinFStr);
		SendDataToUISimple(s_SetpointCoolMinFCapStr,m_CoolSetPointMin_F);
	}
	std::string CoolSetpointMinCStr = rMessage.getParam("COOL_SETPOINT_MIN_C");
	if(!CoolSetpointMinCStr.empty() && m_CoolSetPointMin_C != StringToDecimal(CoolSetpointMinCStr))
	{
		m_CoolSetPointMin_C = StringToDecimal(CoolSetpointMinCStr);
		SendDataToUISimple(s_SetpointCoolMinCCapStr,m_CoolSetPointMin_C);
	}

	std::string CoolSetpointMaxFStr = rMessage.getParam("COOL_SETPOINT_MAX_F");
	if(!CoolSetpointMaxFStr.empty() && m_CoolSetPointMax_F != StringToDecimal(CoolSetpointMaxFStr))
	{
		m_CoolSetPointMax_F = StringToDecimal(CoolSetpointMaxFStr);
		SendDataToUISimple(s_SetpointCoolMaxFCapStr,m_CoolSetPointMax_F);
	}
	std::string CoolSetpointMaxCStr = rMessage.getParam("COOL_SETPOINT_MAX_C");
	if(!CoolSetpointMaxCStr.empty() && m_CoolSetPointMax_C != StringToDecimal(CoolSetpointMaxCStr))
	{
		m_CoolSetPointMax_C = StringToDecimal(CoolSetpointMaxCStr);
		SendDataToUISimple(s_SetpointCoolMaxCCapStr,m_CoolSetPointMax_C);
	}

	std::string CoolSetpointResFStr = rMessage.getParam("COOL_SETPOINT_RESOLUTION_F");
	if(!CoolSetpointResFStr.empty() && m_CoolSetPointRes_F != StringToDecimal(CoolSetpointResFStr))
	{
		m_CoolSetPointRes_F = StringToDecimal(CoolSetpointResFStr);
		SendDataToUISimple(s_SetpointCoolResFCapStr,m_CoolSetPointRes_F);
	}
	std::string CoolSetpointResCStr = rMessage.getParam("COOL_SETPOINT_RESOLUTION_C");
	if(!CoolSetpointResCStr.empty() && m_CoolSetPointRes_C != StringToDecimal(CoolSetpointResCStr))
	{
		m_CoolSetPointRes_C = StringToDecimal(CoolSetpointResCStr);
		SendDataToUISimple(s_SetpointCoolResCCapStr,m_CoolSetPointRes_C);
	}

	std::string SingleSetpointMinFStr = rMessage.getParam("SINGLE_SETPOINT_MIN_F");
	if(!SingleSetpointMinFStr.empty() && m_SingleSetPointMin_F != StringToDecimal(SingleSetpointMinFStr))
	{
		m_SingleSetPointMin_F = StringToDecimal(SingleSetpointMinFStr);
		SendDataToUISimple(s_SetpointSingleMinFCapStr,m_SingleSetPointMin_F);
	}
	std::string SingleSetpointMinCStr = rMessage.getParam("SINGLE_SETPOINT_MIN_C");
	if(!SingleSetpointMinCStr.empty() && m_SingleSetPointMin_C != StringToDecimal(SingleSetpointMinCStr))
	{
		m_SingleSetPointMin_C = StringToDecimal(SingleSetpointMinCStr);
		SendDataToUISimple(s_SetpointSingleMinCCapStr,m_SingleSetPointMin_C);
	}

	std::string SingleSetpointMaxFStr = rMessage.getParam("SINGLE_SETPOINT_MAX_F");
	if(!SingleSetpointMaxFStr.empty() && m_SingleSetPointMax_F != StringToDecimal(SingleSetpointMaxFStr))
	{
		m_SingleSetPointMax_F = StringToDecimal(SingleSetpointMaxFStr);
		SendDataToUISimple(s_SetpointSingleMaxFCapStr,m_SingleSetPointMax_F);
	}
	std::string SingleSetpointMaxCStr = rMessage.getParam("SINGLE_SETPOINT_MAX_C");
	if(!SingleSetpointMaxCStr.empty() && m_SingleSetPointMax_C != StringToDecimal(SingleSetpointMaxCStr))
	{
		m_SingleSetPointMax_C = StringToDecimal(SingleSetpointMaxCStr);
		SendDataToUISimple(s_SetpointSingleMaxCCapStr,m_SingleSetPointMax_C);
	}

	std::string SingleSetpointResFStr = rMessage.getParam("SINGLE_SETPOINT_RESOLUTION_F");
	if(!SingleSetpointResFStr.empty() && m_SingleSetPointRes_F != StringToDecimal(SingleSetpointResFStr))
	{
		m_SingleSetPointRes_F = StringToDecimal(SingleSetpointResFStr);
		SendDataToUISimple(s_SetpointSingleResFCapStr,m_SingleSetPointRes_F);
	}
	std::string SingleSetpointResCStr = rMessage.getParam("SINGLE_SETPOINT_RESOLUTION_C");
	if(!SingleSetpointResCStr.empty() && m_SingleSetPointRes_C != StringToDecimal(SingleSetpointResCStr))
	{
		m_SingleSetPointRes_C = StringToDecimal(SingleSetpointResCStr);
		SendDataToUISimple(s_SetpointSingleResCCapStr,m_SingleSetPointRes_C);
	}

	std::string HasTemperatureStr = rMessage.getParam("HAS_TEMPERATURE");
	if(!HasTemperatureStr.empty() && m_HasTemperature != IsTrue(HasTemperatureStr))
	{
		m_HasTemperature = IsTrue(HasTemperatureStr);
		SendDataToUISimple(s_HasTemperatureCapStr,m_HasTemperature);
	}

	std::string HasOutdoorTemperatureStr = rMessage.getParam("HAS_OUTDOOR_TEMPERATURE");
	if(!HasOutdoorTemperatureStr.empty() && m_HasOutdoorTemperature != IsTrue(HasOutdoorTemperatureStr) && m_HasOutdoorTemperature == false) // Enabling
	{
		m_HasOutdoorTemperature = IsTrue(HasOutdoorTemperatureStr);
		AddDynamicBinding(2,BT_CONTROL,true,"Outdoor Temperature","TEMPERATURE_VALUE",false,false);
		SendDataToUISimple(s_HasOutdoorTemperatureCapStr,m_HasOutdoorTemperature);
	}
	else if(!HasOutdoorTemperatureStr.empty() && m_HasOutdoorTemperature != IsTrue(HasOutdoorTemperatureStr) && m_HasOutdoorTemperature == true) // Enabling
	{
		m_HasOutdoorTemperature = IsTrue(HasOutdoorTemperatureStr);
		RemoveDynamicBinding(2);
		SendDataToUISimple(s_HasOutdoorTemperatureCapStr,m_HasOutdoorTemperature);
	}

	std::string CanHumidifyStr = rMessage.getParam("CAN_HUMIDIFY");
	if(!CanHumidifyStr.empty() && m_CanHumidify != IsTrue(CanHumidifyStr))
	{
		m_CanHumidify = IsTrue(CanHumidifyStr);
		SendDataToUISimple(s_CanHumidifyCapStr,m_CanHumidify);
	}
	std::string CanDehumidifyStr = rMessage.getParam("CAN_DEHUMIDIFY");
	if(!CanDehumidifyStr.empty() && m_CanDehumidify != IsTrue(CanDehumidifyStr))
	{
		m_CanDehumidify = IsTrue(CanDehumidifyStr);
		SendDataToUISimple(s_CanDehumidifyCapStr,m_CanDehumidify);
	}

	std::string HasHumidityStr = rMessage.getParam("HAS_HUMIDITY");
	if(!HasHumidityStr.empty() && m_HasHumidity != IsTrue(HasHumidityStr) && m_HasHumidity == false) // Enabling
	{
		m_HasHumidity = IsTrue(HasHumidityStr);
                AddDynamicBinding(3,BT_CONTROL,true,"Humidity","HUMIDITY_VALUE",false,false);
		SendDataToUISimple(s_HasHumidityCapStr,m_HasHumidity);
	}
	else if(!HasHumidityStr.empty() && m_HasHumidity != IsTrue(HasHumidityStr) && m_HasHumidity == true) // Disabling
	{
		m_HasHumidity = IsTrue(HasHumidityStr);
		RemoveDynamicBinding(3);
		SendDataToUISimple(s_HasHumidityCapStr,m_HasHumidity);
	}

	std::string HumidifySetpointMinStr = rMessage.getParam("HUMIDIFY_SETPOINT_MIN");
	if(!HumidifySetpointMinStr.empty() && m_HumidifyPoint.Min != atoi(HumidifySetpointMinStr))
	{
		m_HumidifyPoint.Min = atoi(HumidifySetpointMinStr);
		SendDataToUISimple(s_SetpointHumidifyMinCapStr,m_HumidifyPoint.Min);
	}
	std::string HumidifySetpointMaxStr = rMessage.getParam("HUMIDIFY_SETPOINT_MAX");
	if(!HumidifySetpointMaxStr.empty() && m_HumidifyPoint.Max != atoi(HumidifySetpointMaxStr))
	{
		m_HumidifyPoint.Max = atoi(HumidifySetpointMaxStr);
		SendDataToUISimple(s_SetpointHumidifyMaxCapStr,m_HumidifyPoint.Max);
	}
	std::string HumidifySetpointResStr = rMessage.getParam("HUMIDIFY_SETPOINT_RESOLUTION");
	if(!HumidifySetpointResStr.empty() && m_HumidifyPoint.Resolution != atoi(HumidifySetpointResStr))
	{
		m_HumidifyPoint.Resolution = atoi(HumidifySetpointResStr);
		SendDataToUISimple(s_SetpointHumidifyResCapStr,m_HumidifyPoint.Resolution);
	}

	std::string HumiditySetpointsDeadbandStr = rMessage.getParam("HUMIDITY_SETPOINTS_DEADBAND");
	if(!HumiditySetpointsDeadbandStr.empty() && m_HumiditySetpointsDeadband != atoi(HumiditySetpointsDeadbandStr))
	{
		m_HumiditySetpointsDeadband = atoi(HumiditySetpointsDeadbandStr);
		SendDataToUISimple(s_HumiditySetpointsDeadbandCapStr,m_HumiditySetpointsDeadband);
		ChangeMyVariable(Variable_HumiditySetpointsDeadband, m_HumiditySetpointsDeadband);
	}

	std::string DehumidifySetpointMinStr = rMessage.getParam("DEHUMIDIFY_SETPOINT_MIN");
	if(!DehumidifySetpointMinStr.empty() && m_DehumidifyPoint.Min != atoi(DehumidifySetpointMinStr))
	{
		m_DehumidifyPoint.Min = atoi(DehumidifySetpointMinStr);
		SendDataToUISimple(s_SetpointDehumidifyMinCapStr,m_DehumidifyPoint.Min);
	}
	std::string DehumidifySetpointMaxStr = rMessage.getParam("DEHUMIDIFY_SETPOINT_MAX");
	if(!DehumidifySetpointMaxStr.empty() && m_DehumidifyPoint.Max != atoi(DehumidifySetpointMaxStr))
	{
		m_DehumidifyPoint.Max = atoi(DehumidifySetpointMaxStr);
		SendDataToUISimple(s_SetpointDehumidifyMaxCapStr,m_DehumidifyPoint.Max);
	}
	std::string DehumidifySetpointResStr = rMessage.getParam("DEHUMIDIFY_SETPOINT_RESOLUTION");
	if(!DehumidifySetpointResStr.empty() && m_DehumidifyPoint.Resolution != atoi(DehumidifySetpointResStr))
	{
		m_DehumidifyPoint.Resolution = atoi(DehumidifySetpointResStr);
		SendDataToUISimple(s_SetpointDehumidifyResCapStr,m_DehumidifyPoint.Resolution);
	}

	std::string HasExtrasStr = rMessage.getParam("HAS_EXTRAS");
	if(!HasExtrasStr.empty() && m_HasExtras != IsTrue(HasExtrasStr))
	{
		m_HasExtras = IsTrue(HasExtrasStr);
		SendDataToUISimple(s_HasExtrasCapStr,m_HasExtras);
	}

	std::string CanPresetStr = rMessage.getParam("CAN_PRESET");
	if(!CanPresetStr.empty() && m_CanPreset != IsTrue(CanPresetStr))
	{
		m_CanPreset = IsTrue(CanPresetStr);
		SendDataToUISimple(s_CanPresetCapStr,m_CanPreset);
	}

	std::string CanPresetScheduleStr = rMessage.getParam("CAN_PRESET_SCHEDULE");
	if(!CanPresetScheduleStr.empty() && m_CanPresetSchedule != IsTrue(CanPresetScheduleStr))
	{
		m_CanPresetSchedule = IsTrue(CanPresetScheduleStr);
		SendDataToUISimple(s_CanPresetScheduleCapStr,m_CanPresetSchedule);
	}

	std::string HasSingleSetpointStr = rMessage.getParam("HAS_SINGLE_SETPOINT");
	if(!HasSingleSetpointStr.empty() && m_HasSingleSetpoint != IsTrue(HasSingleSetpointStr))
	{
		m_HasSingleSetpoint = IsTrue(HasSingleSetpointStr);
		SendDataToUISimple(s_HasSingleSetpointCapStr,m_HasSingleSetpoint);
	}

	std::string HasHeatPumpStr = rMessage.getParam("HAS_HEAT_PUMP");
	if(!HasHeatPumpStr.empty() && m_HeatPumpFlag != IsTrue(HasHeatPumpStr))
	{
		m_HeatPumpFlag = IsTrue(HasHeatPumpStr);
		ChangeMyVariable(Variable_HeatPump, m_HeatPumpFlag);
	}

	string TemperatureResFStr = rMessage.getParam("TEMPERATURE_RESOLUTION_F"); // Allow the precision to be adjusted as well here too
	if(!TemperatureResFStr.empty() && m_CurTemperatureRes_F != StringToDecimal(TemperatureResFStr))
	{
		m_CurTemperatureRes_F = StringToDecimal(TemperatureResFStr);
		SendDataToUISimple("current_temperature_res_f", m_CurTemperatureRes_F);
		SendDataToUISimple("current_temperature_resolution_f", m_CurTemperatureRes_F);
	}
	string TemperatureResCStr = rMessage.getParam("TEMPERATURE_RESOLUTION_C"); // Allow the precision to be adjusted as well here too
	if(!TemperatureResCStr.empty() && m_CurTemperatureRes_C != StringToDecimal(TemperatureResCStr))
	{
		m_CurTemperatureRes_C = StringToDecimal(TemperatureResCStr);
		SendDataToUISimple("current_temperature_res_c", m_CurTemperatureRes_C);
		SendDataToUISimple("current_temperature_resolution_c", m_CurTemperatureRes_C);
	}


	string TemperatureMinFStr = rMessage.getParam("TEMPERATURE_MIN_F"); // Allow the precision to be adjusted as well here too
	if(!TemperatureMinFStr.empty() && m_CurTemperatureMin_F != StringToDecimal(TemperatureMinFStr))
	{
		m_CurTemperatureMin_F = StringToDecimal(TemperatureMinFStr);
		SendDataToUISimple("current_temperature_min_f", m_CurTemperatureMin_F);
	}
	string TemperatureMinCStr = rMessage.getParam("TEMPERATURE_MIN_C"); // Allow the precision to be adjusted as well here too
	if(!TemperatureMinCStr.empty() && m_CurTemperatureMin_C != StringToDecimal(TemperatureMinCStr))
	{
		m_CurTemperatureMin_C = StringToDecimal(TemperatureMinCStr);
		SendDataToUISimple("current_temperature_min_c", m_CurTemperatureMin_C);
	}


	string TemperatureMaxFStr = rMessage.getParam("TEMPERATURE_MAX_F"); // Allow the precision to be adjusted as well here too
	if(!TemperatureMaxFStr.empty() && m_CurTemperatureMax_F != StringToDecimal(TemperatureMaxFStr))
	{
		m_CurTemperatureMax_F = StringToDecimal(TemperatureMaxFStr);
		SendDataToUISimple("current_temperature_max_f", m_CurTemperatureMax_F);
	}
	string TemperatureMaxCStr = rMessage.getParam("TEMPERATURE_MAX_C"); // Allow the precision to be adjusted as well here too
	if(!TemperatureMaxCStr.empty() && m_CurTemperatureMax_C != StringToDecimal(TemperatureMaxCStr))
	{
		m_CurTemperatureMax_C = StringToDecimal(TemperatureMaxCStr);
		SendDataToUISimple("current_temperature_max_c", m_CurTemperatureMin_C);
	}


	string OutdoorTemperatureResFStr = rMessage.getParam("OUTDOOR_TEMPERATURE_RESOLUTION_F"); // Allow the precision to be adjusted as well here too
	if(!OutdoorTemperatureResFStr.empty() && m_OutdoorTemperatureRes_F != StringToDecimal(OutdoorTemperatureResFStr))
	{
		m_OutdoorTemperatureRes_F = StringToDecimal(OutdoorTemperatureResFStr);
		SendDataToUISimple("outdoor_temperature_res_f", m_OutdoorTemperatureRes_F);
		SendDataToUISimple("outdoor_temperature_resolution_f", m_OutdoorTemperatureRes_F);
	}
	string OutdoorTemperatureResCStr = rMessage.getParam("OUTDOOR_TEMPERATURE_RESOLUTION_C"); // Allow the precision to be adjusted as well here too
	if(!OutdoorTemperatureResCStr.empty() && m_OutdoorTemperatureRes_C != StringToDecimal(OutdoorTemperatureResCStr))
	{
		m_OutdoorTemperatureRes_C = StringToDecimal(OutdoorTemperatureResCStr);
		SendDataToUISimple("outdoor_temperature_res_c", m_OutdoorTemperatureRes_C);
		SendDataToUISimple("outdoor_temperature_resolution_c", m_OutdoorTemperatureRes_C);
	}
	string CanChangeScaleCStr = rMessage.getParam("CAN_CHANGE_SCALE");
	if(!CanChangeScaleCStr.empty() && m_CanChangeScale != IsTrue(CanChangeScaleCStr))
	{
		m_CanChangeScale = IsTrue(CanChangeScaleCStr);
		SendDataToUISimple(s_CanChangeScaleCapStr, m_CanChangeScale);
	}
}