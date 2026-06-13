extends AudioStreamPlayer


@export var frequency = 100.0
@export var variance = 40.0

@onready var timer = $Timer


func _ready():
	timer.start(frequency + randf_range(-variance, variance))


func _on_timer_timeout():
	timer.start(frequency + randf_range(-variance, variance))
	play()
