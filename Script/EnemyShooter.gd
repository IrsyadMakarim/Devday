extends KinematicBody2D

onready var BULLET_SCENE = preload("res://Scene/Projectile.tscn")

var player = null
var move = Vector2.ZERO
var speed = 1
var fire_rate = 0
var bullet_speed = 300
var health: int  = 50
var died = false

signal enemy_died

func _ready():
	connect("enemy_died", self, "update_enemy")

func update_enemy():
	died = true

func _physics_process(delta):
	if died == false and Global.paused == false:
		move = Vector2.ZERO
		fire_rate -= delta
		
		if player != null:
			look_at(player.position)
			move = position.direction_to(player.position) * speed
			if fire_rate < 0:
				fire_rate = 0.3
				Shoot.position = position
				Shoot.play()
				fire()
		else:
			move = Vector2.ZERO
		
		move = move.normalized()
		move = move_and_collide(move)


func handle_hit(num):
	health -= num
	print("Enemy hit", health)
	if health <= 0:
		$AnimationPlayer.play("Explode")
		$Sprite.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		$DetectShot/CollisionShape2D.set_deferred("disabled", true)
		emit_signal("enemy_died")
		Explosion.position = position
		Explosion.play()
		yield(get_tree().create_timer(0.7), "timeout")
		queue_free()

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		player = body

func _on_Area2D_body_exited(body):
	if "Player" in body.name:
		player = null

func fire():
	var bullet = BULLET_SCENE.instance()
	bullet.position = get_global_position()
	bullet.rotation_degrees = rotation_degrees
	bullet.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet)

func _on_Timer_timeout():
	if player != null:
		fire()

func _on_DetectShot_body_entered(body):
	if "Bullet" in body.name:
		handle_hit(25)
