extends Node2D

signal next_page


func _on_button_pressed() -> void:
    next_page.emit()
