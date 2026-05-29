extends CardState

const DRAG_MINIMUM_THRESHOLD := 0.05

var minimum_drag_time_elapsed := false

func enter() -> void:
	# we are doing this so that if our scene structure changes our cards are still functional
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
		
	card_ui.color.color = Color.LEMON_CHIFFON
	card_ui.state.text = "DRAGGING"
	
	minimum_drag_time_elapsed = false
	# we set the false so timer is paused when scene tree is paused
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUM_THRESHOLD, false)
	threshold_timer.timeout.connect(func(): minimum_drag_time_elapsed = true)
	
	
func on_input(event:InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	# follow the mouse around
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	if minimum_drag_time_elapsed and confirm:
		# to not instantly pick up the same input
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
