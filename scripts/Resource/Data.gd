extends Resource
class_name Data


const cValidServerProperties := ["host", "port", "use_ssl", "verify_host", "username_encoded", "password_encoded"]
const cValidPerspectiveProperties := ["tab_name", "auto_update_on_tab_changed", "server_name", "plan"]


var servers := {}
var perspectives := []


func toJSON() -> Dictionary:
	var _data = {}
	# Server
	_data["servers"] = {}
	for name in servers.keys():
		var server_dict := toDictionary(servers[name], cValidServerProperties)
		_data["servers"][name] = server_dict
	# Perspective
	_data["perspectives"] = []
	for _perspective in perspectives:
		var perspective_dict := toDictionary(_perspective, cValidPerspectiveProperties)
		_data["perspectives"].push_back(perspective_dict)
	return _data


func fromJSON(data) -> bool:
	if not (data is Dictionary):
		return false
	if not data.has_all(["servers", "perspectives"]):
		return false
	if not (data["servers"] is Dictionary) or not (data["perspectives"] is Array):
		return false

	var _servers_json : Dictionary = data["servers"]
	var _perspectives_json : Array = data["perspectives"]
	# Server
	for name in _servers_json.keys():
		var _server = DzServerSettings.new()
		if fromDictionary(_server, _servers_json[name], cValidServerProperties) == false:
			return false
		servers[name] = _server
	# Perspective
	for json_value in _perspectives_json:
		var _perspective = TabSettings.new()
		if fromDictionary(_perspective, json_value, cValidPerspectiveProperties) == false:
			return false
		perspectives.push_back(_perspective)

	return true


static func toDictionary(res : Resource, valid_properties : Array = []) -> Dictionary:
	var dict := {}
	for property_dict in res.get_property_list():
		var property_name = property_dict["name"]
		if valid_properties.empty() or valid_properties.find(property_name) != -1:
			dict[property_name] = res.get(property_name)
	return dict


static func fromDictionary(res : Resource, dict : Dictionary, valid_properties : Array = []) -> bool:
	for property_name in dict.keys():
		if not valid_properties.empty() and valid_properties.find(property_name) == -1:
			return false
		var value_dict = dict[property_name]
		var value_res = res.get(property_name)
		if typeof(value_res) != typeof(value_dict):
			# JSON doesn't support int only real, so let's check
			if typeof(value_res) != TYPE_INT or typeof(value_dict) != TYPE_REAL:
				return false
		res.set(property_name, value_dict)
	return true
