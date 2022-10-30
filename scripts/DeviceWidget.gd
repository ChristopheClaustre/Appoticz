extends Control
class_name DeviceWidget


var device : Device = null setget set_device
onready var _idLabel := $IdContainer/IdLabel
onready var _nameLabel := $NameContainer/NameLabel


func _ready():
	pass


func set_device(value):
	device = value
	refresh()


func refresh():
	if device == null:
		_idLabel.text = "N/A"
		_nameLabel.text = "N/A"
	else:
		_idLabel.text = str(device.idx)
		_nameLabel.text = device.name
