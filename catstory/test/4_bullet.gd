extends Node2D

@export var speed = 600
@export var direction = Vector2.RIGHT


func _ready() -> void:
	$bullet.direction = Vector2.ZERO
	$bullet2.direction = Vector2.ZERO
	$bullet3.direction = Vector2.ZERO
	$bullet4.direction = Vector2.ZERO




func _process(delta):
	position += direction.normalized() * speed * delta
	rotation += 0.03


func _on_timer_timeout() -> void:
	queue_free()
