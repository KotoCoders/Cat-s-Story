extends StaticBody2D

@export var hp = 100


func _process(_delta: float) -> void:
	$Label.text = str(hp)
	if hp <= 0:
		$Label.text = "я вмэр"
		await get_tree().create_timer(3).timeout
		queue_free()

func signal_take_damage(damage:int, _type):
	hp-=damage
