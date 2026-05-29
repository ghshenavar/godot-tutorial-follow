extends CardState

var played: bool

func enter() -> void:
	card_ui.color.color = Color.BLACK
	card_ui.state.text = "RELEASED"
	
	played = false
	if not card_ui.targets.is_empty():
		played = true
		
		
		
func on_input(_event:InputEvent) -> void:
	if played:
		return
	transition_requested.emit(self, CardState.State.BASE)
