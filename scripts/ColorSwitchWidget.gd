extends DeviceWidget
class_name ColorSwitchWidget


onready var _nameLabel := $VBoxContainer/NameContainer/NameLabel
onready var _typeLabel := $VBoxContainer/TypeContainer/TypeLabel
onready var _colorRect := $VBoxContainer2/ColorContainer/ColorRect
onready var _CWWLabel := $VBoxContainer2/CWWContainer/CWWLabel


func _ready():
	pass


func refreshUI():
	if device == null:
		_nameLabel.text = "N/A (N/A)"
		_typeLabel.text = "N/A"
		_colorRect.color = Color.white
		_CWWLabel.text = "N/A"
	else:
		_nameLabel.text = device.name + " (" + str(device.idx) + ")"
		_typeLabel.text = device.type
		_colorRect.color = device.color.color
		_CWWLabel.text = str(device.color.cold_white) + "|" + str(device.color.cold_white) + "(" + str(device.color.temperature) + ")"


func _on_Button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		device.switch_on()
	else:
		device.switch_off()
