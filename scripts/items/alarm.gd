extends Area2D


@export var min_ringing_time_sec: float = 50.

@export var max_ringing_time_sec: float = 120.

@export var clicking_interval_sec: float = 1.


var _rng = RandomNumberGenerator.new()
var _click: int = 0

var ringing: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    _start_alarm_timer()
    $ClickTimer.start(clicking_interval_sec)


func _on_interactable_interacted(_from: Area2D) -> void:
    if ringing:
        _start_alarm_timer()
        SoundManager.stop_sfx(SoundManager.SFX.ALARM)
        ringing = false


func _on_alarm_timer_timeout() -> void:
    ringing = true
    SoundManager.play_sfx(SoundManager.SFX.ALARM, true)


func _on_click_timer_timeout() -> void:
    _click += 1
    var sfx: SoundManager.SFX = (SoundManager.SFX.CLOCK_UP 
        if _click % 2 == 0 
        else SoundManager.SFX.CLOCK_DOWN)
    SoundManager.play_sfx(sfx)


func _start_alarm_timer():
    var sec: float = _rng.randf_range(min_ringing_time_sec, max_ringing_time_sec)
    $AlarmTimer.start(sec)
