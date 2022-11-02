extends Object
class_name DeviceWidgetFactory

const cDefaultDeviceWidgetScene = preload("res://scenes/DeviceWidget.tscn")
const cDeviceWidgetScenes = {
	"ColorSwitch" : preload("res://scenes/ColorSwitchWidget.tscn")
}


static func createDeviceWidget(device, parent):
	var scene = cDeviceWidgetScenes.get(device.get_class(), cDefaultDeviceWidgetScene)
	var widget = scene.instance()
	parent.add_child(widget)
	widget.device = device
	return widget
