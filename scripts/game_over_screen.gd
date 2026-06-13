extends "res://scripts/text_screen.gd"

@onready var door_knock = $DoorKnock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: add sounds and stuff
	super._ready()


func animate_lines() -> bool:
	await super()
	door_knock.play()
	for line in container.get_children():
		var tween = create_tween()
		tween.tween_property(line, 'modulate', Color(1, 1, 1, 0), 1.0)
	
	await door_knock.finished
	get_tree().quit()
	return true
