extends TabContainer


onready var _newPerspective : PerspectiveSettingsWidget = $"New Perspective"
var _serverWidgetScene := preload("res://scenes/Widgets/ServerWidget.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	_newPerspective.connect("saved", self, "_on_newPerspective_saved")
	# warning-ignore:return_value_discarded
	_newPerspective.connect("cancelled", self, "_on_newPerspective_cancelled")
	# warning-ignore:return_value_discarded
	_DataManager_.connect("data_loaded", self, "_on_DataManager_data_loaded")
	# warning-ignore:return_value_discarded
	_DataManager_.connect("perspective_added", self, "_on_DataManager_perspective_added")
	# warning-ignore:return_value_discarded
	_DataManager_.connect("perspective_removed", self, "_on_DataManager_perspective_removed")
	# warning-ignore:return_value_discarded
	_DataManager_.connect("perspective_modified", self, "_on_DataManager_perspective_modified")
	_on_DataManager_data_loaded()


func _on_newPerspective_saved(settings):
	var result = _DataManager_.addServer(settings[0].server_name, settings[1])
	result = result and _DataManager_.addPerspective(settings[0])
	assert(result)


func _on_newPerspective_cancelled():
	# nothing to do here for now
	pass


func _on_DataManager_data_loaded():
	remove_child(_newPerspective)
	for i in range(get_child_count(), 0, -1):
		var child = get_child(i)
		remove_child(child)
		child.queue_free()
	pass

	add_child(_newPerspective)

	for i in _DataManager_.countPerspective():
		var perspective = _DataManager_.getPerspective(i)
		_addPerspective(perspective)


func _on_DataManager_perspective_added(_idx, perspectiveSettings):
	_addPerspective(perspectiveSettings)


func _addPerspective(perspectiveSettings):
	var idx := get_child_count() - 1
	# create new server widget and add it
	var _server = _serverWidgetScene.instance()
	add_child(_server)
	_server._perspectiveSettings = perspectiveSettings
	# place _newPerspective at the end of tabs
	move_child(_newPerspective, idx+1)
	# reset each entry of _newPerspective
	_newPerspective.reset()
	# init tab title
	set_tab_title(idx, perspectiveSettings.tab_name)
	# show newly created server
	current_tab = idx


func _on_DataManager_perspective_removed(idx, perspectiveSettings):
	var tab = get_child(idx)
	assert(tab._perspectiveSettings == perspectiveSettings)
	remove_child(tab)
	pass


func _on_DataManager_perspective_modified(_idx, _perspectiveSettings):
	# nothing to do here for now
	pass
