extends Control


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$MarginContainer/MessageTimer.timeout.connect(_on_message_timer_timeout)
	EventBus.timer_updated.connect(update_timer)
	$MarginContainer/Message.hide()
	
func show_message(text):
	$MarginContainer/Message.text = text
	$MarginContainer/Message.show()
	$MarginContainer/MessageTimer.start()
	
func update_timer(timer):
	$MarginContainer2/HBoxContainer/TimerLabel.text = str(timer)
	
func _on_message_timer_timeout():
	$MarginContainer/Message.hide()
