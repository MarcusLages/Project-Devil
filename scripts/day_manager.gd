extends Node

class_name DayManager

## InteractableManager representing items that will be staying between 
## different record folders.
@export var fixed_items_scene: PackedScene = null

## List of InteractableManagers representing record folders.
## IMPORTANT: Order matters.
@export var record_scenes: Array[PackedScene]

## Scene container which every item folder will be a child of when instantiated.
## If null, the parent will be checked. If there's no parent, self will be used.
@export var items_container: Node = null

var _curr_record: int = -1

var fixed_items_manager: InteractableManager = null
var record_managers: Array[InteractableManager] = []


func _ready() -> void:
    if not items_container:
        items_container = get_parent()
        if not items_container:
            items_container = self

    if fixed_items_scene:
        fixed_items_manager = fixed_items_scene.instantiate() as InteractableManager
        items_container.add_child(fixed_items_manager)

    for rec_scene in record_scenes:
        var rec := rec_scene.instantiate() as InteractableManager
        record_managers.append(rec)


func clean_record_scene(clean_fixed: bool = false):
    if _curr_record < 0 or _curr_record >= record_managers.size():
        for manager in record_managers:
            items_container.remove_child(manager)
    else:
        items_container.remove_child(record_managers[_curr_record])
    
    if fixed_items_manager:
        # This is just used to make sure all items are enabled again
        fixed_items_manager.change_state(false, false)

        if clean_fixed:
            items_container.remove_child(fixed_items_manager)


func load_record(rec_idx: int) -> Error:
    clean_record_scene()
    
    if rec_idx < 0 or rec_idx >= record_managers.size():
        return ERR_DOES_NOT_EXIST

    _curr_record = rec_idx
    items_container.add_child(record_managers[rec_idx])

    return OK


func next_record() -> Error:
    _curr_record += 1
    return load_record(_curr_record)