extends Area2D

@export var speed: float = 500.0  # Speed of the bullet
@export var lifespan: float = 3.0

var timer: float = 0.0
var direction: Vector2

@onready var shoot_sound: AudioStreamPlayer2D = $shoot_sound

func _ready():
	# Start the bullet moving forward
	rotation = direction.angle()-3.1415926/2
	#direction = Vector2.UP.rotated(rotation)  # Rotate the right vector
	set_process(true)
	shoot_sound.play()

func _process(delta):
	position += direction * speed * delta  # Move the bullet
	
	timer += delta
	if timer > lifespan:
		queue_free()  # Remove the bullet after its lifespan
	 
var dealt_damages: int = 0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  # Reference to AnimatedSprite2D
# Connect the signal on the Area2D node to call _on_body_entered
const DAMAGES = [12,8,6,4]

func _on_body_entered(body: Node2D):
	if body is Monster:
		if dealt_damages == 0:
			animated_sprite.play("explosion")
			animated_sprite.connect("animation_finished",  _on_animation_finished)

		if dealt_damages < len(DAMAGES):
			body.take_damage(DAMAGES[dealt_damages])
		dealt_damages += 1


func _on_animation_finished(animation_name: String):
	if animation_name == "explosion":
		queue_free()  # Destroy the bullet after the animation finishes
