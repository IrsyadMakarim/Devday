extends Node

var player_health: int = 100
var grenade_uses = 10
var current_weapon = 1
var ammo = 25
var ammo_smg = 75
var paused = false
var game_over = false
var sound = false

signal ammo_changed(new_value)
signal health_changed(new_value)
signal pickup_health(new_value)
signal pickup_grenade(new_value)
signal grenade_changed(new_grenade)
signal weapon_changed(new_weapon)

func reset():
	game_over = false
	player_health = 100
	grenade_uses = 10
	current_weapon = 1
	ammo = 25
	ammo_smg = 75
	paused = false
	emit_signal("ammo_changed")
	emit_signal("grenade_changed")
	emit_signal("health_changed")
	emit_signal("weapon_changed")
