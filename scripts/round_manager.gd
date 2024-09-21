extends Node

var score = 0

@onready var score_label = $ScoreLabel

func add_point(point: int):
	score += point
	score_label.text = str(score)
