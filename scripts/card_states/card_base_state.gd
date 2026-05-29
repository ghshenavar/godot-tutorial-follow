extends CardState


func enter() -> void:
	# in Godot, children get ready before the parent
	if not card_ui.is_node_ready():
		await card_ui.ready
		
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
	
	# in case we entered here by a move getting canceled
	card_ui.reparent_requested.emit(card_ui)
	if card_ui.card.is_single_targeted():
		card_ui.color.color = Color.DARK_RED
	else:
		card_ui.color.color = Color.PLUM
	card_ui.state.text = "BASE"
	card_ui.pivot_offset = Vector2.ZERO
	
	
func on_gui_input(event:InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)
