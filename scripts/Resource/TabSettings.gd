extends Resource
class_name TabSettings


# ui settings
var tab_name = ""
var auto_update_on_tab_changed := true
# server settings
var server_settings := ServerSettings.new()
# filter settings
var type_list : BlackOrWhiteList = BlackOrWhiteList.new()
var name_list : BlackOrWhiteList = BlackOrWhiteList.new()
var plan := -1
