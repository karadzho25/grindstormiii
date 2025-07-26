extends Node2D

var bulletScene = preload("res://scenes/bullet.tscn")
var spawnPointScene = preload("res://scenes/spawn_point.tscn")
var powerupScene = preload("res://scenes/power_up.tscn")

const nPlayers = 2

var isGameOver = false

var gameState
var windowWidth
var windowHeight

func _ready() -> void:
	windowWidth = get_viewport_rect().size[0]
	windowHeight = get_viewport_rect().size[1]
	gameState = GameState.new(2)
	
	init_spawn_points(20)
	
	for player in gameState.players:
		add_child(player.ship)
	
func _process(delta: float) -> void:
	if isGameOver:
		return
				
	for bullet in gameState.projectiles:
		bullet.inc_frames()
		if(bullet.get_alive_frames() >= bullet.get_max_frames()):
			gameState.projectiles.erase(bullet)
			bullet.queue_free()
		resolve_position(bullet, delta, bullet.speed)
	
	for player in gameState.players:
		player.health -= 1
		if player.health <= 0:
			player.die()
			end_game()
		resolve_regen(player)
		resolve_position(player.ship, delta, player.speed)
		player.playerInput.process_input()
		resolve_input(player)

func end_game():
	for spawner in gameState.spawners:
		spawner.timer.stop()

	for powerup in gameState.powerups:
		powerup.queue_free()
		
	gameState.powerups.clear()
	
	isGameOver = true

func init_spawn_points(amount : int):
	for i in range(amount):
		var spawner = spawnPointScene.instantiate()
		var xPos = randi_range(1, 9)*(windowWidth/10)
		var yPos = randi_range(1, 9)*(windowHeight/10)
		spawner.position = Vector2(xPos, yPos)
		spawner.connect("_on_spawn_powerup", Callable(func(): self.spawn_powerup(spawner)))
		gameState.spawners.append(spawner)
		add_child(spawner)

func spawn_powerup(spawner):
	var powerup = powerupScene.instantiate()
	powerup.position = spawner.position
	powerup.connect("_on_collect_powerup", Callable(func(): self._on_powerup_collected(powerup, spawner)))
	gameState.powerups.append(powerup)
	add_child(powerup)

func resolve_regen(player: Player):
	player.shield *= player.shieldRegenMultiplier
	player.shield += player.shieldRegenFlat
	player.shield = min(player.shield, player.maxShield)

func resolve_position(object, delta : float, speed):
	object.position += Vector2(cos(object.rotation), sin(object.rotation)) * speed * delta
	if(object.position.x < 0):
		object.position.x += windowWidth
	if(object.position.x > windowWidth):
		object.position.x -= windowWidth
	if(object.position.y < 0):
		object.position.y += windowHeight
	if(object.position.y > windowHeight):
		object.position.y -= windowHeight
		
func resolve_input(player):
	if player.playerInput.isShoot:
		shoot(player)
	if player.playerInput.isMoveLeft:
		rotate_ship(player, -player.rotation)
	if player.playerInput.isMoveRight:
		rotate_ship(player, player.rotation)
	if player.playerInput.isBoost:
		boost(player)
		
func boost(player):
	if player.shield > 0:
		player.on_shield_damaged(1)
		player.ship.position += Vector2(cos(player.ship.rotation), sin(player.ship.rotation)) * player.boostSpeed

func shoot(player):
		var bullet = bulletScene.instantiate()
		bullet.scale *= player.shotSize
		bullet.init(player)
		bullet.position = player.ship.position
		bullet.rotation = player.ship.rotation
		gameState.projectiles.append(bullet)
		bullet.connect("_on_projectile_hit", Callable(func(): self._on_projectile_hit(bullet)))
		add_child(bullet)

func rotate_ship(player, rotationDeg):
	player.ship.rotation += rotationDeg

func _on_projectile_hit(bullet : Bullet):
	gameState.projectiles.erase(bullet)
	bullet.queue_free()
	
func _on_powerup_collected(powerup: PowerUp, spawnPoint):
	gameState.powerups.erase(powerup)
	spawnPoint.on_powerup_collected()
	powerup.queue_free()
