extends CharacterBody2D
class_name Character

@onready var round_manager = get_tree().root.get_node("RoundPlay/RoundManager")

var MIN_DAMAGE = 1.0
var CAMP = 'NPC'	# can be 'Player' or 'Monster', characters belongs to different camp other than 'NPC' will damage each other

var INITIAL_HP = 20
var defense = 2
var atk = 10
var hp = INITIAL_HP

var kill_point = 10

func check_collide(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is Character and collider.CAMP != CAMP and CAMP != 'NPC':
			collider.take_damage(atk)

func take_damage(by_atk: float) -> bool:
	var damage = by_atk - defense
	if damage<MIN_DAMAGE:
		damage = MIN_DAMAGE
	hp -= damage
	if hp <= 0:
		die()
		round_manager.add_point(kill_point)
		return true
	return false

func die():
	queue_free()

func _physics_process(_delta: float) -> void:
	move_and_slide()
