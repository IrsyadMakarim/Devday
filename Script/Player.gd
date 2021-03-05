extends KinematicBody2D
class_name Player

var movespeed = 300
var bullet_speed = 800
var grenade_speed = 400
var bullet = preload("res://Scene/Bullet.tscn")
var grenade = preload("res://Scene/Grenade.tscn")
var fire_rate = 0
var died = false

signal player_died

func _ready():
	Global.connect("weapon_changed", self, "update_weapon")
	connect("player_died", self, "update_player")
	died = false

func _physics_process(delta):
	if died == false and Global.paused == false:
		var motion = Vector2()
		fire_rate -= delta
		
		if Input.is_action_pressed("up"):
			motion.y -= 1
		if Input.is_action_pressed("down"):
			motion.y += 1
		if Input.is_action_pressed("left"):
			motion.x -= 1
		if Input.is_action_pressed("right"):
			motion.x += 1
		motion = motion.normalized()
		motion = move_and_slide(motion * movespeed)
		
		look_at(get_global_mouse_position())
		
		if Input.is_action_just_pressed("primary"):
			Global.current_weapon = 1
			Global.emit_signal("weapon_changed", Global.current_weapon)
			Global.emit_signal("ammo_changed")
		
		if Input.is_action_just_pressed("shotgun"):
			Global.current_weapon = 2
			Global.emit_signal("weapon_changed", Global.current_weapon)
			Global.emit_signal("ammo_changed")
		
		if Input.is_action_just_pressed("smg"):
			Global.current_weapon = 3
			Global.emit_signal("weapon_changed", Global.current_weapon)
			Global.emit_signal("ammo_changed")
		
		if Global.current_weapon == 1:
			if Input.is_action_pressed("fire") and fire_rate < 0:
				fire_rate = 0.25
				Shoot.position = position
				Shoot.play()
				Global.emit_signal("ammo_changed")
				fire()
		
		if Global.current_weapon == 2:
			if Global.ammo > 0:
				if Input.is_action_just_pressed("fire") and fire_rate < 0:
					fire_rate = 0.4
					Shoot.position = position
					Shoot.play()
					fire_shotgun()
					Global.ammo -= 1
					Global.emit_signal("ammo_changed")
			else:
				if Input.is_action_just_pressed("fire") and fire_rate < 0:
					fire_rate = 0.4
					EmptyClip.position = position
					EmptyClip.play()
		
		if Global.current_weapon == 3:
			if Global.ammo_smg > 0:
				if Input.is_action_pressed("fire") and fire_rate <0:
					fire_rate = 0.1
					Shoot.position = position
					Shoot.play()
					fire_smg()
					Global.ammo_smg -= 1
					Global.emit_signal("ammo_changed")
			else:
				if Input.is_action_pressed("fire") and fire_rate <0:
					fire_rate = 0.1
					EmptyClip.position = position
					EmptyClip.play()
		
		if Input.is_action_just_pressed("secondary") and Global.grenade_uses > 0:
			GrenadeShoot.position = position
			GrenadeShoot.play()
			fire_grenade()
			Global.grenade_uses = Global.grenade_uses - 1
			Global.emit_signal("grenade_changed")

func fire():
	var bullet_instance = bullet.instance()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.position = get_global_position()
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)

func fire_shotgun():
	for angle in [-0.3,-0.2, -0.1, 0, 0.1, 0.2, 0.3]:
		var bullet_instance = bullet.instance()
		bullet_instance.rotation_degrees = rotation_degrees + angle
		bullet_instance.position = get_global_position()
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation + angle))
		get_tree().get_root().call_deferred("add_child", bullet_instance)

func fire_smg():
	var bullet_instance = bullet.instance()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.position = get_global_position()
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)

func fire_grenade():
	if Global.grenade_uses > 0:
		var grenade_instance = grenade.instance()
		grenade_instance.position = get_global_position()
		grenade_instance.rotation_degrees = rotation_degrees
		grenade_instance.apply_impulse(Vector2(), Vector2(grenade_speed, 0).rotated(rotation))
		get_tree().get_root().call_deferred("add_child", grenade_instance)

func kill():
	get_tree().reload_current_scene()
	Global.player_health = 100
	Global.grenade_uses = 3

func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		WallHit.position = position
		WallHit.play()
		player_hit(5)
	if "Projectile" in body.name:
		player_hit(15)

func player_hit(num):
	if Global.player_health <= 100:
		Global.player_health -= num
		Global.emit_signal("health_changed")
	if Global.player_health <= 0:
		emit_signal("player_died")
		pass

func update_player():
	died = true

func update_weapon(num):
	Global.current_weapon = num
