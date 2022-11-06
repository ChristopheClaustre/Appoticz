extends Control


func _on_UpdateButton_pressed():
	$DomoticzMainNode.request_devices_list()


func _on_DomoticzMainNode_devices_list_retrieved(devices):
	$DevicesList.setList(devices)
