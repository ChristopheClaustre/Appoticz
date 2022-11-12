extends Control


var _serverSettings := ServerSettings.new() setget _set_serverSettings


onready var _domoticzMainNode := $"%DomoticzMainNode"
onready var _updateButton := $"%UpdateButton"
onready var _autoUpdateCheckBox := $"%AutoUpdateCheckBox"


func _on_UpdateButton_pressed():
	$DomoticzMainNode.request_devices_list()


func _on_DomoticzMainNode_devices_list_retrieved(devices):
	$DevicesList.setList(devices)


func _set_serverSettings(value):
	_serverSettings = value
	updateUI()


func updateUI():
	_autoUpdateCheckBox.pressed = _serverSettings.auto_update_on_tab
	_domoticzMainNode.host = _serverSettings.host
	_domoticzMainNode.port = _serverSettings.port
	_domoticzMainNode.use_ssl = _serverSettings.use_ssl
	_domoticzMainNode.verify_host = _serverSettings.verify_host
	_domoticzMainNode.username_encoded = ""
	if _serverSettings.username != "":
		_domoticzMainNode.username_encoded = Marshalls.utf8_to_base64(_serverSettings.username)
	_domoticzMainNode.password_encoded = ""
	if _serverSettings.password != "":
		_domoticzMainNode.password_encoded = Marshalls.utf8_to_base64(_serverSettings.password)
