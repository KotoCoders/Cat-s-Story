extends Camera2D

var target_zoom := Vector2.ONE
var zoom_speed := 0.5
var tween: Tween

var standart_zoom: Vector2 = Vector2(zoom.x, zoom.y)

var target = [0, 0]
var cur = [0, 0]
var MAX_SPEED = 10;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#tween = create_tween()
	#tween.set_ease(Tween.EASE_IN_OUT)
	#tween.set_trans(Tween.TRANS_SINE) # Replace with function body.

func zoom_to(new_zoom: Vector2, duration: float = 1.0):
	target_zoom = new_zoom
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "zoom", target_zoom, duration)
	tween.set_ease(Tween.EASE_IN_OUT)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.x += min(target[0] - cur[0], MAX_SPEED)
	position.y += min(target[1] - cur[1], MAX_SPEED)
	cur[0] += min(target[0] - cur[0], MAX_SPEED)
	cur[1] += min(target[1] - cur[1], MAX_SPEED)
func set_target_offset(to : Array) -> void:
	target = to;
