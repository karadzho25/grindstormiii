extends CharacterBody2D

class_name Ship

@onready var sprite = $Sprite2D

signal _on_ship_damaged(amount : int)
signal _on_powerup_collected(type : PowerUp.PowerUpType)

func take_damage(amount: int):
	emit_signal("_on_ship_damaged", amount)
	
func collect_powerup(type : PowerUp.PowerUpType):
	emit_signal("_on_powerup_collected", type)

func die():
	sprite.set_modulate(Color(1,0,0,1))
