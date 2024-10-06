extends CharacterBody2D

var SPEED = 300.0
var current_speed = 0.0

var direction: float
var moving: bool

const JUMP_VELOCITY = -500.0
var acceleration = 20
var dash_cooldown = false
var double = false
var canjump = true
var savejump = false
@onready var JumpTimer = $JumpTimer
@onready var DashTimer = $DashTimer
@onready var FallTimer = $FallTimer
@onready var DashDuration = $DashDuration

@onready var Feet: Node2D = $Feet

var landed: bool = false
var LandingParticles = preload("res://game_objects/VFX/LandingParticles.tscn")

func _on_dash_timer_timeout() -> void:
	dash_cooldown = false
func _on_dash_duration_timeout() -> void:
	if SPEED == 800:
		SPEED = 300.0
func _on_jump_timer_timeout() -> void:
	canjump = false
func _on_fall_timer_timeout() -> void:
	savejump = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		landed = false
		if not JumpTimer.time_left:
			JumpTimer.start()
		velocity += get_gravity() * delta
	if is_on_floor():
		if not landed:
			Feet.add_child(LandingParticles.instantiate())
		landed = true
		canjump = true
		double = false
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and canjump or savejump:
		velocity.y = JUMP_VELOCITY
		canjump = false
		savejump = false
	elif Input.is_action_just_pressed("ui_accept") and not is_on_floor() and not double:
		velocity.y = JUMP_VELOCITY
		double = true
	elif Input.is_action_just_pressed("ui_accept") and not is_on_floor() and double:
		savejump = true
		FallTimer.start()
	if Input.is_action_just_pressed("SHIFT") and is_on_floor() and not dash_cooldown:
		DashTimer.start()
		DashDuration.start()
		dash_cooldown = true
		current_speed = 800
		
	moving = false
	
	if Input.is_action_pressed("ui_left"):
		direction += -1
		moving = true
	
	if Input.is_action_pressed("ui_right"):
		direction += 1
		moving = true
		
	direction = clamp(direction, -1, 1)
	
	if moving:
		current_speed = move_toward(current_speed, direction*SPEED, acceleration)
	else:
		current_speed = move_toward(current_speed, 0, acceleration)
		
	velocity.x = current_speed

	move_and_slide()
