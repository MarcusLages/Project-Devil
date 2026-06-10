extends Node

class_name Zoomable

signal zoomed(from: Area2D)
signal unzoomed(from: Area2D)

@export var disabled: bool = false
## Cannot be null
@export var draggable: Draggable
@export var zoom_tag := DraggableType.new()

@export_category("Zoom objects")
## Cannot be null
@export var display_container: Node2D
@export var zoomed_display_container: Node2D

var _is_zoomed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if not draggable:
        draggable = get_node_or_null("../Draggable")
        if not draggable:
            draggable = get_node_or_null("Draggable")
    assert(draggable != null, "Must have a Draggable associated or as a child/brother node to Zoomable.")

    if not display_container:
        display_container = get_node_or_null("../Container")
        if not display_container:
            display_container = get_node_or_null("Container")
    assert(draggable != null, "Must have a Node2D display container associated or as a child/brother node to Zoomable.")

    if not zoomed_display_container:
        zoomed_display_container = get_node_or_null("../ZoomedContainer")
        if not zoomed_display_container:
            zoomed_display_container = get_node_or_null("ZoomedContainer")

    if zoomed_display_container:
        zoomed_display_container.hide()

    # TODO: check CollisionShape2D too

    draggable.drag_ended.connect(_on_draggable_drag_ended)
    

func _on_draggable_drag_ended(_area: Area2D, dropzone: DropZone, _drop_spot: SnappingSpot):
    if (
        zoom_tag 
        and zoomed_display_container
        and zoom_tag in dropzone.accepted_draggable_types
    ):
        if not _is_zoomed:
            display_container.hide()
            zoomed_display_container.show()
            _is_zoomed = true
        else:
            zoomed_display_container.hide()
            display_container.show()
            _is_zoomed = false
