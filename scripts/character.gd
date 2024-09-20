extends CharacterBody2D
class_name Character

var MIN_DAMAGE = 1.0

var CAMP = 'NPC'	# can be 'Player' or 'Monster', characters belongs to different camp other than 'NPC' will damage each other

var INITIAL_HP = 20
var defense = 2
var atk = 10
var hp = INITIAL_HP

func check_collide(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		var other_camp = collider.CAMP
		if collider is Character and collider.CAMP != CAMP and CAMP != 'NPC':
			collider.take_damage(atk)

func take_damage(atk: float) -> bool:
	var damage = atk - defense
	if damage<MIN_DAMAGE:
		damage = MIN_DAMAGE
	hp -= damage
	if hp <= 0:
		die()
		return true
	return false

func die():
	queue_free()

func _physics_process(delta: float) -> void:
	move_and_slide()
