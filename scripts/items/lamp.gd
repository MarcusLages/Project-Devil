extends Area2D

@export_category("Basic Settings")
## Just initial state
@export var lights_on: bool = true
## Disables changing state
@export var disabled: bool = false
## If left null, will search for a LightMarker child node
@export var light_marker: Marker2D = null

@export_category("Turned On Setting")
@export var light_radius_on: float = 0.75
@export var darkness_alpha_on: float = 0.65
@export var light_intensity_on: float = 1.
## If true, the light will be circular.
## If ffalse, the light will be rectangular with the aspect ratio of the viewport
@export var circular_light_on: bool = false

@export_category("Turned Off Setting")
@export var light_radius_off: float = 0.2
@export var darkness_alpha_off: float = 0.65
@export var light_intensity_off: float = 0.65
## If true, the light will be circular.
## If ffalse, the light will be rectangular with the aspect ratio of the viewport
@export var circular_light_off: bool = true

@export_category("Timers")
@export var min_dark_time_sec: float = 50.
@export var max_dark_time_sec: float = 120.

@onready var shader: ShaderMaterial = $"CanvasLayer/ColorRect".material

var _rng = RandomNumberGenerator.new()

func _ready() -> void:
    if not light_marker:
        light_marker = get_node_or_null("LightMarker")

    assert(light_marker != null, "Must have a LightMarker (Marker2D) as a child node of Lamp")
    
    _change_shaders(lights_on)


func _process(_delta: float) -> void:
    var light_screen_pos = get_viewport().get_canvas_transform() * light_marker.global_position
    var normalized_pos = light_screen_pos / get_viewport_rect().size
    shader.set_shader_parameter("light_marker", normalized_pos)


func turn_on():
    if not disabled:
        lights_on = true
        _change_shaders(lights_on)


func turn_off():
    if not disabled:
        lights_on = false
        _change_shaders(lights_on)


func _change_shaders(are_lights_on: bool):
    if are_lights_on:
        shader.set_shader_parameter("light_radius", light_radius_on)
        shader.set_shader_parameter("darkness_alpha", darkness_alpha_on)
        shader.set_shader_parameter("circular_light", circular_light_on)
        shader.set_shader_parameter("light_intensity", light_intensity_on)
    else:
        shader.set_shader_parameter("light_radius", light_radius_off)
        shader.set_shader_parameter("darkness_alpha", darkness_alpha_off)
        shader.set_shader_parameter("circular_light", circular_light_off)
        shader.set_shader_parameter("light_intensity", light_intensity_off)


func _on_interactable_interacted(_from: Area2D):
    if disabled:
        return
    
    print("lights_on", lights_on)
    if lights_on:
        turn_off()
    else:
        turn_on()