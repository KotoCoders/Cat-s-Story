extends CanvasLayer

@onready var text_label = $AnimatedSprite2D/TextLabe1
@onready var continue_button = $AnimatedSprite2D/TextLabe1/ContinueButton

signal dialog_finished

var current_line = 0
var dialog_lines = []
var started_chat = false

func _ready():
	add_to_group("UI_chat")
	visible = false 
	continue_button.connect("pressed", Callable(self, "_on_ContinueButton_pressed"))

func start_dialog(lines):
	started_chat = true
	$AnimatedSprite2D/AudioStreamPlayer2D.play()
	dialog_lines = lines
	current_line = 0
	show()
	_display_line()

func _display_line():
	if current_line < dialog_lines.size():
		text_label.text = dialog_lines[current_line]

func _on_ContinueButton_pressed():
	current_line += 1
	if current_line >= dialog_lines.size():
		started_chat = false
		visible = false
		$AnimatedSprite2D/AudioStreamPlayer2D.stop()
	else:
		$AnimatedSprite2D/AudioStreamPlayer2D.play()
	_display_line()
