extends Node

class_name PlayerInput
	
var moveLeft = ""
var moveRight = ""
var shoot = ""
var boost = ""

var isMoveLeft = false
var isMoveRight = false
var isShoot = false 
var isBoost = false
	
func _init(i_moveLeft : String, i_moveRight : String, i_shoot : String, i_boost : String):
	self.moveLeft = i_moveLeft
	self.moveRight = i_moveRight
	self.shoot = i_shoot
	self.boost = i_boost

func process_input():
	isMoveLeft = Input.is_action_pressed(moveLeft)
	isMoveRight = Input.is_action_pressed(moveRight)
	isShoot = Input.is_action_just_pressed(shoot)
	isBoost = Input.is_action_just_pressed(boost)
