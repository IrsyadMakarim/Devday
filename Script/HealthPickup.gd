extends Area2D

func _ready():
	Global.connect("pickup_health", self, "health_pickup")

func _on_HealthPickup_body_entered(body):
	if Global.player_health < 100:
		if "Player" in body.name:
			$Sprite.hide()
			Global.emit_signal("pickup_health")
			$CollisionShape2D.set_deferred("disable", true)
			HealthPickupSound.position = position
			HealthPickupSound.play()
			yield(get_tree().create_timer(0.2), "timeout")
			queue_free()

func health_pickup():
	if Global.player_health < 100:
		Global.player_health = Global.player_health + (100 - Global.player_health)
		print(Global.player_health)
		Global.emit_signal("health_changed")
