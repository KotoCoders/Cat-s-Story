extends Area2D

func _ready():
	body_entered.connect(_body_entered)

func _body_entered(_body):
	pass
