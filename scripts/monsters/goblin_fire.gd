extends Monster

const SPEED = 30.0

func _ready() -> void:
	velocity.y = SPEED
	hp = 100
