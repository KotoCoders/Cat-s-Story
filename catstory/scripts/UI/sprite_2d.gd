extends Sprite2D


var tween: Tween
var levitate_height: float = 30.0 
var levitate_duration: float = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_levitation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start_levitation():
	tween = create_tween().set_loops()  
	tween.set_trans(Tween.TRANS_QUAD)  
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", position.y - levitate_height, levitate_duration/2)
	tween.tween_property(self, "position:y", position.y, levitate_duration/2)
