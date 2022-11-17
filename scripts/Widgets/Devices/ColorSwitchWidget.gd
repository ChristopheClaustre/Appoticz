extends SwitchWidget
class_name ColorSwitchWidget


onready var _colorRect := $"%ColorRect"
onready var _CWWLabel := $"%CWWLabel"


func _ready():
	pass


func refreshUI():
	.refreshUI()
	if device == null:
		_colorRect.color = Color.white
		_CWWLabel.text = "N/A"
	else:
		_colorRect.color = device.color.color
		_CWWLabel.text = str(device.color.cold_white) + "|" + str(device.color.cold_white) + "(" + str(device.color.temperature) + ")"
