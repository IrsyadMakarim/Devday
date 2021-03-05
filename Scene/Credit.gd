extends MarginContainer

func _ready():
	yield(get_tree().create_timer(15.0),"timeout")
	get_tree().change_scene("res://Scene/Menu.tscn")
