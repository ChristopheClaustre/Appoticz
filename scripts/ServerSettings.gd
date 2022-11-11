extends Resource
class_name ServerSettings


# server settings
var host := ""
var port := 8080
var use_ssl := true
var verify_host := true
var username := ""
var password := ""
# ui settings
var tab_name = ""
var auto_update_on_tab := true
# filter settings
var type_list : BlackOrWhiteList = BlackOrWhiteList.new()
var name_list : BlackOrWhiteList = BlackOrWhiteList.new()
var plan := -1
