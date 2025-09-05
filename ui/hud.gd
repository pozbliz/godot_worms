extends Control


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$MarginContainer/MessageTimer.timeout.connect(_on_message_timer_timeout)
	EventBus.score_changed.connect(update_score)
	EventBus.coin_picked_up.connect(update_score)
	EventBus.timer_updated.connect(update_timer)
	$MarginContainer/Message.hide()
	
func show_message(text):
	$MarginContainer/Message.text = text
	$MarginContainer/Message.show()
	$MarginContainer/MessageTimer.start()
	
func update_score(score):
	$MarginContainer2/HBoxContainer/ScoreLabel.text = str(score)
	
func update_timer(timer):
	$MarginContainer2/HBoxContainer/TimerLabel.text = str(timer)
	
func _on_message_timer_timeout():
	$MarginContainer/Message.hide()
