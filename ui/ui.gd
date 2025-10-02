extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.main_menu_opened.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
