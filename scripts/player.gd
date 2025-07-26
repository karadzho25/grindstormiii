extends Node

class_name Player

var playerInput = null
var ship : Ship = null
var maxHealth = 100
var maxShield = 100

var health = 1000
var shield = 100
var rotation = 0.03
var boostSpeed = 3
var bulletSpeed = 1200
var bulletDuration = 100
var shotSize = 1
var shieldRegenFlat = 1
var shieldRegenMultiplier = 1.002
var attackDamage = 1
var speed = 400

var powerups = []

func _init(i_ship : Ship, i_playerInput : PlayerInput):
	self.ship = i_ship
	ship.connect("_on_ship_damaged", self._on_player_hit)
	ship.connect("_on_powerup_collected", self.on_powerup_collected)
	self.playerInput = i_playerInput

func _on_player_hit(amount : int):
	var damage = amount
	if shield > 0:
		damage = on_shield_damaged(amount)
	health -= damage
	
func on_shield_damaged(amount : int) -> int:
	shield -= amount
	if shield < 0:
		var curr = shield
		shield = 0
		return abs(curr)
		
	return 0

func on_powerup_collected(type : PowerUp.PowerUpType):
	health += 5
	powerups.append(type)
	
func die():
	ship.die()
