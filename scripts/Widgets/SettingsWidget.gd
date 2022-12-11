extends Control
class_name SettingsWidget


var _selectedServerName := "" setget _set_selectedServerName
var _newServer := DzServerSettings.new() setget _set_newServer
var _newServerName := "" setget _set_selectedServerName
var _selectedPerspectiveIndex := -1 setget _set_selectedPerspectiveIndex
var _newPerspective := PerspectiveSettings.new() setget _set_newPerspective


## SERVERS
onready var _serversCB : ComboBox = $"%ServersCB"
# server settings
onready var _serverNameLineEdit : LineEdit = $"%ServerNameLineEdit"
onready var _hostnameLineEdit : LineEdit = $"%HostnameLineEdit"
onready var _portSpinBox : SpinBox = $"%PortSpinBox"
onready var _userLineEdit : LineEdit = $"%UserLineEdit"
onready var _passLineEdit : LineEdit = $"%PassLineEdit"
onready var _SSLCheckBox : CheckBox = $"%SSLCheckBox"
onready var _verifyCheckBox : CheckBox = $"%VerifyCheckBox"
# server buttons
onready var _saveServerButton : Button = $"%SaveServerButton"
onready var _deleteServerButton : Button = $"%DeleteServerButton"

## PERSPECTIVES
onready var _perspectivesCB : ComboBox = $"%PerspectivesCB"
# perspectives settings
onready var _tabNameLineEdit : LineEdit = $"%TabNameLineEdit"
onready var _perspectiveServerCB : ComboBox = $"%PerspectiveServerCB"
onready var _autoUpdateCheckBox : CheckBox = $"%AutoUpdateCheckBox"
onready var _planSpinBox : SpinBox = $"%PlanSpinBox"
# perspectives buttons
onready var _savePerspectiveButton : Button = $"%SavePerspectiveButton"
onready var _deletePerspectiveButton : Button = $"%DeletePerspectiveButton"


# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	_saveServerButton.connect("pressed", self, "_on_saveServerButton_pressed")
	# warning-ignore:return_value_discarded
	_deleteServerButton.connect("pressed", self, "_on_deleteServerButton_pressed")
	# warning-ignore:return_value_discarded
	_savePerspectiveButton.connect("pressed", self, "_on_savePerspectiveButton_pressed")
	# warning-ignore:return_value_discarded
	_deletePerspectiveButton.connect("pressed", self, "_on_deletePerspectiveButton_pressed")
	# warning-ignore:return_value_discarded
	_serversCB.connect("selection_changed", self, "_on_ServersCB_selection_changed")
	# warning-ignore:return_value_discarded
	_serversCB.connect("new_value_requested", self, "_on_ServersCB_new_value_requested")
	# warning-ignore:return_value_discarded
	_perspectivesCB.connect("selection_changed", self, "_on_PerspectivesCB_selection_changed")
	# warning-ignore:return_value_discarded
	_perspectivesCB.connect("new_value_requested", self, "_on_PerspectivesCB_new_value_requested")

	# warning-ignore:return_value_discarded
	_DataManager_.connect("server_added", self, "_on_server_list_changed")
	# warning-ignore:return_value_discarded
	_DataManager_.connect("server_modified", self, "_on_server_list_changed")
	# warning-ignore:return_value_discarded
	_DataManager_.connect("server_removed", self, "_on_server_list_changed")
	_set_servers_list()

	# warning-ignore:return_value_discarded
	_DataManager_.connect("perspective_added", self, "_on_perspective_list_changed")
	# warning-ignore:return_value_discarded
	_DataManager_.connect("perspective_modified", self, "_on_perspective_list_changed")
	# warning-ignore:return_value_discarded
	_DataManager_.connect("perspective_removed", self, "_on_perspective_list_changed")
	_set_perspectives_list()

	updateServerUI()
	updatePerspectiveUI()


func editServer(name : String):
	if _selectedServerName == name:
		return

	_selectedServerName = name
	var _server = DzServerSettings.new()
	if not name.empty():
		_server = _DataManager_.getServer(name)
		assert(_server)
		_server = _server.duplicate() # why ?
		_serversCB.selectByValue(name)
	else:
		_serversCB.selectById(ComboBox.cAddId)
	_newServer = _server
	_newServerName = name
	updateServerUI()


func editPerspective(index : int):
	if _selectedPerspectiveIndex == index:
		return

	_selectedPerspectiveIndex = index
	var _perspective = PerspectiveSettings.new()
	if 0 <= index and index < _DataManager_.countPerspective():
		_perspective = _DataManager_.getPerspective(index)
		assert(_perspective)
		_perspective = _perspective.duplicate() # why ?
		_perspectivesCB.selectByIndex(index)
	else:
		_perspectivesCB.selectById(ComboBox.cAddId)
	_newPerspective = _perspective
	updatePerspectiveUI()


func _on_server_list_changed(_serverName, _serverSettings):
	_set_servers_list()


func _on_perspective_list_changed(_index, _perspectiveSettings):
	_set_perspectives_list()


func _set_servers_list():
	var _servers := []
	for i in _DataManager_.countServer():
		_servers.push_back(_DataManager_.getServerNameById(i))
	_serversCB.values = _servers
	_perspectiveServerCB.values = _servers


func _set_perspectives_list():
	var _perspectives := []
	for i in _DataManager_.countPerspective():
		var _perspective = _DataManager_.getPerspective(i)
		_perspectives.push_back(str(i) + ": " + _perspective.tab_name)
	_perspectivesCB.values = _perspectives


