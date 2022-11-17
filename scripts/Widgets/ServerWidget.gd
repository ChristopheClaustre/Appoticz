extends Control


var _tabSettings := TabSettings.new() setget _set_tabSettings


onready var _domoticzMainNode := $"%DzMainNode"
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
	_domoticzMainNode.connect("timeout_error", self, "_on_DzMainNode_timeout_error")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("configuration_error", self, "_on_DzMainNode_configuration_error")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("connection_error", self, "_on_DzMainNode_connection_error")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("devices_list_retrieved", self, "_on_DzMainNode_devices_list_retrieved")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("request_error", self, "_on_DzMainNode_request_error")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("requesting_error", self, "_on_DzMainNode_requesting_error")
	# warning-ignore:return_value_discarded
	_domoticzMainNode.connect("switchlight_error", self, "_on_DzMainNode_switchlight_error")


func _set_tabSettings(value):
	_tabSettings = value
	updateUI()


func updateUI():
	# server settings
	_domoticzMainNode.host = _tabSettings.server_settings.host
	_domoticzMainNode.port = _tabSettings.server_settings.port
	_domoticzMainNode.use_ssl = _tabSettings.server_settings.use_ssl
	_domoticzMainNode.verify_host = _tabSettings.server_settings.verify_host
	_domoticzMainNode.username_encoded = ""
	if _tabSettings.server_settings.username != "":
		_domoticzMainNode.username_encoded = Marshalls.utf8_to_base64(_tabSettings.server_settings.username)
	_domoticzMainNode.password_encoded = ""
	if _tabSettings.server_settings.password != "":
		_domoticzMainNode.password_encoded = Marshalls.utf8_to_base64(_tabSettings.server_settings.password)
	# ui settings
	_autoUpdateCheckBox.pressed = _tabSettings.auto_update_on_tab_changed
	if _tabSettings.auto_update_on_tab_changed:
		_request_devices_list()


func _request_devices_list():
	if _domoticzMainNode._request_in_progress != null:
		return

	_domoticzMainNode.request_devices_list(_tabSettings.plan)
	_devicesList.reset()
	_notificationManager.updateInProgress()


func _on_UpdateButton_pressed():
	_request_devices_list()


func _on_AutoUpdateCheckBox_toggled(pressed):
	_tabSettings.auto_update_on_tab = pressed


func _on_DzMainNode_timeout_error(_status):
	_notificationManager.notify("Timeout!", 3)
	pass


func _on_DzMainNode_configuration_error(_err):
	_notificationManager.notify("Configuration error!", 3)
	pass


func _on_DzMainNode_connection_error(_status):
	_notificationManager.notify("Connection error!", 3)
	pass


func _on_DzMainNode_request_error(_err):
	_notificationManager.notify("Request error!", 3)
	pass


func _on_DzMainNode_requesting_error(_status):
	_notificationManager.notify("Requesting error!", 3)
	pass


func _on_DzMainNode_switchlight_error(_body):
	_notificationManager.notify("Switchlight error!", 3)
	pass


func _on_DzMainNode_devices_list_retrieved(devices):
	_devicesList.setList(devices)
	_notificationManager.visible = false
