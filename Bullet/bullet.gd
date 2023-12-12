extends CharacterBody3D


signal hit(hit_info: HitInfo)


@export var speed = 5.0


func _ready():
	hit.connect(_on_hit)


func _physics_process(delta):
	var mtn = -transform.basis.z * speed * delta
	var coll = move_and_collide(mtn)
	if coll:
		hit.emit(HitInfo.new(coll.get_collider()))


func _on_hit(hit_info: HitInfo):
	queue_free()
