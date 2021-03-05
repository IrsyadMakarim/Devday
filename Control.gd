extends Control

onready var slider = $HSlider
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _process(delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), slider.value)
	Global.sound = true

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	get_tree().change_scene("res://Scene/Menu.tscn")
