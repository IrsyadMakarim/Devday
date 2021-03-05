extends KinematicBody2D

onready var Grenade = preload("res://Scene/Grenade.tscn")

var motion = Vector2()
var speed = 2
var died = false
var health: int = 25
var grenade_speed = 400
var fire_rate = 0
var player = null

signal enemy_died

func _ready():
	connect("enemy_died", self, "update_enemy")

func grenadier_hit(num):
	health -= num
	print("Enemy hit", health)
	if health <= 0:
		$AnimationPlayer.play("Explode")
		$Sprite.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		$DetectBullet/CollisionShape2D.set_deferred("disabled", true)
		emit_signal("enemy_died")
		Explosion.position = position
		Explosion.play()
		yield(get_tree().create_timer(0.7), "timeout")
		queue_free()

func _physics_process(delta):
	if died == false and Global.paused == false:
		var Player = get_parent().get_node("Player")
		fire_rate -= delta
		
		if player != null:
			motion += (Vector2(Player.position) - position)
			look_at(Player.position)
			motion = motion.normalized()*speed
			move_and_collide(motion)
			if fire_rate < 0:
				fire_rate = 1
				GrenadeShoot.position = position
				GrenadeShoot.play()
				fire_grenade()
		else:
			motion = Vector2.ZERO

func update_enemy():
	died = true

func fire_grenade():
	var grenade_instance = Grenade.instance()
	grenade_instance.position = get_global_position()
	grenade_instance.rotation_degrees = rotation_degrees
	grenade_instance.apply_impulse(Vector2(), Vector2(grenade_speed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", grenade_instance)


func _on_DetectPlayer_body_entered(body):
	if "Player" in body.name:
		player = body

func _on_DetectPlayer_body_exited(body):
	if "Player" in body.name:
		player = null

func _on_DetectBullet_body_entered(body):
	if "Bullet" in body.name or "Projectile" in body.name:
		grenadier_hit(25)
