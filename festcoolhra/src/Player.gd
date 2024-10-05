extends CharacterBody2D


var SPEED = 300.0
const JUMP_VELOCITY = -500.0
var acceleration = 1
var dash_cooldown = false
var double = false
var canjump = true
@onready var JumpTimer = get_node("JumpTimer")


func _on_dash_timer_timeout() -> void:
	dash_cooldown = false
func _on_dash_duration_timeout() -> void:
	if SPEED == 800:
		SPEED = 300.0
func _on_jump_timer_timeout() -> void:
	canjump = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if not JumpTimer.time_left:
			JumpTimer.start()
		velocity += get_gravity() * delta
	if is_on_floor():
		canjump = true
		double = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and canjump:
		velocity.y = JUMP_VELOCITY
		canjump = false
	elif Input.is_action_just_pressed("ui_accept") and not is_on_floor() and not double:
		velocity.y = JUMP_VELOCITY
		double = true
	if Input.is_action_just_pressed("SHIFT") and is_on_floor() and not dash_cooldown:
		get_node("DashTimer").start()
		get_node("DashDuration").start()
		dash_cooldown = true
		SPEED = 800

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if SPEED < 400:
			SPEED += 0.5
	else:
		SPEED = 300.0
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
