extends Node2D

var ui_elements
var ent = 0
#var important = get_tree().get_nodes_in_group("UI_chat")
func _ready() -> void:
	visible = false
	pass 
	
func _process(_delta: float) -> void:
	if ui_elements:
		if ui_elements[0].visible:
			$AnimatedSprite2D.stop()
			visible = false
		elif ui_elements[0].started_chat == false and ent != 0:
			visible = true
			$AnimatedSprite2D.play("Button")

func _on_dummy_area_2d_body_entered(body: Node2D) -> void:
	ent = 1
	ui_elements = body.get_tree().get_nodes_in_group("UI_chat")
	print(ui_elements[0].visible)
	if body.name == "player": 
		visible = true
		$AnimatedSprite2D.play("Button")
			
func _on_dummy_area_2d_body_exited(body: Node2D) -> void:
	ent = 0
	if body.name == "player":
		$AnimatedSprite2D.stop()
		visible = false
