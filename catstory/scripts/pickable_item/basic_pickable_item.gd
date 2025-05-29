extends Area2D

@export var item_name = "test_item"
@export var amount = 5

func _on_body_entered(body):
	if body.has_method("pick_up_item"):
		body.pick_up_item(item_name, amount)
		queue_free()
