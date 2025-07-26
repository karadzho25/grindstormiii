extends Area2D

class_name Bullet

var player : Player

var maxFrames =  300
var aliveFrames = 0
var speed = 200

signal _on_projectile_hit

func init(i_player : Player):
	self.player = i_player
	self.maxFrames = i_player.bulletDuration
	self.speed = i_player.bulletSpeed
	
func inc_frames():
	aliveFrames += 1

func get_max_frames():
	return maxFrames
	
func get_alive_frames():
	return aliveFrames
	
func _on_RigidBody2D_body_entered(body: Node) -> void:
	if(player != null && body == player.ship):
		return
	
	if body.is_in_group("Players"):
		body.take_damage(player.attackDamage)
		emit_signal("_on_projectile_hit")
