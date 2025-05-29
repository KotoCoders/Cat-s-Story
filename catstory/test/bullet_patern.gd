extends Node2D

@export var bullet_scene: PackedScene 
@export var bullet_scene2: PackedScene
@export var bullet_scene4: PackedScene
@export var bullet_speed = 300         # Скорость пуль
@export var spawn_rate = 0.2    # Как часто спавнить (раз в 0.2 сек)

var direction = Vector2.DOWN

var patern

func _ready():
	$Timer.wait_time = spawn_rate  # Устанавливаем интервал спавна
	$Timer.start()                 # Запускаем таймер\


func bullet_setting(bullet, speed, position):
	bullet.speed = speed
	bullet.position = position  # Или используй global_position если нужно
	get_parent().add_child(bullet)  # Добавляем на сцену

func rand_attack():
	patern = randi_range(1,4)

func _on_Timer_timeout():
	
	pass
	#shoot_straight_delayed(3)
	#match patern:
		#1:
			#shotgun()
		#2:
			#circle_12()
		#3:
			#beep()
		#4:
			#delayed_ring()
		#5:
			#wall_down()
		#6:
			#rotation_4bullets()


func shotgun():
	var time = Time.get_ticks_msec() / 1000.0  # Time вместо OS в Godot 4льный вызов через OS
	for i in range(4):
		var bullet = bullet_scene.instantiate()  # Создаём новую пулю для каждого угла
		var angle = i * (2 * PI / 12) + time * 2  # Динамический угол со временем
		bullet.direction = Vector2(cos(angle), sin(angle)).normalized()  # Нормализуем вектор

		bullet_setting(bullet, bullet_speed, position)

func circle_12():
	for i in range(12):  # 12 пуль в круге
		var bullet = bullet_scene.instantiate()  # Создаём пулю
		var angle = i * (2 * PI / 12)        # Вычисляем угол (360°/12 = 30° на пулю)
		bullet.direction = Vector2(cos(angle), sin(angle))  # Направление (x=cos, y=sin)
		
		bullet_setting(bullet, bullet_speed, position)

func circle_12_2():
	var offset_angle = deg_to_rad(15)  # Смещение на 15° (переводим в радианы)
	
	for i in range(12):  # 12 пуль в круге
		var bullet = bullet_scene.instantiate()  
		var angle = offset_angle + i * (2 * PI / 12)  # Основной угол (30° на пулю) + смещение
		bullet.direction = Vector2(cos(angle), sin(angle))  # Направление (x=cos, y=sin)
		
		bullet_setting(bullet, bullet_speed, position)

func beep():
	for i in range(5):
		var bullet = bullet_scene.instantiate()
		var angle = -PI/4 + (i * PI/4)  # От -45° до +45°
		bullet.direction = Vector2(cos(angle), sin(angle))
		
		bullet_setting(bullet, bullet_speed, position)

func delayed_ring():
	for i in range(36):
		var bullet = bullet_scene.instantiate()
		await get_tree().create_timer(0.05).timeout  # Задержка между пулями
		var angle = i * (2 * PI / 36)
		bullet.direction = Vector2(cos(angle), sin(angle))
		
		bullet_setting(bullet, bullet_speed, position)

func wall_down():
	for i in range(0, 160, 40):
		var bullet = bullet_scene.instantiate()
		bullet_setting(bullet, bullet_speed, position + Vector2(i,0))

func rotation_4bullets():
	var bullets4 = bullet_scene4.instantiate()
	bullet_setting(bullets4, bullet_speed, position)

func shoot_straight_delayed(quantity):
	var delay = 0.1  # Задержка между выстрелами
	for i in range(quantity):
		var bullet = bullet_scene.instantiate()
		bullet.direction = direction
		bullet_setting(bullet, bullet_speed+200, position)
		await get_tree().create_timer(delay).timeout  # Ждём перед следующим выстрелом

func shoot_in_4_directions():
	var directions = [
		Vector2(1, 1).normalized(),   # Вправо-вверх
		Vector2(-1, 1).normalized(),   # Влево-вверх
		Vector2(1, -1).normalized(),  # Вправо-вниз
		Vector2(-1, -1).normalized()  # Влево-вниз
	]
	for direction in directions:
		var bullet = bullet_scene.instantiate()
		bullet.direction = direction
		bullet_setting(bullet, bullet_speed, position)

func shoot_in_4_directions2():
	var directions = [
		Vector2(1, 0).normalized(),   # Вправо-вверх
		Vector2(-1, 0).normalized(),   # Влево-вверх
		Vector2(0, 1).normalized(),  # Вправо-вниз
		Vector2(0, -1).normalized()  # Влево-вниз
	]
	for direction in directions:
		var bullet = bullet_scene.instantiate()
		bullet.direction = direction
		bullet_setting(bullet, bullet_speed, position)
