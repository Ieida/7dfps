extends Weapon
class_name Sword


var is_swinging = false
var is_slicing: bool = false
@onready var attack_area = $AttackArea


func _physics_process(delta):
	if is_slicing:
		slice(damage * delta)


func use():
	swing()


func swing():
	if is_swinging: return
	is_swinging = true
	
	print("%s swinging %s" % [owner, self])
	# play animation
	animation_player.play("example_swing")
	# await animation finish
	await animation_player.animation_finished
	
	is_swinging = false


func start_slicing():
	is_slicing = true


func stop_slicing():
	is_slicing = false


func slice(damage_delta: float):
	for body in attack_area.get_overlapping_bodies():
		do_damage(body, damage_delta)
