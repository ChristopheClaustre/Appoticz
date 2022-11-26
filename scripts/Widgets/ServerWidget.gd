extends Control


var _perspectiveSettings := TabSettings.new() setget _set_perspectiveSettings


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
	# warning-ignore:return_value_discarded
	connect("visibility_changed", self, "_on_visibility_changed")


func _set_perspectiveSettings(value):
	_perspectiveSettings = value
	updateUI()


func updateUI():
	# server settings
	var _server = _DataManager_.getServer(_perspectiveSettings.server_name)
	_domoticzMainNode.host = _server.host
	_domoticzMainNode.port = _server.port
	_domoticzMainNode.use_ssl = _server.use_ssl
	_domoticzMainNode.verify_host = _server.verify_host
	_domoticzMainNode.username_encoded = ""
	if _server.username != "":
		_domoticzMainNode.username_encoded = Marshalls.utf8_to_base64(_server.username)
	_domoticzMainNode.password_encoded = ""
	if _server.password != "":
		_domoticzMainNode.password_encoded = Marshalls.utf8_to_base64(_server.password)
	# ui settings
	_autoUpdateCheckBox.pressed = _perspectiveSettings.auto_update_on_tab_changed


func _request_devices_list():
	if _domoticzMainNode._request_in_progress != null:
		return

	_domoticzMainNode.request_devices_list(_perspectiveSettings.plan)
	_devicesList.reset()
	_notificationManager.updateInProgress()


func _on_UpdateButton_pressed():
	_request_devices_list()


func _on_AutoUpdateCheckBox_toggled(pressed):
	_perspectiveSettings.auto_update_on_tab_changed = pressed


func _on_DzMainNode_timeout_error(_status):
	_notificationManager.notify("Timeout!", 3)


func _on_DzMainNode_configuration_error(_err):
	_notificationManager.notify("Configuration error!", 3)


func _on_DzMainNode_connection_error(_status):
	_notificationManager.notify("Connection error!", 3)


func _on_DzMainNode_request_error(_err):
	_notificationManager.notify("Request error!", 3)


func _on_DzMainNode_requesting_error(_status):
	_notificationManager.notify("Requesting error!", 3)


func _on_DzMainNode_switchlight_error(_body):
	_notificationManager.notify("Switchlight error!", 3)


func _on_DzMainNode_devices_list_retrieved(devices):
	_devicesList.setList(devices)
	_notificationManager.visible = false


func _on_visibility_changed():
	if is_visible_in_tree() and _perspectiveSettings.auto_update_on_tab_changed:
		_request_devices_list()
