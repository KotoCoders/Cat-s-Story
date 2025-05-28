extends CanvasLayer
 #@onready var anim = $"."
# Called when the node enters the scene tree for the first time.

func _ready():
	$"../CanvasLayer".hp_changed(100)
#
#
func hp_changed(dmg):
	print("pisya popa")
	print(dmg)
	if(dmg >= 80):
		print(200)
		$Control/HP.play("HP_MAX")
	elif(dmg >= 60):
		$Control/HP.play("HP_80%")
	elif(dmg >= 40):
		$Control/HP.play("HP_60%")
	elif(dmg >= 20):
		$Control/HP.play("HP_40%")
	elif(dmg >= 0):
		$Control/HP.play("HP_40%")
	elif(dmg == 0):
		$Control/HP.play("HP_0%")
