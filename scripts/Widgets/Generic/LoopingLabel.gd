extends Label


export(Array, String) var _looping_labels = []
export(float) var _timer = 0.5


func _ready():
	# warning-ignore:return_value_discarded
	connect("visibility_changed", self, "_on_visibility_changed")


var _coroutine = null
func _on_visibility_changed():
	if visible == true and (_coroutine == null or not _coroutine.is_valid(true)):
		_coroutine = message_coroutine()


func message_coroutine():
	var _idx := 0
	while is_visible_in_tree():
		text = _looping_labels[_idx]
		_idx = (_idx + 1) % _looping_labels.size()
		yield(get_tree().create_timer(_timer), "timeout")
	_coroutine = null
