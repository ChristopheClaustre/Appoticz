extends Control
class_name DeviceWidget


var device : Device = null setget set_device


func set_device(value):
	device = value
	refreshUI()


func refreshUI():
	pass
