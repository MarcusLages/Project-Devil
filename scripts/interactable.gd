extends Node

signal interacted

## Value for scale for when the item is hovered
@export var hover_zoom_scale := Vector2(1.25, 1.25)

var std_a2d_scale: Vector2 = Vector2(1, 1) # Reevaluated at ready()

var a2d: Area2D = null
var drag: Draggable = null

func _ready() -> void:
    # Find A2D
    var a: Area2D = null
    if get_parent() is Area2D:
        a = get_parent() as Area2D
    else:
        var candidate := $"../Area2D"
        if candidate:
            a = candidate

    drag = $"../Draggable"
    a2d = a

    assert(a != null, "Interactable node '%s' must be linked to an Area2D (brother, or parent)" % name)

    std_a2d_scale = a2d.scale
    a2d.mouse_entered.connect(_on_mouse_entered)
    a2d.mouse_exited.connect(_on_mouse_exited)

    if drag:
        drag.drag_ended.connect(_on_draggable_drag_ended)

func _on_mouse_entered() -> void:
    if drag.state == drag.DRAGGABLE_STATE.IDLE:
        a2d.scale = hover_zoom_scale

        if Input.is_action_just_pressed("mouse_interact"):
            interacted.emit()


func _on_mouse_exited() -> void:
    if drag.state == drag.DRAGGABLE_STATE.IDLE:
        a2d.scale = std_a2d_scale


func _on_draggable_drag_ended(_area: Area2D, _drop_spot: SnappingSpot) -> void:
    a2d.scale = std_a2d_scale
