extends Area2D

## ! Using Drag and Drop plugin, but it might need adjustments later

signal interacted

@onready var def_size: Vector2 = self.scale

var HOVER_ZOOM_SIZE := Vector2(1.25, 1.25)

func _on_mouse_entered() -> void:
    if $Draggable.state == $Draggable.DRAGGABLE_STATE.IDLE:
        self.scale = HOVER_ZOOM_SIZE

        if Input.is_action_just_pressed("mouse_interact"):
            interacted.emit()


func _on_mouse_exited() -> void:
    if $Draggable.state == $Draggable.DRAGGABLE_STATE.IDLE:
        self.scale = def_size


func _on_draggable_drag_ended(_area: Area2D, _drop_spot: SnappingSpot) -> void:
    self.scale = def_size
