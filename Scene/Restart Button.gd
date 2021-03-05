extends MarginContainer

onready var selector_one =$CenterContainer/VBoxContainer/CenterContainer/HBoxContainer/Selector
onready var selector_two = $CenterContainer/VBoxContainer/CenterContainer3/HBoxContainer/Selector

var current_selection = 0

func _ready():
	set_current_selection(0)

func _process(delta):
	if Global.paused == true:
		if Input.is_action_just_pressed("ui_down") and current_selection < 1:
			current_selection += 1
			set_current_selection(current_selection)
		elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
			current_selection -= 1
			set_current_selection(current_selection)
		elif Input.is_action_just_pressed("ui_accept"):
			handle_selection(current_selection)


func handle_selection(_current_selection):
	if _current_selection == 0:
		get_tree().change_scene("res://Scene/World.tscn")
		Global.reset()
		get_tree().paused = false
	elif _current_selection == 1:
		get_tree().change_scene("res://Scene/Menu.tscn")
		get_tree().paused = false
		GameMusic.stop()
		hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Global.paused = !Global.paused
		visible = !visible
		get_tree().paused = !get_tree().paused

func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	if _current_selection == 0:
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_two.text = ">"
