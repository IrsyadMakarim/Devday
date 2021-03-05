extends MarginContainer

onready var selector = $CenterContainer/VBoxContainer/CenterContainer2/HBoxContainer/Selector

var current_selection = 0

func _ready():
	set_current_selection(0)

func _process(delta):
	if Global.game_over == true:
		if Input.is_action_just_pressed("ui_accept"):
			handle_selection(current_selection)

func set_current_selection(_current_selection):
	selector.text = ""
	if _current_selection == 0:
		selector.text = ">"

func handle_selection(_current_selection):
	if _current_selection == 0:
		get_tree().change_scene("res://Scene/Menu.tscn")
		get_tree().paused = !get_tree().paused
		GameMusic.stop()
