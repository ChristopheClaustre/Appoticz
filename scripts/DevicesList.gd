extends Control


const sDeviceWidgetScene : PackedScene = preload("res://scenes/DeviceWidget.tscn")


onready var devicesParent = $VBoxContainer


static func createDeviceWidget(device, parent):
	var widget = sDeviceWidgetScene.instance()
	parent.add_child(widget)
	widget.device = device
	return widget


func _ready():
	pass


var _devicesNWidget := {}
func setList(devices : Array):
	for d in _devicesNWidget:
		var w = _devicesNWidget[d]
		if is_instance_valid(w):
			w.queue_free()
	
	for d in devices:
		assert(d.get_class() == Device.get_class_name())
		var widget = createDeviceWidget(d, devicesParent)
		_devicesNWidget[d] = widget
		devicesParent.add_child(HSeparator.new())
