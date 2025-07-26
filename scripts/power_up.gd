extends Area2D

class_name PowerUp

enum PowerUpType
{
	HP,
	Shield,
	Boost,
	BulletSize,
	Rotation,
	ShieldRegen,
	BulletSpeed
}

var type : PowerUpType = PowerUpType.HP

signal _on_collect_powerup

func init(i_type):
	self.type = i_type

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		body.collect_powerup(self.type)
		emit_signal("_on_collect_powerup")
