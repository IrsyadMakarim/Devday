extends Area2D

func _ready():
	Global.connect("pickup_grenade", self, "grenade_pickup")

func grenade_pickup():
	if Global.ammo < 25:
		Global.ammo = Global.ammo + (25 - Global.ammo)
	if Global.grenade_uses < 10:
		Global.grenade_uses = Global.grenade_uses + (10 - Global.grenade_uses)
		Global.emit_signal("grenade_changed")
	if Global.ammo_smg < 75:
		Global.ammo_smg = Global.ammo_smg + (75 - Global.ammo_smg)

func _on_AmmoPickup_body_entered(body):
	if Global.grenade_uses < 3 or Global.ammo < 25 or Global.ammo_smg < 75:
		if "Player" in body.name:
			$Sprite.hide()
			Global.emit_signal("pickup_grenade")
			Global.emit_signal("ammo_changed")
			$CollisionShape2D.set_deferred("disable", true)
			GrenadePickupSound.position = position
			GrenadePickupSound.play()
			yield(get_tree().create_timer(0.2), "timeout")
			queue_free()