func _on_saveServerButton_pressed():
	saveServer()
	# store them because signals may modify the members attributes
	var oldServerName = _selectedServerName
	var newServerName = _newServerName
	var server = _newServer

	if _selectedServerName.empty():
		var status = _DataManager_.addServer(newServerName, server)
		assert(status)
		# select this server
		_serversCB.selectByValue(newServerName)
	else:
		# TODO confirm overwriting ?
		# update server
		if newServerName != oldServerName:
			var status = _DataManager_.renameServer(oldServerName, newServerName)
			assert(status)
		var status = _DataManager_.setServer(newServerName, server)
		assert(status)
		# select this server again
		_serversCB.selectByValue(newServerName)
		if _newPerspective.server_name == newServerName or _newPerspective.server_name == oldServerName:
			_newPerspective.server_name = newServerName
			_perspectiveServerCB.selectByValue(newServerName)


func _on_deleteServerButton_pressed():
	var status = _DataManager_.removeServer(_selectedServerName)
	assert(status)
	editServer("") # edit a new server


func _on_savePerspectiveButton_pressed():
	savePerspective()
	# store it because signals may modify the members attributes
	var perspectiveIndex = _selectedPerspectiveIndex

	if _selectedPerspectiveIndex == -1:
		var status = _DataManager_.addPerspective(_newPerspective)
		assert(status)
		# select this perspective
		_perspectivesCB.selectByIndex(_DataManager_.countPerspective() - 1)
	else:
		# TODO confirm overwriting ?
		# modify perspective
		var status = _DataManager_.setPerspective(_selectedPerspectiveIndex, _newPerspective)
		assert(status)
		# select this perspective again
		_perspectivesCB.selectByIndex(perspectiveIndex)


func _on_deletePerspectiveButton_pressed():
	var status = _DataManager_.removePerspective(_selectedPerspectiveIndex)
	assert(status)
	editServer("") # edit a new server


func _set_newServer(value):
	_newServer = value
	updateServerUI()


func _set_selectedServerName(value):
	_selectedServerName = value
	_newServerName = value
	updateServerUI()


func _set_newPerspective(value):
	_newPerspective = value
	updatePerspectiveUI()


func _set_selectedPerspectiveIndex(value):
	_selectedPerspectiveIndex = value
	updatePerspectiveUI()


func updateServerUI():
	if not _selectedServerName.empty():
		_serversCB.selectByValue(_selectedServerName)
	else:
		_serversCB.selectById(ComboBox.cAddId)
	# server name
	_serverNameLineEdit.text = _selectedServerName
	# settings
	_hostnameLineEdit.text = _newServer.host
	_portSpinBox.value = _newServer.port
	_userLineEdit.text = ""
	if not _newServer.username_encoded.empty():
		_userLineEdit.text = Marshalls.base64_to_utf8(_newServer.username_encoded)
	_passLineEdit.text = ""
	if not _newServer.password_encoded.empty():
		_passLineEdit.text = Marshalls.base64_to_utf8(_newServer.password_encoded)
	_SSLCheckBox.pressed = _newServer.use_ssl
	_verifyCheckBox.pressed = _newServer.verify_host
	_deleteServerButton.disabled = _selectedServerName.empty()


func updatePerspectiveUI():
	if 0 <= _selectedPerspectiveIndex and _selectedPerspectiveIndex < _DataManager_.countPerspective():
		_perspectivesCB.selectByIndex(_selectedPerspectiveIndex)
	else:
		_perspectivesCB.selectById(ComboBox.cAddId)
	_tabNameLineEdit.text = _newPerspective.tab_name
	if _DataManager_.hasServer(_newPerspective.server_name):
		_perspectiveServerCB.selectByValue(_newPerspective.server_name)
	else:
		_perspectiveServerCB.selectByIndex(0)
	_autoUpdateCheckBox.pressed = _newPerspective.auto_update_on_tab_changed
	_planSpinBox.value = _newPerspective.plan
	_deletePerspectiveButton.disabled = _selectedPerspectiveIndex == -1


func saveServer():
	_newServerName = _serverNameLineEdit.text
	_newServer.host = _hostnameLineEdit.text
	_newServer.port = _portSpinBox.value as int
	_newServer.username_encoded = ""
	if not _userLineEdit.text.empty():
		_newServer.username_encoded = Marshalls.utf8_to_base64(_userLineEdit.text)
	_newServer.password_encoded = ""
	if not _passLineEdit.text.empty():
		_newServer.password_encoded = Marshalls.utf8_to_base64(_passLineEdit.text)
	_newServer.use_ssl = _SSLCheckBox.pressed
	_newServer.verify_host = _verifyCheckBox.pressed


func savePerspective():
	_newPerspective.tab_name = _tabNameLineEdit.text
	_newPerspective.server_name = _perspectiveServerCB.text
	_newPerspective.auto_update_on_tab_changed = _autoUpdateCheckBox.pressed
	_newPerspective.plan = round(_planSpinBox.value) as int


func _on_ServersCB_selection_changed(server_selected_index : int):
	editServer(_DataManager_.getServerNameById(server_selected_index))


func _on_ServersCB_new_value_requested():
	editServer("")


func _on_PerspectivesCB_selection_changed(perspective_selected_index : int):
	editPerspective(perspective_selected_index)


func _on_PerspectivesCB_new_value_requested():
	editPerspective(-1)
