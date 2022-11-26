extends VBoxContainer
class_name TabSettingsWidget


enum Mode { CreationMode, EditMode }
export(Mode) var mode := Mode.EditMode


onready var _tabNameLineEdit : LineEdit = $"%TabNameLineEdit"
# server settings
onready var _hostnameLineEdit : LineEdit = $"%HostnameLineEdit"
onready var _portSpinBox : SpinBox = $"%PortSpinBox"
onready var _userLineEdit : LineEdit = $"%UserLineEdit"
onready var _passLineEdit : LineEdit = $"%PassLineEdit"
onready var _SSLCheckBox : CheckBox = $"%SSLCheckBox"
onready var _verifyCheckBox : CheckBox = $"%VerifyCheckBox"
# UI settings
onready var _autoUpdateCheckBox : CheckBox = $"%AutoUpdateCheckBox"
# filter settings
onready var _planSpinBox : SpinBox = $"%PlanSpinBox"
onready var _typesList : BlackOrWhiteListWidget = $"%TypesList"
onready var _namesList : BlackOrWhiteListWidget = $"%NamesList"
# buttons
onready var _saveButton : Button = $"%SaveButton"
onready var _cancelButton : Button = $"%CancelButton"


signal cancelled
signal saved(tabSettings)


# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	_saveButton.connect("pressed", self, "_on_saveButton_pressed")
	# warning-ignore:return_value_discarded
	_cancelButton.connect("pressed", self, "_on_cancelButton_pressed")
	_saveButton.text = "Create" if mode == Mode.CreationMode else "Save"
	_cancelButton.text = "Reset" if mode == Mode.CreationMode else "Cancel"
	reset()


func _on_saveButton_pressed():
	var _settings = to_settings()
	emit_signal("saved", _settings)


func _on_cancelButton_pressed():
	if mode == Mode.CreationMode:
		reset()
	emit_signal("cancelled")


func reset():
	resetUI(TabSettings.new())


func resetUI(tabSettings : TabSettings):
	_tabNameLineEdit.text = tabSettings.tab_name
	# server settings
	var _server : DzServerSettings = null
	if _DataManager_.hasServer(tabSettings.server_name):
		_server = _DataManager_.getServer(tabSettings.server_name)
	else:
		_server = DzServerSettings.new()
	_hostnameLineEdit.text = _server.host
	_portSpinBox.value = _server.port
	_userLineEdit.text = ""
	if not _server.username_encoded.empty():
		_userLineEdit.text = Marshalls.base64_to_utf8(_server.username_encoded)
	_passLineEdit.text = ""
	if not _server.password_encoded.empty():
		_passLineEdit.text = Marshalls.base64_to_utf8(_server.password_encoded)
	_SSLCheckBox.pressed = _server.use_ssl
	_verifyCheckBox.pressed = _server.verify_host
	# UI settings
	_autoUpdateCheckBox.pressed = tabSettings.auto_update_on_tab_changed
	# filter settings
	_planSpinBox.value = tabSettings.plan
	_typesList._list = tabSettings.type_list
	_namesList._list = tabSettings.name_list


func to_settings():
	var _tabSettings = TabSettings.new()
	_tabSettings.tab_name = _tabNameLineEdit.text
	# server settings
	# creation of server ID (temporary)
	while _DataManager_.hasServer(str(_DataManager_._server_counter)):
		_DataManager_._server_counter += 1
	_tabSettings.server_name = str(_DataManager_._server_counter)
	var _serverSettings := DzServerSettings.new()
	_serverSettings.host = _hostnameLineEdit.text
	_serverSettings.port = _portSpinBox.value as int
	_serverSettings.username_encoded = ""
	if not _userLineEdit.text.empty():
		_serverSettings.username_encoded = Marshalls.utf8_to_base64(_userLineEdit.text)
	_serverSettings.password_encoded = ""
	if not _passLineEdit.text.empty():
		_serverSettings.password_encoded = Marshalls.utf8_to_base64(_passLineEdit.text)
	_serverSettings.use_ssl = _SSLCheckBox.pressed
	_serverSettings.verify_host = _verifyCheckBox.pressed
	# UI settings
	_tabSettings.auto_update_on_tab_changed = _autoUpdateCheckBox.pressed
	# filter settings
	_tabSettings.plan = _planSpinBox.value as int
	_tabSettings.type_list = _typesList._list
	_tabSettings.name_list = _namesList._list

	return [_tabSettings,_serverSettings]
