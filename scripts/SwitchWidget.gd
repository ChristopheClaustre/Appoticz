extends DeviceWidget
class_name SwitchWidget


onready var _OnOffButton : Button = get_node_or_null("%OnOffButton")


func _ready():
	pass


func refreshUI():
	.refreshUI()
	if _OnOffButton:
		if _OnOffButton.is_connected("toggled", self, "_on_Button_toggled"):
			_OnOffButton.disconnect("toggled", self, "_on_Button_toggled")
		else:
			_OnOffButton.pressed = device.status != "Off"
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
