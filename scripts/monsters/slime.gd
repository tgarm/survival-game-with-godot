extends Monster

const SPEED = 10.0

func _ready() -> void:
	velocity.y = SPEED
	hp = 20
