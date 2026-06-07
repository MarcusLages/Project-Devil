extends Area2D

@export var min_ringing_time_in_seconds: float = 50.

@export var max_ringing_time_in_seconds: float = 120.

@export var clicking_interval_in_seconds: float = 1.

var ringing: bool = false
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    _start_alarm_timer()
    $ClickTimer.start(clicking_interval_in_seconds)


func _on_interactable_interacted(_from: Area2D) -> void:
    if ringing:
        _start_alarm_timer()
        ringing = false


func _on_alarm_timer_timeout() -> void:
    ringing = true
    # TODO: play alarm sound


func _on_click_timer_timeout() -> void:
    # TODO: play click sound
    pass # Replace with function body.


func _start_alarm_timer():
    var sec: float = rng.randf_range(min_ringing_time_in_seconds, max_ringing_time_in_seconds)
    $AlarmTimer.start(sec)
