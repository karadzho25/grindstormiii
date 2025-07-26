extends Node

class_name GameState

var shipScene = preload("res://scenes/ship.tscn")

var players = []
var projectiles = []
var powerups = []
var spawners = []

func _init(_nPlayers : int):
	var ship1 = shipScene.instantiate()
	var player1Input = PlayerInput.new("move_left_p1", "move_right_p1", "shoot_p1", "boost_p1")
	var player1 = Player.new(ship1, player1Input)
	player1.ship.position = Vector2(100, 100)
	players.append(player1)
	var ship2 = shipScene.instantiate()
	var player2Input = PlayerInput.new("move_left_p2", "move_right_p2", "shoot_p2", "boost_p2")
	var player2 = Player.new(ship2, player2Input)
	player2.ship.position = Vector2(200, 100)
	players.append(player2)
	
