extends CanvasLayer

func hp_changed(dmg):
	print(dmg)
	if(dmg >= 5):
		$Control/HP.play("HP_MAX")
	elif(dmg >= 4):
		$Control/HP.play("HP_80%")
	elif(dmg >= 3):
		$Control/HP.play("HP_60%")
	elif(dmg >= 2):
		$Control/HP.play("HP_40%")
	elif(dmg >= 1):
		$Control/HP.play("HP_20%")
	elif(dmg == 0):
		$Control/HP.play("HP_0%")
