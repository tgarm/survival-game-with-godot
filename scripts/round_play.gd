extends Node2D

@export var player_scene: PackedScene = preload("res://scenes/players/player.tscn")
var players: Array = []  # Array to hold player instances
var max_players: int = 4  # Maximum number of players
var spawn_timer: Timer  # Timer to spawn new players

func _ready():
	# Instantiate the first player at the start
	spawn_player()
	
	# Set up a timer to spawn players every 60 seconds
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 60.0
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", _on_spawn_timer_timeout)
	add_child(spawn_timer)  # Add the timer to the scene tree
	spawn_timer.start()  # Start the timer

func _on_spawn_timer_timeout():
	if players.size() < max_players:
		spawn_player()  # Spawn a new player if under the max limit

func spawn_player():
	var player:Player = player_scene.instantiate()  # Create a new player instance
	players.append(player)  # Add it to the players array
	add_child(player)  # Add the player to the scene

	# Recalculate positions for all players
	arrange_players()

var player_size: Vector2 = Vector2(64, 64)  # Fixed size for players
func arrange_players():
	var screen_size = get_viewport().size  # Get the screen size
	var spacing = screen_size.x
	if players.size()>1:
		spacing = screen_size.x/players.size()
		if spacing < 0:
			spacing = 0
	
	var x = spacing/2
	var y = screen_size.y - player_size.y / 2  # Position players at the bottom of the screen
	
	# Set positions for players
	for i in range(players.size()):
		var player = players[i]
		player.position = Vector2(x, y)
		x += spacing
