extends Area2D

class_name Stampable

signal stamped(correct: bool)

## DropZone responsible to take care of the stamp logic
@export var drop_zone: DropZone = null

## Correct stamp type
@export var correct_stamp: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if not drop_zone:
        drop_zone = get_node_or_null("../DropZone")

    assert(drop_zone != null, "Must have a DropZone associated or as a brother node to the SceneManager.")
    drop_zone.drop_applied.connect(_on_drop_zone_drop_applied)


func _on_drop_zone_drop_applied(_zone: DropZone, stamp_area: Area2D, _plan: DropPlan):
    if stamp_area is not Stamp:
        return

    var stamp := stamp_area as Stamp
    stamped.emit(stamp.stamp_name == correct_stamp)