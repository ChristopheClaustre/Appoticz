extends TabContainer


var _servers := []

onready var _newServer : ServerSettingsWidget = $"New server"
var _serverWidgetScene := preload("res://scenes/Widgets/ServerWidget.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	connect("tab_changed", self, "_on_tab_changed")
	# warning-ignore:return_value_discarded
	_newServer.connect("saved", self, "_on_newServer_saved")
	# warning-ignore:return_value_discarded
	_newServer.connect("cancelled", self, "_on_newServer_cancelled")


func _on_newServer_saved(serverSettings):
	addServer(serverSettings)
	pass


func _on_newServer_cancelled():
	 #nothing to do here for now
	pass


func addServer(tabSettings : TabSettings):
	# create new server widget and add it
	var _server = _serverWidgetScene.instance()
	add_child_below_node(_newServer, _server)
	_server._tabSettings = tabSettings
	# place _newServer at the end of tabs
	remove_child(_newServer)
	add_child_below_node(_server, _newServer, true)
	# add created server to servers list
	_servers.push_back(tabSettings)
	# reset each entry of _newServer
	_newServer.reset()
	# init tab title
	var idx := _servers.size() - 1
	set_tab_title(idx, tabSettings.tab_name)
	# show newly created server
	current_tab = idx


func _on_tab_changed(idx):
	if idx < _servers.size() and _servers[idx].auto_update_on_tab:
		get_tab_control(idx)._request_devices_list()
