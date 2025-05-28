extends StaticBody2D

@export var dialog_lines: Array[String] = [
	"эй!",
	"Ты это нарочно делаешь?",
	"ПЕРЕСТАНЬ"
]


@export var hp = 100

func _process(_delta: float) -> void:
	$Label.text = str(hp)
	if hp <= 0:
		$Label.text = "я вмэр"
		await get_tree().create_timer(3).timeout
		queue_free()



func _on_dummy_area_2d_body_entered(body):
	print("entered" + body.name)
	if body.name == "player":  
		body.can_talk_to_npc = true
		body.current_npc = self   


func _on_dummy_area_2d_body_exited(body):
	print("exited" + body.name)
	if body.name == "player":
		body.can_talk_to_npc = false
		body.current_npc = null


func signal_get_damage(damage:int, type, player_pos):
	if type == "claws":
		hp-= damage
	if type == "poof":
		hp -= damage

