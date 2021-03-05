extends Area2D


func _on_Win_body_entered(body):
	if "Player" in body.name:
		Global.game_over = true
