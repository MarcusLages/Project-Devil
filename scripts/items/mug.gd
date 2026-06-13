extends Area2D


@export_category("Basic Settings")
## Just initial state
@export var is_sleepy: bool = false
## Disables changing state
@export var disabled: bool = false

@export_category("Blur Settings")
## Percentage of the screen considered during the blur
@export var blur_intensity: float = 0.275
@export var blur_transition_speed_sec: float = 1.
@export var gaussian_blur_center: float = 0.25
@export var gaussian_blur_edge: float = 0.125
@export var gaussian_blur_corner: float = 0.0625

@export_category("Timers")
@export var min_sleep_time_sec: float = 50.
@export var max_sleep_time_sec: float = 120.

@export_category("Sprites")
@export var empty_texture : Texture
@export var full_texture : Texture

@onready var color_rect: ColorRect = $"CanvasLayer/ColorRect"
@onready var shader_material: ShaderMaterial = $"CanvasLayer/ColorRect".material
@onready var sleep_timer: Timer = $SleepTimer
@onready var sprite = $Node2D/Sprite2D

const MAX_BLUR: float = 5.
const MIN_BLUR: float = 0.

var curr_blur: float = 0.
var blur_tween: Tween = null

var _rng = RandomNumberGenerator.new()


func _ready() -> void:
	shader_material.set_shader_parameter("gaussian_blur_center", gaussian_blur_center)
	shader_material.set_shader_parameter("gaussian_blur_edge", gaussian_blur_edge)
	shader_material.set_shader_parameter("gaussian_blur_corner", gaussian_blur_corner)
	if is_sleepy:
		enable_sleepiness()
	else:
		_start_sleep_timer()

func _process(_delta: float) -> void:
	shader_material.set_shader_parameter("blur_intensity", curr_blur)


func _start_sleep_timer():
	var sec: float = _rng.randf_range(min_sleep_time_sec, max_sleep_time_sec)
	sleep_timer.start(sec)


func _on_interactable_interacted(_from: Area2D):
	if is_sleepy:
		disable_sleepiness()


func _on_sleep_timer_timeout():
	if not is_sleepy:
		enable_sleepiness()


func enable_sleepiness():
	if disabled:
		return
	
	sprite.texture = full_texture
	is_sleepy = true
	color_rect.visible = true

	if blur_tween:
		blur_tween.kill()
	blur_tween = create_tween()
	blur_tween.set_trans(Tween.TRANS_QUAD)
	blur_tween.set_ease(Tween.EASE_IN)
	blur_tween.tween_property(
		self, 
		"curr_blur",
		clamp(blur_intensity, MIN_BLUR, MAX_BLUR), 
		blur_transition_speed_sec
	)


func disable_sleepiness():
	if disabled:
		return
	
	sprite.texture = empty_texture
	is_sleepy = false
	SoundManager.play_sfx(SoundManager.SFX.COFFEE_SIP)
	
	if blur_tween:
		blur_tween.kill()
	blur_tween = create_tween()
	blur_tween.set_trans(Tween.TRANS_QUAD)
	blur_tween.set_ease(Tween.EASE_OUT)
	blur_tween.tween_property(self, 
		"curr_blur",
		MIN_BLUR,
		blur_transition_speed_sec
	)
	blur_tween.tween_callback(
		func(): color_rect.visible = false
	)
