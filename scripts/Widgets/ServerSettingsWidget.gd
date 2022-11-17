extends VBoxContainer
class_name ServerSettingsWidget


enum Mode { CreationMode, EditMode }
export(Mode) var mode := Mode.EditMode


var _serverSettings := ServerSettings.new() setget _set_serverSettings


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
signal saved(serverSettings)


# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	_saveButton.connect("pressed", self, "_on_saveButton_pressed")
	# warning-ignore:return_value_discarded
	_cancelButton.connect("pressed", self, "_on_cancelButton_pressed")
	_saveButton.text = "Create" if mode == Mode.CreationMode else "Save"
	_cancelButton.text = "Reset" if mode == Mode.CreationMode else "Cancel"
	updateUI()


func _on_saveButton_pressed():
	save()
	emit_signal("saved", _serverSettings)


func _on_cancelButton_pressed():
	if mode == Mode.CreationMode:
		reset()
	emit_signal("cancelled")


func reset():
	_set_serverSettings(ServerSettings.new())


func _set_serverSettings(value):
	_serverSettings = value
	updateUI()


func updateUI():
	_tabNameLineEdit.text = _serverSettings.tab_name
	# server settings
	_hostnameLineEdit.text = _serverSettings.host
	_portSpinBox.value = _serverSettings.port
	_userLineEdit.text = _serverSettings.username
	_passLineEdit.text = _serverSettings.password
	_SSLCheckBox.pressed = _serverSettings.use_ssl
	_verifyCheckBox.pressed = _serverSettings.verify_host
	# UI settings
	_autoUpdateCheckBox.pressed = _serverSettings.auto_update_on_tab
	# filter settings
	_planSpinBox.value = _serverSettings.plan
	_typesList._list = _serverSettings.type_list
	_namesList._list = _serverSettings.name_list


func save():
	_serverSettings.tab_name = _tabNameLineEdit.text
	# server settings
	_serverSettings.host = _hostnameLineEdit.text
	_serverSettings.port = _portSpinBox.value as int
	_serverSettings.username = _userLineEdit.text
	_serverSettings.password = _passLineEdit.text
	_serverSettings.use_ssl = _SSLCheckBox.pressed
	_serverSettings.verify_host = _verifyCheckBox.pressed
	# UI settings
	_serverSettings.auto_update_on_tab = _autoUpdateCheckBox.pressed
	# filter settings
	_serverSettings.plan = _planSpinBox.value as int
	_serverSettings.type_list = _typesList._list
	_serverSettings.name_list = _namesList._list
