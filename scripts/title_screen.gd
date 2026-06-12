extends Control

@export_multiline var opening_line: String
@export var fade_in_duration_sec: float = 1.
@export var line_wait_sec: float = 2.
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
