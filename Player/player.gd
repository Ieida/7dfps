extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


@export var sensitivity: float = 2
var is_shooting = false
@export_range(0, 50000) var rpm: float = 500
var bullet: PackedScene = preload("res://Bullet/bullet.tscn")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventMouseMotion:
		$Camera3D.rotate($Camera3D.transform.basis.y, -event.relative.x * sensitivity)
		$Camera3D.rotate($Camera3D.transform.basis.x, -event.relative.y * sensitivity)
		$Camera3D.orthonormalize()
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED


func _process(delta):
	# shooting
	if Input.is_action_pressed("shoot"):
		shoot()


func _physics_process(delta):
	var input_dir = Vector3(Input.get_axis("move_left", "move_right"), 0, Input.get_axis("move_forward", "move_backward")).normalized()
	var direction = $Camera3D.transform.basis * input_dir
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

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
