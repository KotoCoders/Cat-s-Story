extends Area2D

@export var dialog_lines: Array[String] = [
	"Привет, путник!",
	"Как твои дела?",
	"У меня для тебя есть задание..."
]

func _rsweady():
	body_entered.connect(_on_Player_entered)
	body_exited.connect(_on_Player_exited)

func _on_Player_entered(body):
	print("entered" + body.name)
	if body.name == "Player":  # Если вошёл игрок
		body.can_talk_to_npc = true
		body.current_npc = self  # Запоминаем, с каким NPC говорим

func _on_Player_exited(body):
	print("exited" + body.name)
	if body.name == "Player":
		body.can_talk_to_npc = false
		body.current_npc = null
