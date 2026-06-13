extends Button

@onready var sprite = $TextureRect

func _on_mouse_entered():
	sprite.modulate.a = 1.0

func _on_mouse_exited():
	sprite.modulate.a = 0.5
