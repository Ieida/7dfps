extends StaticBody3D
class_name Hitbox


signal hit(damage_amount: float)


func take_damage(amount: float):
	hit.emit(amount)
