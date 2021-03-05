extends RigidBody2D

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		WallHit.position = position
		WallHit.play()
		queue_free()
	if "Wall" in body.name:
		queue_free()
	if "Enemy" in body.name: 
		WallHit.position = position
		WallHit.play()
		queue_free()
	if "Grenadier" in body.name:
		queue_free()
