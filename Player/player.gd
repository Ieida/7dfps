extends CharacterController


@onready var camera = $Camera3D
@export var sensitivity: float = 2
var rot_x = 0.0
var rot_y = 0.0
@onready var weapon_switcher: WeaponSwitcher = $WeaponSwitcher
var weapon: Weapon = null

func _ready():
	# Capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Add weapons to the weapon switcher
	$Camera3D/Sword.avoid_damaging_body(self)
	weapon_switcher.add_weapon("sword", $Camera3D/Sword)
	$Camera3D/ShurikenThrower.avoid_damaging_body(self)
	weapon_switcher.add_weapon("shuriken", $Camera3D/ShurikenThrower)
	$Camera3D/KunaiThrower.avoid_damaging_body(self)
	weapon_switcher.add_weapon("kunai", $Camera3D/KunaiThrower)
	# Unholster weapon
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
		shoot()


func switch_weapon(new_weapon: String):
	weapon = null
	weapon = await weapon_switcher.switch_to(new_weapon)


func take_damage(amount: float):
	print("%s took %s damage" % [self, amount])


func shoot():
	if not weapon: return
	
	weapon.use()
