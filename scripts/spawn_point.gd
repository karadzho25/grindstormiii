extends Node2D

class_name Spawner

@onready var timer = $Timer

signal _on_spawn_powerup

func _ready() -> void:
	timer.wait_time = randi_range(4, 10)
	spawn_powerup()

func spawn_powerup():
	timer.stop()
	emit_signal("_on_spawn_powerup")

func _on_timer_timeout() -> void:
	spawn_powerup()

func on_powerup_collected():
	timer.start() 
