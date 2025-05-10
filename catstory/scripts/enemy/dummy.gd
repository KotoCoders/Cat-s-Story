extends StaticBody2D

@export var hp = 100


func _process(_delta: float) -> void:
	$Label.text = str(hp)
	if hp <= 0:
		$Label.text = "я вмэр"
		await get_tree().create_timer(3).timeout
		queue_free()


func signal_get_damage(damage:int, type, player_pos):
	if type == "claws":
		hp-= damage
	if type == "poof":
		hp -= damage
