extends DeviceWidget
class_name ColorSwitchWidget


#onready var _nameLabel := $"%NameLabel"
#onready var _typeLabel := $"%TypeLabel"
onready var _colorRect := $"%ColorRect"
onready var _CWWLabel := $"%CWWLabel"
onready var _OnOffButton : Button = $"%OnOffButton"


func _ready():
	pass


func refreshUI():
	.refreshUI()
	if _OnOffButton.is_connected("toggled", self, "_on_Button_toggled"):
		_OnOffButton.disconnect("toggled", self, "_on_Button_toggled")
	if device == null:
		_colorRect.color = Color.white
		_CWWLabel.text = "N/A"
	else:
		_colorRect.color = device.color.color
		_CWWLabel.text = str(device.color.cold_white) + "|" + str(device.color.cold_white) + "(" + str(device.color.temperature) + ")"
		_OnOffButton.pressed = device.status == "On"
		_OnOffButton.text = "ON" if _OnOffButton.pressed else "OFF"
		# warning-ignore:return_value_discarded
		_OnOffButton.connect("toggled", self, "_on_Button_toggled")


func _on_Button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		device.switch_on()
		_OnOffButton.text = "ON"
	else:
		device.switch_off()
		_OnOffButton.text = "OFF"
