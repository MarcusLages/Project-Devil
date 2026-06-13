extends Node2D

class_name Page

signal next_page
signal prev_page


func _on_next_button_pressed() -> void:
    next_page.emit()


func _on_prev_button_pressed() -> void:
    prev_page.emit()
