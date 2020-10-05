extends KinematicBody

# --------------------------- VARIABLES --------------------------- #
export var global_speed = 8
var speed = global_speed
var low_speed = global_speed * 0.4
var crouch_speed = 2.5
var is_crouching = false

var default_height = 1.5
var crouch_height = 0.5
export var crouch_transition = 7
var actual_crouch_height

export var mouse_sensitivity = 0.2

var h_acceleration = 6
var air_acceleration = 1
var normal_acceleration = 6
var gravity = 20
var jump = 8
var full_contact = false

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

onready var head = $head
onready var player_collider = $CollisionShape

onready var ground_check = $ground_check
onready var head_bonker = $head_bonker

onready var label_status = $status
onready var label_time = $time

onready var tutorial_animations = $tutorial
var tutorial_ends = false

onready var footsteps = $footsteps
var velocity
var debug_counter = 0.0

onready var fall = $fall
onready var timer = $fall/Timer

# --------------------------- READY OR NOT --------------------------- #
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	tutorial_animations.play("tutorial_up")
	crt_shader()

# --------------------------- INPUT EVENT --------------------------- #
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-70), deg2rad(70))
	
	# TUTORIAL part
	if event is InputEventKey:
		if event.pressed and tutorial_ends == false:
			tutorial_animations.play("tutorial_down")
			tutorial_ends = true

# --------------------------- PROCESS DELTA --------------------------- #
func _process(delta):
	# QUIT
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://scenes/levels/menu.tscn")
	# SUICIDE / KYS / RELOAD
	if Input.is_action_just_pressed("suicide"):
		get_tree().reload_current_scene()
	keep_time()
	player_status()

# --------------------------- CRT SHADER --------------------------- #
func crt_shader():
	var crtison = load_save()
	if crtison == "True":
		$crt.show()
	else:
		$crt.hide()

# --------------------------- LOAD CONFIG --------------------------- #
func load_save():
	var file = File.new()
	file.open("res://config.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	return content

# --------------------------- TIME --------------------------- #
func keep_time():
	var timeDict = OS.get_time();
	var hour = timeDict.hour;
	var minute = timeDict.minute;
	var second = timeDict.second;
	
	var hour_f
	var minute_f
	var second_f
	
	if hour < 10:
		hour_f = '0' + str(hour)
	else:
		hour_f = str(hour)
	
	if minute < 10:
		minute_f = '0' + str(minute)
	else:
		minute_f = str(minute)
	
	if second < 10:
		second_f = '0' + str(second)
	else:
		second_f = str(second)
	
	label_time.text = str(hour_f) + ' : ' + str(minute_f) + ' : ' + str(second_f)

# --------------------------- STATS --------------------------- #
func player_status():
	pass

# --------------------------- PHYSICS --------------------------- #
func _physics_process(delta):
	
	var head_bonked = false
	direction = Vector3()
	full_contact = ground_check.is_colliding()
	
	if head_bonker.is_colliding():
		head_bonked = true
	
	# JUMP / GRAVITY
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration = normal_acceleration
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()) and head_bonked == false:
		gravity_vec = Vector3.UP * jump
		timer.start()
	
	# CROUCH 1
	if Input.is_action_pressed("crouch"):
		player_collider.shape.height -= crouch_transition * delta
	elif not head_bonked:
		player_collider.shape.height += crouch_transition * delta
	
	player_collider.shape.height = clamp(player_collider.shape.height, crouch_height, default_height)
	
	# MOVEMENT VECTOR
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	# CROUCH 2
	if Input.is_action_pressed("mode_shift") and is_crouching != true:
		speed = low_speed
#	elif Input.is_action_pressed("mode_x") and is_crouching != true:
#		speed = top_speed
	elif Input.is_action_pressed("crouch"):
		speed = crouch_speed
	else:
		speed = global_speed
	
	if player_collider.shape.height < 1:
		is_crouching = true
		speed = crouch_speed
	else:
		is_crouching = false
	
	# MOVEMENT PROCESS
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	
#	move_and_slide(movement, Vector3.UP)
	velocity = move_and_slide(movement, Vector3.UP)
	
	# FOOT STEPS
	if abs(velocity.z) >= 0.3 or abs(velocity.x) >= 0.3:
		debug_counter += 1
	elif abs(velocity.z) <= 0.3 or abs(velocity.x) <= 0.3:
		debug_counter = 0
	
	if debug_counter != 0 and is_on_floor():
		if speed == global_speed and debug_counter % 30 == 0:
			footsteps.play()
		elif speed == low_speed and debug_counter % 45 == 0:
			footsteps.play()

func _on_Timer_timeout():
	fall.play()
