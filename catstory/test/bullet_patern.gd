extends Node2D

@export var bullet_scene: PackedScene   # Сцена пули, которую будем спавнить
@export var bullet_scene2: PackedScene
@export var bullet_scene4: PackedScene
@export var bullet_speed = 300         # Скорость пуль
@export var spawn_rate = 0.2    # Как часто спавнить (раз в 0.2 сек)

var patern

func _ready():
	$Timer.wait_time = spawn_rate  # Устанавливаем интервал спавна
	$Timer.start()                 # Запускаем таймер\


func bullet_setting(bullet, speed, position):
	bullet.speed = bullet_speed
	bullet.position = position  # Или используй global_position если нужно
	get_parent().add_child(bullet)  # Добавляем на сцену

func rand_attack():
	patern = randi_range(1,4)

func _on_Timer_timeout():
	rotation_4bullets()

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


	#shotgun()
	#circle_12()
	#beep()
	#delayed_ring()
	pass

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





#func _on_Timer_timeout():
	#for i in range(12):  # 12 пуль в круге
		#var bullet = bullet_scene.instantiate()  # Создаём пулю
		#var angle = i * (2 * PI / 12)        # Вычисляем угол (360°/12 = 30° на пулю)
		#bullet.direction = Vector2(cos(angle), sin(angle))  # Направление (x=cos, y=sin)
		#bullet.speed = bullet_speed           # Задаём скорость
		#bullet.position = position            # Позиция спавна (где стоит PatternSpawner)
		#get_parent().add_child(bullet)        # Добавляем пулю на сцену
