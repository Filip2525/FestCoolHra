extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var idle_wait_timer = $IdleTimer
@onready var idle_move_timer = $IdleMove
@onready var detection_ray = $RayCast2D
@onready var cool_down_timer = $CoolDown

var status = 0 #0 - idle, 1 - angry, 2 - dead
var moving = 0

@export var idle_speed = 40
@export var speed = 75
@export var gravity = 15
var direction = Vector2(1, gravity)

@export var idle_move_time = 3
@export var idle_wait_time = 3

@export var detection_range = 250
var player: CharacterBody2D

func _ready() -> void:
	idle_wait_timer.start()
	
func _physics_process(delta: float) -> void:
	if status == 0:
		if moving == 0:
			animation.play("idle")
			velocity = Vector2(0, velocity.y) * 60 * delta
		if moving == 1:
			animation.play("run")
			velocity.x = direction.x * idle_speed * delta * 60
	
	if detection_ray.is_colliding() and detection_ray.get_collider().is_in_group("player"):
		player = detection_ray.get_collider()
		status = 1
		cool_down_timer.start()
		
	if status == 1:
		var distance_to_player_x = player.global_position.x - global_position.x
		print(distance_to_player_x)
		if distance_to_player_x > 0:
			direction.x = 1
		else:
			direction.x = -1
		velocity.x = direction.x * speed * delta * 60
		
		if 1 > distance_to_player_x and distance_to_player_x > -1:
			velocity.x = 0
			animation.play("idle", 3)
		else:
			animation.play("run", 2)
	
	velocity.y += gravity * delta * 60
	
	turn()
	detection_ray.target_position.x = detection_range * direction.x
	move_and_slide()


func turn():
	if direction.x < 1:
		animation.flip_h = false
	else:
		animation.flip_h = true


func _on_idle_timer_timeout() -> void:
	moving = 1
	direction.x = direction.x * -1
	idle_move_timer.start(idle_move_time)

func _on_idle_move_timeout() -> void:
	moving = 0
	idle_wait_timer.start(idle_wait_time)


func _on_cool_down_timeout() -> void:
	status = 0
