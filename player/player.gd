extends CharacterBody3D

@onready var head = $Head
@onready var cam = $Head/Camera3D

func _on_hud_resume() -> void:
	start()

var accel = 8
var BASE_SPEED = 7.0
var SPEED = 0
var JUMP_VELOCITY = 6.5
var crouched = false #определяет приседает игрок или нет
var input_dir = Vector3(0,0,0) #направление нажатия кнопок
var direction = Vector3() # направление игрок
var sens = 0.005
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 1.8

var resumed = false

func start():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	resumed = true
	
func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	resumed = false

func _ready():
	start()

func _input(event: InputEvent): #повороты мышкой
	if Input.is_action_just_pressed("ui_cancel"):
		pause()
	if resumed:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * sens)
			cam.rotate_x(-event.relative.y * sens)
			cam.rotation.x = clamp(cam.rotation.x,deg_to_rad(-89),deg_to_rad(89))
			
func _physics_process(delta):
	if not is_on_floor(): #гравитация
		velocity.y -= gravity * delta
	
	# после падения
	if position.y < -10:
		position = Vector3(0, 0,0 )
	
	if resumed:
		SPEED = BASE_SPEED
		if Input.is_action_pressed("+crouch"): #приседание
			crouched = true
			SPEED *= 0.5
			$CollisionShape3D.scale.y = lerp($CollisionShape3D.scale.y,0.4,0.4)
			$CollisionShape3D.position.y = lerp($CollisionShape3D.position.y, 0.66,0.4)
			head.position.y = lerp(head.position.y, 1.0, 0.3)
		else:
			crouched = false
			$CollisionShape3D.scale.y = lerp($CollisionShape3D.scale.y, 1.0 ,0.4)
			$CollisionShape3D.position.y = lerp($CollisionShape3D.position.y, 1.143,0.4)
			head.position.y = lerp(head.position.y, 1.85 , 0.3)
	 
		if is_on_floor() and Input.is_action_pressed("+shift"):
			SPEED *= 1.5

	 
		if Input.is_action_just_pressed("ui_accept") and is_on_floor() and crouched == false: # прыжок
			velocity.y = JUMP_VELOCITY
			
		################################################хождение туда сюда
		input_dir = Input.get_vector("+a", "+d", "+w", "+s")
		direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	 
		velocity.x = lerp(velocity.x ,direction.x * SPEED, accel * delta)
		velocity.z = lerp(velocity.z ,direction.z * SPEED, accel * delta)
		move_and_slide()
		###################################################-- 
		
