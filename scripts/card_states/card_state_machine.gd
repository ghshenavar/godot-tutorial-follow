class_name CardStateMachine
extends Node

@export var initial_state: CardState

var current_state: CardState
var states := {}

func init(card: CardUI) -> void:
	# iterate over and get all the states
	for child in get_children():
		if child is CardState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.card_ui = card
	# start from initial state if applicable		
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		
# have the state handle the input on card		
func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)
		
func on_gui_input(event : InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)
		
func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()
		
func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()
		
func _on_transition_requested(from: CardState, to: CardState.State) -> void:
	# the from has to match current state, if the return is executed here indication of bug
	if from != current_state:
		return
	var new_state: CardState = states[to]
	# check if requested state is valid
	if not new_state:
		return
	# initial state might not be applicable
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state

		
