extends Node2D

@export var dialog_lines: Array[String] = [
	"...",
	"Эй, малой! Подсоби, а! Только отремонтировали мост, как этот стащил все доски!",
	"И на ту сторону теперь не попасть, вот гад! Обсуди с дедом вопросик, будь другом?",
]

@export var after_boards_dialog: Array[String] = [
	"Ого, ты нашел все доски!",
	"Теперь можно починить мост!",
	"Спасибо за помощь!"
]
var boards_collected: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("entered" + body.name)
	if body.name == "player":  
		body.can_talk_to_npc = true
		body.current_npc = self 
		if body.inventory.has("wood") and body.inventory["wood"] >= 10 and !boards_collected:
			boards_collected = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("exited" + body.name)
	if body.name == "player":
		body.can_talk_to_npc = false
		body.current_npc = null

func get_dialog() -> Array[String]:
	if boards_collected:
		return after_boards_dialog
	return dialog_lines
	
