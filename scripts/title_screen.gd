extends Control

@export_category("Text Settings")
@export_multiline var opening_line: String
@export var title_font: Font = preload("res://assets/font/ELEGANT TYPEWRITER Regular.ttf")
@export var font_size: int = 20

@export_category("Transition Settings")
@export var fade_in_duration_sec: float = 1.
@export var line_wait_sec: float = 2.

@export_category("Extra Settings")
@export var change_to_scene: PackedScene

@onready var container = $VBoxContainer

var lines: PackedStringArray

func _ready() -> void:
    lines = opening_line.split("\\")
    animate_lines()

func animate_lines():
    var tween: Tween
    for line in lines:
        var label = Label.new()
        label.text = line
        label.modulate.a = 0
        label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        label.add_theme_font_override("font", title_font)
        label.add_theme_font_size_override("font_size", font_size)
        container.add_child(label)

        tween = create_tween()
        tween.set_trans(Tween.TRANS_LINEAR)
        tween.tween_property(label, "modulate:a", 1., fade_in_duration_sec)
        await tween.finished
        await get_tree().create_timer(line_wait_sec).timeout
    
    # After all lines, fade out
    tween = create_tween()
    tween.tween_property(container, "modulate:a", 0., line_wait_sec)
    await tween.finished
    get_tree().change_scene_to_packed(change_to_scene)
