class_name State
extends Node


var character: Character
var state_machine: StateMachine


func _ready() -> void:
	await owner.ready
	character = owner as Character
	assert(
		character != null, 
		"State must be used only in character scene. It needs owner to be Character node."
	)

func enter():
	pass

func exit():
	pass
	
func physics_update(_delta: float):
	pass

func handle_input(_event):
	pass
