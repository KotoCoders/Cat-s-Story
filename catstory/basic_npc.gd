extends Node2D
# Called when the node enters the scene tree for the first time.
@export var dialog_lines: Array[String] = [
	
]
func _ready() -> void:
	pass
	#var parent = get_parent()
	#if parent.has_method("get_text"):
		#var parent_text = parent.get_text()
		#var lines = parent_text.split("\n")
		#dialog_lines = lines
	#else:
		#print("Родительский объект не имеет метода get_text()")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":  
		body.can_talk_to_npc = true
		body.current_npc = self.get_parent()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player":
		body.can_talk_to_npc = false
		body.current_npc = null
