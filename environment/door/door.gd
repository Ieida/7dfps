extends Node3D
class_name Door


@onready var animation_player: AnimationPlayer = $AnimationPlayer


var is_open = false
func open():
	if is_open: return
	is_open = true
	animation_player.play("open")
	await animation_player.animation_finished


func close():
	if not is_open: return
	is_open = false
	animation_player.play("close")
	await animation_player.animation_finished
