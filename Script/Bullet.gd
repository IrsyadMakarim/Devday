extends RigidBody2D

func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		WallHit.position = position
		WallHit.play()
		queue_free()
	if "Wall" in body.name:
		queue_free()
	if "Shooter" in body.name:
		WallHit.position = position
		WallHit.play()
		queue_free()
	if "Grenadier" in body.name:
		WallHit.position = position
		WallHit.play()
		queue_free()
