extends Control
class_name DeviceWidget


onready var _nameLabel := get_node_or_null("%NameLabel")
onready var _typeLabel := get_node_or_null("%TypeLabel")


var device : Device = null setget set_device


func set_device(value):
	device = value
	refreshUI()


func refreshUI():
	if _nameLabel != null:
		_nameLabel.text = "N/A (N/A)" if device == null else device.name + " (" + str(device.idx) + ")"
	if _typeLabel != null:
		_typeLabel.text = "N/A" if device == null else device.type
	pass
