extends Resource
class_name PerspectiveSettings


# ui settings
export var tab_name = ""
export var auto_update_on_tab_changed := true
# server settings
export var server_name := ""
# filter settings
var type_list : BlackOrWhiteList = BlackOrWhiteList.new()
var name_list : BlackOrWhiteList = BlackOrWhiteList.new()
export var plan := -1
