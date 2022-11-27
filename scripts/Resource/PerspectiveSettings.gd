extends Resource
class_name PerspectiveSettings


# ui settings
var tab_name = ""
var auto_update_on_tab_changed := true
# server settings
var server_name := ""
# filter settings
var type_list : BlackOrWhiteList = BlackOrWhiteList.new()
var name_list : BlackOrWhiteList = BlackOrWhiteList.new()
var plan := -1
