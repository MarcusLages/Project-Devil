extends Node

signal interacted(from: Area2D)
signal hover_entered(from: Area2D)
signal hover_exited(from: Area2D)

## Value for scale for when the item is hovered
@export var hover_zoom_scale := Vector2(1.25, 1.25)

## Disable hovering and interacting with item.
## IMPORTANT: if disabled through code while before mouse exit, doesn't 
## guarantee that the item will return to the same size
@export var disabled: bool = false

var std_a2d_scale: Vector2 = Vector2(1, 1) # Constant-like reevaluated at ready()

var a2d: Area2D = null
var drag: Draggable = null
var is_hovered: bool = false

func _ready() -> void:
    # Find A2D
    var a: Area2D = null
    if get_parent() is Area2D:
        a = get_parent() as Area2D
    else:
        var candidate := get_node_or_null("../Area2D")
        if candidate:
            a = candidate

    drag = get_node_or_null("../Draggable")
    a2d = a

    assert(a != null, "Interactable node '%s' must be linked to an Area2D (brother, or parent)" % name)

    std_a2d_scale = a2d.scale
    a2d.mouse_entered.connect(_on_mouse_entered)
    a2d.mouse_exited.connect(_on_mouse_exited)

    if drag:
        drag.drag_ended.connect(_on_draggable_drag_ended)

func _on_mouse_entered() -> void:
    if disabled:
        return
        
    is_hovered = true
    a2d.scale = hover_zoom_scale

    hover_entered.emit(a2d)
    if Input.is_action_just_pressed("mouse_interact"):
        interacted.emit(a2d)


func _on_mouse_exited() -> void:
    if disabled:
        return

    is_hovered = false
    hover_exited.emit(a2d)

    if drag == null or drag.state == drag.DRAGGABLE_STATE.IDLE:
        a2d.scale = std_a2d_scale
        return


func _on_draggable_drag_ended(_area: Area2D, _drop_spot: SnappingSpot) -> void:
    if not is_hovered:
        a2d.scale = std_a2d_scale
