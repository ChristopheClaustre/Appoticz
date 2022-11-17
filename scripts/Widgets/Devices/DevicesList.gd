extends Control


onready var devicesParent = $VBoxContainer


func _ready():
	pass


var _devicesNWidget := {}
func setList(devices : Array):
	reset()

	for d in devices:
		assert(d is Device)
		var widget = DeviceWidgetFactory.createDeviceWidget(d, devicesParent)
		_devicesNWidget[d] = widget

func reset():
	for d in _devicesNWidget:
		var w = _devicesNWidget[d]
		if is_instance_valid(w):
			w.queue_free()
	_devicesNWidget.clear()
