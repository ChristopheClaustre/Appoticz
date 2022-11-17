extends Object
class_name DeviceWidgetFactory

const cDefaultDeviceWidgetScene = preload("res://scenes/Widgets/Devices/DeviceWidget.tscn")
const cDeviceWidgetScenes = {
	"Switch" : preload("res://scenes/Widgets/Devices/SwitchWidget.tscn"),
	"ColorSwitch" : preload("res://scenes/Widgets/Devices/ColorSwitchWidget.tscn")
}


static func createDeviceWidget(device, parent):
	var scene = cDeviceWidgetScenes.get(device.get_class(), cDefaultDeviceWidgetScene)
	var widget = scene.instance()
	parent.add_child(widget)
	widget.device = device
	return widget
