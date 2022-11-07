extends Resource


# connection settings
var host = ""
var port = -1
var use_ssl = false
var verify_host = true
# filter settings
var type_list : BlackOrWhiteList = BlackOrWhiteList.new()
var name_list : BlackOrWhiteList = BlackOrWhiteList.new()
var plan = -1
