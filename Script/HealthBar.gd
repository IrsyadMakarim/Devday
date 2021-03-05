extends CanvasLayer

onready var health_bar = $HealthBar
onready var ammo = $VBoxContainer/Ammo
onready var grenade = $VBoxContainer3/Grenade

func _ready():
	Global.connect("health_changed", self, "set_new_health_value")
	Global.connect("grenade_changed", self, "set_grenade")
	Global.connect("ammo_changed", self, "set_ammo")
	health_bar.value = Global.player_health
	grenade.text = str(Global.grenade_uses) + "/10"
	ammo.text = "∞"

func set_new_health_value():
	health_bar.value = Global.player_health

func set_grenade():
	grenade.text = str(Global.grenade_uses) + "/10"

func set_ammo():
	if Global.current_weapon == 1:
		ammo.text = "∞" 
	if Global.current_weapon == 2:
		ammo.text = str(Global.ammo)
	if Global.current_weapon == 3:
		ammo.text = str(Global.ammo_smg)
