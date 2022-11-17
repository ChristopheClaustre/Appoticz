extends Control
class_name BlackOrWhiteListWidget


export var title = "Title" setget _set_title


var _list := BlackOrWhiteList.new() setget _set_list


onready var _title_label : Label = $"%TitleLabel"
onready var _list_tree : Tree = $"%Tree"
onready var _is_blacklist_cb := $"%BlacklistCheckBox"
onready var _remove_button := $"%RemoveButton"


func _ready():
	# warning-ignore:return_value_discarded
	_list_tree.create_item() #root
	_set_title(title)


func _set_list(value):
	_list = value
	refreshUI()


func _set_title(value):
	title = value
	if _title_label:
		_title_label.text = title


func refreshUI():
	_list_tree.clear()
	# warning-ignore:return_value_discarded
	_list_tree.create_item() #root
	for i in _list.list:
		var _item = _list_tree.create_item()
		_item.set_text(0, i)
		_item.set_editable(0, true)
	_is_blacklist_cb.pressed = _list.is_blacklist


func _on_AddButton_pressed():
	var _item = _list_tree.create_item()
	_item.set_editable(0, true)
	_list.list.push_back("")


func _on_RemoveButton_pressed():
	if _list_tree.get_root() == _list_tree.get_selected():
		return

	var _selected = _list_tree.get_selected()
	var index := _get_item_index(_selected)
	if _selected.get_next():
		_selected.get_next().select(0)
	elif _selected.get_prev():
		_selected.get_prev().select(0)
	_selected.free()
	_list_tree.update()
	_list.list.remove(index)
	_remove_button.disabled = true


func _get_item_index(item) -> int:
	var index := 0
	var _element = _list_tree.get_root().get_children()
	while _element and _element != item:
		_element = _element.get_next()
		index+=1

	if _element == item:
		return index
	return -1


func _on_Tree_item_selected():
	_remove_button.disabled = _list_tree.get_root() == _list_tree.get_selected()


func _on_Tree_nothing_selected():
	_remove_button.disabled = true


func _on_Tree_item_edited():
	if _list_tree.get_root() == _list_tree.get_selected():
		return

	var _selected = _list_tree.get_selected()
	var index := _get_item_index(_selected)
	_list.list[index] = _selected.get_text(0)


func _on_BlacklistCheckBox_toggled(button_pressed):
	_list.is_blacklist = button_pressed


func _on_ClearButton_pressed():
	_list.list.clear()
	_set_list(_list)
