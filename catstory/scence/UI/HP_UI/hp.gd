extends CanvasLayer
 #@onready var anim = $"."
# Called when the node enters the scene tree for the first time.

func _ready():
	$".".hp_changed(100)
#
#
func hp_changed(dmg):
	print(dmg)
	if(dmg >= 10):
		$Control/HP.play("HP_MAX")
	elif(dmg >= 8):
		$Control/HP.play("HP_80%")
	elif(dmg >= 6):
		$Control/HP.play("HP_60%")
	elif(dmg >= 4):
		$Control/HP.play("HP_40%")
	elif(dmg >= 2):
		$Control/HP.play("HP_20%")
	elif(dmg == 0):
		$Control/HP.play("HP_0%")
