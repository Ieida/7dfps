extends CharacterBody3D


const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


@export var speed = 2.0
@export var sensitivity: float = 2
var is_shooting = false
@export_range(0, 50000) var rpm: float = 500
var bullet: PackedScene = preload("res://Bullet/bullet.tscn")
var rot_x = 0.0
var rot_y = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventMouseMotion:
		rot_x += -event.relative.x * sensitivity
		rot_y += -event.relative.y * sensitivity
		$Camera3D.transform.basis = Basis() # reset rotation
		$Camera3D.rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
		$Camera3D.rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED


func _process(delta):
	# shooting
	if Input.is_action_pressed("shoot"):
		shoot()


func _physics_process(delta):
	# gravity
	if not is_on_floor():
		velocity += Vector3(0, -1, 0) * gravity * delta
	else:
		velocity.y = 0
	
	var hor = $Camera3D.global_basis.x * Input.get_axis("move_left", "move_right")
	var ver = global_basis.y.cross($Camera3D.global_basis.x) * Input.get_axis("move_backward", "move_forward")
	var direction = (hor.normalized() + ver.normalized()).normalized()
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func shoot():
	if is_shooting: return
	is_shooting = true
	
	# shoot
	var b = bullet.instantiate()
	b.add_collision_exception_with(self)
	b.transform = $Camera3D.transform
	add_child(b)
	await get_tree().create_timer(60.0 / rpm).timeout
	
	is_shooting = false
