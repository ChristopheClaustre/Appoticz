extends TabContainer


var _servers := []

onready var _newServer : ServerSettingsWidget = $"New server"
var _serverWidgetScene := preload("res://scenes/ServerWidget.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
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


func addServer(serverSettings : ServerSettings):
	_servers.push_back(serverSettings)
	var idx := _servers.size() - 1
	var _server = _serverWidgetScene.instance()
	add_child_below_node(_newServer, _server)
	_server._serverSettings = serverSettings
	remove_child(_newServer)
	add_child_below_node(_server, _newServer, true)
	set_tab_title(idx, serverSettings.tab_name)
	_newServer.reset()
	current_tab = idx
