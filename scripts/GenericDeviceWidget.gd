extends DeviceWidget
class_name GenericDeviceWidget


onready var _nameLabel := $VBoxContainer/NameContainer/NameLabel
onready var _typeLabel := $VBoxContainer/TypeContainer/TypeLabel


func _ready():
	pass


func refreshUI():
	if device == null:
		_nameLabel.text = "N/A (N/A)"
		_typeLabel.text = "N/A"
	else:
		_nameLabel.text = device.name + " (" + str(device.idx) + ")"
		_typeLabel.text = device.type
