extends CardState

const MOUSE_YSNAPBACK_THRESHOLD := 138

func enter() -> void:
	card_ui.color.color = Color.GREEN_YELLOW
	card_ui.state.text = "AIMING"
	# we don't care if we are in the drop area or not
	card_ui.targets.clear()
	var offset := Vector2(card_ui.parent.size.x / 2, -card_ui.size.y / 2)
	offset.x -= card_ui.size.x / 2
	card_ui.animate_to_position(card_ui.parent.global_position + offset, 0.2)
	card_ui.drop_point_detector.monitoring = false
	Event.card_aim_started.emit(card_ui)
	
	
func exit() -> void:
	Event.card_aim_ended.emit(card_ui)

func on_input(event:InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var mouse_at_bottom := card_ui.get_global_mouse_position().y > MOUSE_YSNAPBACK_THRESHOLD
	
	if (mouse_motion and mouse_at_bottom) or event.is_action_pressed("right_mouse"):
		transition_requested.emit(self, CardState.State.BASE)
	elif event.is_action_pressed("left_mouse") or event.is_action_released("left_mouse"):
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
