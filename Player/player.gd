extends CharacterController


@onready var camera = $Camera3D
@export var sensitivity: float = 2
var rot_x = 0.0
var rot_y = 0.0
@export var weapons: Array[WeaponOwner]
var weapon: Weapon = null


# set up the player
func _ready():
	# Capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Add weapons to the weapon switcher
	
	# Unholster the starting weapon
	switch_weapon("sword")


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
	if Input.is_action_just_pressed("sword"):
		switch_weapon("sword")
	elif Input.is_action_just_pressed("shuriken"):
		switch_weapon("shuriken")
	elif Input.is_action_just_pressed("kunai"):
		switch_weapon("kunai")
	
	# shooting
	if Input.is_action_just_pressed("shoot"):
		use_weapon()


func switch_weapon(new_weapon: String):
	weapon = null


func take_damage(amount: float):
	print("%s took %s damage" % [self, amount])


func use_weapon():
	if not weapon: return
	
	weapon.use()
