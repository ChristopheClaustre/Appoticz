extends Button


export var icon_pressed : Texture = null setget _set_icon_pressed
export var icon_normal : Texture = null setget _set_icon_normal


func _toggled(pressed: bool):
	icon = icon_pressed if pressed else icon_normal


func _set_icon_pressed(value):
	icon_pressed = value
	if pressed:
		icon = icon_pressed


func _set_icon_normal(value):
	icon_normal = value
	if not pressed:
		icon = icon_normal
