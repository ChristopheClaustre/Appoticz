extends Control


onready var _updateInProgressLabel := $UpdateInProgressLabel
onready var _notificationLabel := $NotificationLabel


func updateInProgress():
	visible = true
	_updateInProgressLabel.visible = true
	_notificationLabel.visible = false


func finished():
	visible = false
	_updateInProgressLabel.visible = false
	_notificationLabel.visible = false


func notify(message : String, timer : float):
	_notificationLabel.text = message
	_updateInProgressLabel.visible = false
	_notificationLabel.visible = true
	yield(get_tree().create_timer(timer), "timeout")
	finished()
