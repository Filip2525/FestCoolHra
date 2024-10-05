extends Node2D

@onready var animation = $Enemy/AnimatedSprite2D
@onready var enemy = $Enemy
@onready var idle_wait_timer = $Enemy/idle_timer
@onready var idle_move_timer = $Enemy/idle_move

var status = 0 #0 - idle, 1 - angry, 2 - dead
var moving = 0
var collision

var direction = Vector2(1, 0)
var velocity = 0
@export var speed = 40

@export var idle_move_time = 3
@export var idle_wait_time = 3

func _ready() -> void:
	idle_wait_timer.start()
	
func _physics_process(delta: float) -> void:
	collision = enemy.move_and_collide(direction * velocity * speed * delta)
	turn()
	
	if status == 0:
		if moving == 0:
			velocity = 0
			animation.play("idle")
		if moving == 1:
			velocity = 1
			animation.play("run")


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
