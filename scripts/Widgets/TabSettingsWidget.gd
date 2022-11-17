extends VBoxContainer
class_name ServerSettingsWidget


enum Mode { CreationMode, EditMode }
export(Mode) var mode := Mode.EditMode


var _tabSettings := TabSettings.new() setget _set_tabSettings


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
	emit_signal("saved", _tabSettings)


func _on_cancelButton_pressed():
	if mode == Mode.CreationMode:
		reset()
	emit_signal("cancelled")


func reset():
	_set_tabSettings(TabSettings.new())


func _set_tabSettings(value):
	_tabSettings = value
	updateUI()


func updateUI():
	_tabNameLineEdit.text = _tabSettings.tab_name
	# server settings
	_hostnameLineEdit.text = _tabSettings.server_settings.host
	_portSpinBox.value = _tabSettings.server_settings.port
	_userLineEdit.text = _tabSettings.server_settings.username
	_passLineEdit.text = _tabSettings.server_settings.password
	_SSLCheckBox.pressed = _tabSettings.server_settings.use_ssl
	_verifyCheckBox.pressed = _tabSettings.server_settings.verify_host
	# UI settings
	_autoUpdateCheckBox.pressed = _tabSettings.auto_update_on_tab_changed
	# filter settings
	_planSpinBox.value = _tabSettings.plan
	_typesList._list = _tabSettings.type_list
	_namesList._list = _tabSettings.name_list


func save():
	_tabSettings.tab_name = _tabNameLineEdit.text
	# server settings
	_tabSettings.server_settings.host = _hostnameLineEdit.text
	_tabSettings.server_settings.port = _portSpinBox.value as int
	_tabSettings.server_settings.username = _userLineEdit.text
	_tabSettings.server_settings.password = _passLineEdit.text
	_tabSettings.server_settings.use_ssl = _SSLCheckBox.pressed
	_tabSettings.server_settings.verify_host = _verifyCheckBox.pressed
	# UI settings
	_tabSettings.auto_update_on_tab_changed = _autoUpdateCheckBox.pressed
	# filter settings
	_tabSettings.plan = _planSpinBox.value as int
	_tabSettings.type_list = _typesList._list
	_tabSettings.name_list = _namesList._list
