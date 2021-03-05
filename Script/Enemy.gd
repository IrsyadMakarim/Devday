extends KinematicBody2D

var motion = Vector2()
var speed = 2
var died = false
var health: int = 50
var player = null

signal enemy_died

func _ready():
	connect("enemy_died", self, "update_enemy")

func handle_hit(num):
	health -= num
	print("Enemy hit", health)
	if health <= 0:
		$AnimationPlayer.play("Explode")
		$Sprite.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		emit_signal("enemy_died")
		Explosion.position = position
		Explosion.play()
		yield(get_tree().create_timer(0.7), "timeout")
		queue_free()

func _physics_process(delta):
	if died == false and Global.paused == false:
		var Player = get_parent().get_node("Player")
		
		if player != null:
			motion += (Vector2(Player.position) - position)
			look_at(Player.position)
			motion = motion.normalized()*speed
			move_and_collide(motion)
		else:
			motion = Vector2.ZERO

func update_enemy():
	died = true

func _on_Area2D_body_entered(body):
	if "Bullet" in body.name or "Projectile" in body.name:
		handle_hit(30)

func _on_DetectPlayer_body_entered(body):
	if "Player" in body.name:
		player = body

func _on_DetectPlayer_body_exited(body):
	if "Player" in body.name:
		player = null
