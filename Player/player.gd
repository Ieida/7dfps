extends CharacterController
class_name Player


@onready var camera := $Camera3D
@onready var ui := $UI
@export var health: float = 100
@export var sensitivity: float = 2
var rot_x = 0.0
var rot_y = 0.0
@export_category("Weapons")
@export var katana: Weapon
@export var kunai: Weapon
@export var shuriken: Weapon
@export var active_weapon: Weapon


# set up the player
func _ready():
	# Capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Setup weapons
	katana.add_damage_exception($Hitbox)
	kunai.add_damage_exception($Hitbox)
	kunai.holster()
	shuriken.add_damage_exception($Hitbox)
	shuriken.holster()
	
	# Unholster the starting weapon
	switch_weapon("katana")


func _input(event):
	if event is InputEventMouseMotion:
		rot_x += -event.relative.x * sensitivity
		rot_y += -event.relative.y * sensitivity
		rot_y = clampf(rot_y, -1.5, 1.5)
		camera.transform.basis = Basis() # reset rotation
		camera.rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
		camera.rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED


func _process(delta):
	# moving
	var input_v = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var direction = camera.global_basis.x * input_v.x
	direction += global_basis.y.cross(camera.global_basis.x) * input_v.y
	set_input_direction(direction)
	
	# switching weapons
	if Input.is_action_just_pressed("katana"):
		switch_weapon("katana")
	elif Input.is_action_just_pressed("shuriken"):
		switch_weapon("shuriken")
	elif Input.is_action_just_pressed("kunai"):
		switch_weapon("kunai")
	
	# shooting
	if Input.is_action_just_pressed("shoot"):
		use_weapon()


func pickup(node: Node):
	if node is Kunai:
		kunai.add_ammo()
		node.queue_free()
	elif node is Shuriken:
		shuriken.add_ammo()
		node.queue_free()


var is_switching_weapon = false
func switch_weapon(weapon_name: String):
	if is_switching_weapon or is_using_weapon: return
	var new_weapon := katana
	if weapon_name == "kunai":
		new_weapon = kunai
		if not new_weapon.has_ammo(): return
	elif weapon_name == "shuriken":
		new_weapon = shuriken
		if not new_weapon.has_ammo(): return
	if new_weapon == active_weapon: return
	is_switching_weapon = true
	
	if active_weapon: await active_weapon.holster()
	active_weapon = new_weapon
	await active_weapon.unholster()
	
	is_switching_weapon = false


func take_damage(amount: float):
	if is_dead: return
	
	health -= amount
	if health <= 0:
		_on_death()


var is_dead := false
func _on_death():
	if is_dead: return
	is_dead = true
	
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	set_process_input(false)
	set_physics_process(false)
	ui.show()
	var t = get_tree().create_tween()
	t.tween_property(ui, "modulate", Color.WHITE, 1)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await t.finished


var is_using_weapon = false
func use_weapon():
	if not active_weapon or is_switching_weapon: return
	is_using_weapon = true
	await active_weapon.use()
	is_using_weapon = false


func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_pickup_area_body_entered(body):
	if body.is_in_group("pickups"):
		pickup(body)
