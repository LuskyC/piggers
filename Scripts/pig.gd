extends CharacterBody3D
class_name Pig

var sens = 0.1
var speed = 1
var jump = 6
var accel = 8
var _delta
var counter = 0
var direction = Vector2()
var vel = Vector3()
@export var coeff = 50
var gravity = -22
var max_gravity = -30

@onready var head = $head

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var movement = event.relative
		
		# Поворот головы вверх/вниз
		head.rotation.x += -deg_to_rad(movement.y * sens)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
		# Поворот всего тела влево/вправо
		rotation.y += -deg_to_rad(movement.x * sens)
		
	# Выход из захвата мыши по Escape
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	_delta = delta
	dir()

func dir():
	direction = Vector2(0,0)
	
	# ИСПРАВЛЕНО: используем is_action_pressed для непрерывного движения
	if Input.is_action_pressed('ui_up'): 
		direction.y += 1
	if Input.is_action_pressed('ui_down'):
		direction.y -= 1
	if Input.is_action_pressed('ui_right'):
		direction.x += 1
	if Input.is_action_pressed('ui_left'):
		direction.x -= 1
	
	# Нормализуем и поворачиваем направление относительно вращения персонажа
	direction = direction.normalized()
	
	# Преобразуем локальное направление в мировые координаты
	var forward = -transform.basis.z
	var right = transform.basis.x
	
	var move_direction = forward * direction.y + right * direction.x
	
	# Применяем движение с интерполяцией
	vel.x = lerp(vel.x, move_direction.x * speed, accel * _delta)
	vel.z = lerp(vel.z, move_direction.z * speed, accel * _delta)
	
	# Гравитация
	vel.y += gravity * _delta
	if vel.y < max_gravity:
		vel.y = max_gravity
	
	# Прыжок
	if Input.is_action_just_pressed('jump') and is_on_floor():
		vel.y = jump
	
	# Устанавливаем скорость и двигаем
	velocity = vel
	move_and_slide()
	
	# Сбрасываем Y скорость при нахождении на полу
	if is_on_floor() and vel.y < 0:
		vel.y = 0


func _on_oat_detector_area_entered(area):
	var parent = area.get_parent()
	if parent.get("Class"):
		if parent.get("Class") == "Oat":
			parent.queue_free()
			self.counter += 10
			self.increase_size(self.counter)
			print(self.counter)
	
func increase_size(counter):
	self.scale = Vector3(1 + (counter/self.coeff), 1 + (counter/self.coeff), 1+(counter/self.coeff))
	print(self.global_position.y)
	self.global_position.y += (self.global_position.y *  (counter/self.coeff))
	print(self.global_position.y) 	
	self.speed += self.speed * (counter/self.coeff)
