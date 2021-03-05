extends Node2D

func _ready():
	GameMusic.play()

func _process(delta):
	if Global.player_health <= 0:
		$"CanvasLayer/Restart Button".show()
		Global.paused = true
		get_tree().paused = true

func _on_Win_body_entered(body):
	if "Player" in body.name:
		$"CanvasLayer/Restart Button".show()
		Global.paused = true
		get_tree().paused = true
