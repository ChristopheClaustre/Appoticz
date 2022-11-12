extends Control


var _serverSettings := ServerSettings.new() setget _set_serverSettings


onready var _domoticzMainNode := $"%DomoticzMainNode"
onready var _devicesList := $"%DevicesList"
onready var _updateButton := $"%UpdateButton"
onready var _autoUpdateCheckBox := $"%AutoUpdateCheckBox"
onready var _notificationManager := $"%NotificationManager"


func _ready():
	# warning-ignore:return_value_discarded
	_updateButton.connect("pressed", self, "_on_UpdateButton_pressed")
	# warning-ignore:return_value_discarded
	_autoUpdateCheckBox.connect("toggled", self, "_on_AutoUpdateCheckBox_toggled")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("timeout_error", self, "_on_DomoticzMainNode_timeout_error")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("configuration_error", self, "_on_DomoticzMainNode_configuration_error")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("connection_error", self, "_on_DomoticzMainNode_connection_error")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("devices_list_retrieved", self, "_on_DomoticzMainNode_devices_list_retrieved")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("request_error", self, "_on_DomoticzMainNode_request_error")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("requesting_error", self, "_on_DomoticzMainNode_requesting_error")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("switchlight_error", self, "_on_DomoticzMainNode_switchlight_error")


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
	if _serverSettings.auto_update_on_tab:
		_request_devices_list()


func _request_devices_list():
	if _domoticzMainNode._request_in_progress != null:
		return

	_domoticzMainNode.request_devices_list(_serverSettings.plan)
	_devicesList.reset()
	_notificationManager.updateInProgress()


func _on_UpdateButton_pressed():
	_request_devices_list()


func _on_AutoUpdateCheckBox_toggled(pressed):
	_serverSettings.auto_update_on_tab = pressed


func _on_DomoticzMainNode_timeout_error(_status):
	_notificationManager.notify("Timeout!", 3)
	pass


func _on_DomoticzMainNode_configuration_error(_err):
	_notificationManager.notify("Configuration error!", 3)
	pass


func _on_DomoticzMainNode_connection_error(_status):
	_notificationManager.notify("Connection error!", 3)
	pass


func _on_DomoticzMainNode_request_error(_err):
	_notificationManager.notify("Request error!", 3)
	pass


func _on_DomoticzMainNode_requesting_error(_status):
	_notificationManager.notify("Requesting error!", 3)
	pass


func _on_DomoticzMainNode_switchlight_error(_body):
	_notificationManager.notify("Switchlight error!", 3)
	pass


func _on_DomoticzMainNode_devices_list_retrieved(devices):
	_devicesList.setList(devices)
	_notificationManager.visible = false
