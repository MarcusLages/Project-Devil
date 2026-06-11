extends Node

class_name Zoomable

# TODO: might have to add reference to Area2D
signal zoomed()
signal unzoomed()

@export var disabled: bool = false
## Cannot be null
@export var draggable: Draggable
@export var zoom_tag: DraggableType = DraggableType.new()

@export_category("Zoom objects")
## Cannot be null
@export var display_container: Node2D
@export var zoomed_display_container: Node2D
## Cannot be null, should already be a child node of the Area2D
@export var collision_object: CollisionShape2D
## Can be null, should already be a child node of the Area2D
@export var zoomed_collision_object: CollisionShape2D

var is_zoomed: bool = false
var _has_zoomed_collision: bool = true
var _collision_parent: Node

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

    assert(collision_object != null, "Must have a CollisionObject attached to the Area2D as a brother node to Zoomable.")
    
    if not zoomed_collision_object:
        _has_zoomed_collision = false
    else:
        _collision_parent = collision_object.get_parent()
        _collision_parent.remove_child.call_deferred(zoomed_collision_object)

    draggable.drag_ended.connect(_on_draggable_drag_ended)
    

func _on_draggable_drag_ended(_area: Area2D, dropzone: DropZone, _drop_spot: SnappingSpot):
    if (
        zoom_tag
        and zoomed_display_container
        and dropzone
    ):
        if _check_dropzone_drag_types(dropzone):
            if not is_zoomed:
                display_container.hide()
                zoomed_display_container.show()
                is_zoomed = true

                if _has_zoomed_collision:
                    _collision_parent.remove_child(collision_object)
                    _collision_parent.add_child(zoomed_collision_object)

                zoomed.emit()

        else:
            if is_zoomed:
                zoomed_display_container.hide()
                display_container.show()
                is_zoomed = false

                if _has_zoomed_collision:
                    _collision_parent.remove_child(zoomed_collision_object)
                    _collision_parent.add_child(collision_object)

                unzoomed.emit()


func _check_dropzone_drag_types(dropzone: DropZone):
    for types in dropzone.accepted_draggable_types:
        if types.id == zoom_tag.id:
            return true
    return false