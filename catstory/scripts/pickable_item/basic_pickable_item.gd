extends Area2D

var item_name = "test_item"
var amount = 5

func _on_body_entered(body):
	if body.has_method("pick_up_item"):
		body.pick_up_item(item_name, amount)
		queue_free()  # Удаляем предмет после подбора
	
