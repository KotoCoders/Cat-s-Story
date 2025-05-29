extends Node2D

@export var dialog_lines: Array[String] = [
	"Мир был создан давным-давно и существовал в спокойствии и согласии, пока в нем не началась война.",
	"Немногим удалось спастись от Холода и Ненависти, которыми одарила Королева своих врагов...",
	"Но оставшиеся рассказывают об этом с ужасом и нескрываемым страхом.",
	"Выжившие... Выжившие счастливчики и те, кого Фортуна не обделила мудростью...",
	"Оставшиеся королевства - позабыли о распрях и объединились в борьбе против Сил Тьмы.",
	"Второго шанса у нас не будет. Судьба всего мира стоит на кону.",
	"Ты обладаешь силой, которая дана не всем окружающим. Используй её с умом.",
	"Однажды, сын мой, ты продолжишь путь, начатый мной."
]

var tween: Tween
var levitate_height: float = 20.0 
var levitate_duration: float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_levitation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start_levitation():
	tween = create_tween().set_loops()  
	tween.set_trans(Tween.TRANS_SINE)   
	tween.tween_property(self, "position:y", position.y - levitate_height, levitate_duration/2)
	tween.tween_property(self, "position:y", position.y, levitate_duration/2)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("entered" + body.name)
	if body.name == "player":  
		body.can_talk_to_npc = true
		body.current_npc = self 


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("exited" + body.name)
	if body.name == "player":
		body.can_talk_to_npc = false
		body.current_npc = null
