#extends Node2D
#
#signal state_changed(new_state)
#
#onready var player_detect = $PlayerDetectZone
#var current_state: int = State.PATROL setget set_state
#var player: Player = null
#
#enum State{
#	PATROL,
#	ENGAGE
#}
#
#func set_state(new_state: int):
#	if new_state == current_state:
#		return
#
#	current_state = new_state
#	emit_signal("state_changed", current_state)
#
#func _on_PlayerDetectZone_body_entered(body):
#	if body.is_in_group("player"):
#		set_state(State.ENGAGE)
#		player = body
