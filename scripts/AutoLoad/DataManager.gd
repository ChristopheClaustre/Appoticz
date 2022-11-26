extends Node


const cDefaultFilename = "user://data.tres"


var _data := Data.new() setget _set_private, _get_private
var _dirty = false
#temporary
var _server_counter := 0


signal data_loaded()
signal server_added(serverName, serverSettings)
signal server_removed(serverName, serverSettings)
signal server_modified(serverName, serverSettings)
signal perspective_added(index, perspectiveSettings)
signal perspective_removed(index, perspectiveSettings)
signal perspective_modified(index, perspectiveSettings)


func _ready():
	load_data(cDefaultFilename)


func _exit_tree():
	save_data(cDefaultFilename)


func _set_private(_value): pass
func _get_private(): return null


func hasServer(serverName : String): return _data.servers.has(serverName)
func getServer(serverName : String): return _data.servers[serverName]
func getServerById(idx : int): return _data.servers[_data.servers.keys()[idx]]
func countServer() -> int: return _data.servers.size()


func addServer(serverName : String, serverSettings : ServerSettings) -> bool:
	if _data.servers.has(serverName):
		return false
	return setServer(serverName, serverSettings)


func setServer(serverName : String, serverSettings : ServerSettings) -> bool:
	var overwriting = _data.servers.has(serverName)
	_data.servers[serverName] = serverSettings
	_dirty = true
	if overwriting:
		emit_signal("server_modified", serverName, serverSettings)
	else:
		emit_signal("server_added", serverName, serverSettings)
	return true


func removeServer(serverName : String) -> bool:
	var removed_server = _data.servers.get(serverName)
	if _data.servers.erase(serverName):
		_dirty = true
		emit_signal("server_removed", serverName, removed_server)
		return true
	return false


func getPerspective(idx : int): return _data.perspectives[idx]
func countPerspective() -> int: return _data.perspectives.size()


func addPerspective(perspectiveSettings : TabSettings) -> bool:
	if _data.servers.has(perspectiveSettings):
		return false
	_data.perspectives.push_back(perspectiveSettings)
	_dirty = true
	emit_signal("perspective_added", countPerspective() - 1, perspectiveSettings)
	return true


func setPerspective(idx : int, perspectiveSettings : TabSettings) -> bool:
	if _data.servers.has(perspectiveSettings) or _data.servers.size() <= idx:
		return false
	_data.perspectives[idx] = perspectiveSettings
	_dirty = true
	emit_signal("perspective_modified", idx, perspectiveSettings)
	return true


func removePerspective(idx : int) -> bool:
	if idx < 0 || _data.perspectives.size() > idx:
		return false
	var removed_perspective = _data.perspectives[idx]
	_data.perspectives.remove(idx)
	_dirty = true
	emit_signal("perspective_removed", idx, removed_perspective)
	return true


func save_data(filename : String):
	if _dirty:
		var file = File.new()
		if file.open(filename, File.WRITE) == OK:
			file.store_string(JSON.print(_data.toJSON()))
			file.close()
			_dirty = false
			return true
		return false
	return true


func load_data(filename : String):
	var file = File.new()
	if file.file_exists(filename):
		file.open(filename, File.READ)
		var string_read = file.get_as_text()
		var data_parsed := JSON.parse(string_read)
		file.close()
		if data_parsed and _data.fromJSON(data_parsed.result):
			emit_signal("data_loaded")
		else:
			printerr("Corrupted data!")
