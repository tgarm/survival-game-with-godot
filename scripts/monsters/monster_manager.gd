extends Node2D

class_name MonsterManager

# Predefined spawn area (replace with your specific area size)
@export var spawn_area_size: Vector2 = Vector2(800, 100)
@export var spawn_area_center: Vector2 = Vector2(400, 50)

# List of possible monsters with their associated probabilities
# Example: [{monster: Goblin, probability: 0.7}, {monster: SomeOtherMonster, probability: 0.3}]
@export var monsters: Array = [{ 'monster': preload("res://scenes/monsters/goblin_fire.tscn"), 'probability': 0.1}, 
		{ 'monster': preload("res://scenes/monsters/slime.tscn"), 'probability': 0.9 }]
@export var spawn_count: int = 2000  # Number of monsters to spawn

# Time between each monster spawn (in seconds)
@export var spawn_interval: float = 1.0

var spawned_probability_interval: float = 0.02  # Amount to increase the probability each time
var max_probability: float = 1.0  # Maximum probability
var probability_countdown = 1

# Internal variables
var spawned_count: int = 0
var timer: Timer

func _ready():
	randomize()

	# Initialize and start the timer
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = false  # Repeat the timer until all monsters are spawned
	timer.timeout.connect(self._on_timer_timeout)
	add_child(timer)
	timer.start()

# Spawn a monster each time the timer times out
func _on_timer_timeout():
	probability_countdown -= 1
	if probability_countdown <= 0:
		probability_countdown = 10
		_update_monster_probability()
	if spawned_count < spawn_count:
		var monster_type = get_random_monster_type()
		if monster_type != null:
			var monster_instance = monster_type.instantiate()
			var spawn_position = get_random_spawn_position()
			monster_instance.position = spawn_position
			add_child(monster_instance)
			spawned_count += 1
	else:
		# Stop the timer when all monsters have been spawned
		timer.stop()

# Function to update the probability
func _update_monster_probability():
	if monsters.size() > 0:
		var current_probability = monsters[0]['probability']
		# Increase the probability
		current_probability += spawned_probability_interval
		
		# Clamp the value to not exceed max_probability
		if current_probability > max_probability:
			current_probability = max_probability
			
		# Update the probability in the array
		monsters[0]['probability'] = current_probability
		
		print("Updated probability of first monster: ", current_probability)
		
# Get a random spawn position within the area
func get_random_spawn_position() -> Vector2:
	var x = spawn_area_center.x + randf_range(- spawn_area_size.x / 2, spawn_area_size.x / 2)
	var y = spawn_area_center.y + randf_range(-spawn_area_size.y / 2, spawn_area_size.y / 2)
	return Vector2(x, y)

# Get a random monster type based on probabilities
func get_random_monster_type() -> PackedScene:
	var total_probability = 0
	for monster_data in monsters:
		total_probability += monster_data.probability

	var random_value = randf() * total_probability
	var accumulated_probability = 0
	for monster_data in monsters:
		accumulated_probability += monster_data.probability
		if random_value <= accumulated_probability:
			return monster_data.monster

	return null
