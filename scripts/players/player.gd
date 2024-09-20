extends Character
class_name Player

func _ready() -> void:
	CAMP = 'Player'
	INITIAL_HP = 100

# Bullet scene to instance
@export var bullet_scene: PackedScene = preload("res://scenes/players/bullet.tscn")
# Cooldown duration in milliseconds
var shoot_cooldown: int = 500
var last_shoot_time: int = 0


func find_target_monster():
	# Find the lowest monster
	var monsters = get_tree().get_nodes_in_group("monsters")
	var target_monster = false
	var min_distance = INF

	for monster in monsters:
		var distance = position.distance_to(monster.position)
		if distance < min_distance:
			min_distance = distance
			target_monster = monster
	return target_monster
	
func shoot_to(monster: Monster):
	# Instance the bullet and set its position
	var bullet = bullet_scene.instantiate()
	bullet.position = position  # Starting position at player
	
	# Calculate the direction to target monster considering its velocity
	var bullet_speed = bullet.speed  # Assuming the bullet has a speed property
	var monster_velocity = monster.velocity  # Assuming monster has a velocity attribute
	var time_to_reach = position.distance_to(monster.position) / bullet_speed  # Time for bullet to reach the monster

	# Predict the monster's future position
	var predicted_position = monster.position + (monster_velocity * time_to_reach)

	# Calculate the direction toward the predicted position
	var direction = (predicted_position - position).normalized()
	
	# Set the bullet's rotation
	bullet.direction = direction
	
	get_tree().current_scene.add_child(bullet)  # Add the bullet to the scene
	
	# Update last shoot time
	last_shoot_time = Time.get_ticks_msec()

# Function to shoot bullets
func shoot():
	# Check if the cooldown is over
	if (Time.get_ticks_msec() - last_shoot_time) < shoot_cooldown:
		return

	var target_monster = find_target_monster()
	if target_monster:
		shoot_to(target_monster)

# Call the shoot function when needed, such as on input event
#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		shoot()
func _process(delta: float) -> void:
	shoot()
