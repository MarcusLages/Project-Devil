extends Node

class_name InteractableManager

# TODO: Wrongfully used "get_node" instead of "find_node", change only if have time

## List of managed interactable items.
## IMPORTANT: refers to the parent item of the Interactable/Draggable node.
@export var interactable_items: Array[Node2D]

## If true, will find all the children nodes of this InteractableManager node
## that have an Interactable/Draggable node.
@export var detect_interactable_children: bool = true

@export var min_z_index: int = -10
@export var max_z_index: int = 10

# Lower index = front, higher index = back
var z_idx_stack: Array[Node2D]

func _ready() -> void:
    if detect_interactable_children:
        for child in get_children():
            if (
                child.get_node_or_null("Interactable") 
                and child not in interactable_items
            ):
                interactable_items.append(child)

        for child in interactable_items:
            z_idx_stack.push_back(child)

            var i_component: Interactable = child.get_node_or_null("Interactable")
            if i_component:
                i_component.hover_entered.connect(_on_child_hover_entered)
                i_component.hover_exited.connect(_on_child_hover_exited)
                
                var d_component: Draggable = child.get_node_or_null("Draggable")
                if d_component:
                    d_component.drag_ended.connect(_on_child_drag_ended)
                    d_component.state_changed.connect(_on_child_state_changed)


func _on_child_hover_entered(child: Area2D):
    for item in interactable_items:
        if item != child:
            var i_component: Interactable = item.get_node("Interactable")
            var d_component: Draggable = item.get_node_or_null("Draggable")

            i_component.disabled = true
            if d_component:
                d_component.disabled = true


func _on_child_hover_exited(child: Area2D):
    var d_component: Draggable = child.get_node_or_null("Draggable")
    if (
        not d_component 
        or d_component.disabled
        or d_component.state != Draggable.DRAGGABLE_STATE.DRAGGING
    ):
        for item in interactable_items:
            var i_component: Interactable = item.get_node("Interactable")
            d_component = item.get_node_or_null("Draggable")

            i_component.disabled = false
            if d_component:
                d_component.disabled = false

func _on_child_drag_ended(child: Area2D, _dropzone: DropZone, _drop_spot: SnappingSpot):
    var i_component: Interactable = child.get_node("Interactable")
    if not i_component.is_hovered:
        for item in interactable_items:
            i_component = item.get_node("Interactable")
            var d_component: Draggable = item.get_node("Draggable")

            i_component.disabled = false
            d_component.disabled = false


func _on_child_state_changed(area: Area2D, state: Draggable.DRAGGABLE_STATE):
    if state == Draggable.DRAGGABLE_STATE.IDLE:
        _push_front_z_index(area)


func _push_front_z_index(child: Area2D):
    z_idx_stack.erase(child)
    z_idx_stack.push_front(child)

    var z_idx: int = max_z_index
    for c in z_idx_stack:
        c.z_index = z_idx
        z_idx = clamp(z_idx - 1, min_z_index, max_z_index)


## Changes state of all the children interactables
func change_state(disable_interact: bool, disable_drag: bool):
    for item in interactable_items:
        var i_component: Interactable = item.get_node("Interactable")
        var d_component: Draggable = item.get_node_or_null("Draggable")

        i_component.disabled = disable_interact
        if d_component:
            d_component.disabled = disable_drag
