extends Area2D
class_name Dispenser

signal requested()

@export var button_on : Texture
@export var button_off : Texture

@onready var sprite = $Content/Sprite2D
@onready var button = $Advance

var on = true


func set_button_on(is_on : bool) -> void:
	sprite.texture = button_on if is_on else button_off
	button.disabled = !is_on
	if is_on:
		$Timer.start()
	else:
		$Timer.stop()


func _on_advance_button_up():
	$SFX.play()
	requested.emit()


func _on_timer_timeout():
	if on:
		if sprite.texture == button_on:
			sprite.texture = button_off
		else:
			sprite.texture = button_on


func _on_advance_mouse_entered():
	pass # Replace with function body.


func _on_advance_mouse_exited():
	pass # Replace with function body.
