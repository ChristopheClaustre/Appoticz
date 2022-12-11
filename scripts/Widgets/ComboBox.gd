extends MenuButton
class_name ComboBox


const cAddIcon := preload("res://sprites/Add.svg")
const cAddSelectedIcon := preload("res://sprites/AddSelected.svg")
const cCheckedIcon := preload("res://sprites/GuiRadioChecked.svg")
const cUncheckedIcon := preload("res://sprites/GuiRadioUnchecked.svg")
const cExpandIcon := preload("res://sprites/Expand.svg")
const cAddId := 65536


signal selection_changed(server_selected)
signal new_value_requested()


export(Array, String) var values := [] setget _set_values
export(String) var new_value_text := "" setget _set_new_value_text
export(bool) var has_new_value := true setget _set_has_new_value
export var current_index := -1
export var current_id := -1


# Called when the node enters the scene tree for the first time.
func _ready():
	resetUI()
	# warning-ignore:return_value_discarded
	get_popup().connect("id_pressed", self, "_on_popup_menu_id_pressed")


func resetUI():
	if icon == null:
		icon = cExpandIcon

	get_popup().clear()
	for value in values:
		get_popup().add_icon_item(cUncheckedIcon, value)
	if has_new_value:
		get_popup().add_icon_item(cAddIcon, new_value_text, cAddId)
	if values.has(text):
		selectByValue(text)
	elif current_id == cAddId:
		selectById(cAddId)
	else:
		if values.size() == 0 and not has_new_value:
			current_index = -1
			current_id = -1
			text = ""
		else:
			selectByIndex(0)


func _set_values(value):
	values = value
	resetUI()


func _set_new_value_text(value):
	new_value_text = value
	var index_add = get_popup().get_item_index(cAddId)
	if index_add != -1:
		get_popup().set_item_text(index_add, new_value_text)


func _set_has_new_value(value):
	has_new_value = value
	if has_new_value:
		var index_add = get_popup().get_item_index(cAddId)
		if index_add == -1:
			get_popup().add_icon_item(cAddIcon, new_value_text, cAddId)
	else:
		var index_add = get_popup().get_item_index(cAddId)
		if index_add != -1:
			get_popup().remove_item(index_add)


func _on_popup_menu_id_pressed(id):
	var _popup = get_popup()
	current_index = _popup.get_item_index(id)
	text = _popup.get_item_text(current_index)
	current_id = id

	# set selected icons
	for idx in _popup.get_item_count():
		if _popup.get_item_id(idx) != cAddId:
			_popup.set_item_icon(idx, cCheckedIcon if idx == current_index else cUncheckedIcon)
		else:
			_popup.set_item_icon(idx, cAddSelectedIcon if idx == current_index else cAddIcon)

	# emit correct signal
	if id == cAddId:
		emit_signal("new_value_requested")
	else:
		emit_signal("selection_changed", current_index)


func selectByValue(value : String) -> void:
	var index = values.find(value)
	if index != -1:
		var id = get_popup().get_item_id(index)
		_on_popup_menu_id_pressed(id)


func selectById(id : int) -> void:
	_on_popup_menu_id_pressed(id)


func selectByIndex(index : int) -> void:
	if 0 <= index and index < values.size():
		var id = get_popup().get_item_id(index)
		_on_popup_menu_id_pressed(id)
