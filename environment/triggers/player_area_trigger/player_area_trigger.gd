extends Node3D


signal player_entered(player: Player)


func _on_area_trigger_body_entered(body: Node3D):
	if body is Player: player_entered.emit(body)
