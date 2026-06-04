extends Node

## InteractableManager representing items that will be staying between 
## different record folders.
@export var fixed_items_scene: PackedScene = null

## List of InteractableManagers representing record folders.
## IMPORTANT: Order matters.
@export var record_scenes: Array[PackedScene]

## Scene container which every item folder will be a child of when instantiated.
## If null, the parent will be checked. If there's no parent, self will be used.
@export var items_container: Node = null


var _curr_record: int = 0

var fixed_items_manager: InteractableManager = null
var record_managers: Array[InteractableManager] = []


func _ready() -> void:
    if not items_container:
        items_container = get_parent()
        if not items_container:
            items_container = self

    fixed_items_manager = fixed_items_scene.instantiate() as InteractableManager
    items_container.add_child(fixed_items_manager)

    for rec_scene in record_scenes:
        var rec := rec_scene.instantiate() as InteractableManager
        record_managers.append(rec)


func clean_scene():
    for item in items_container.get_children():
        if item != fixed_items_manager:
            item.queue_free()


func load_record(rec_idx: int) -> Error:
    if rec_idx >= record_managers.size():
        return ERR_DOES_NOT_EXIST

    _curr_record = rec_idx
    clean_scene()
    for rec in record_managers:
        items_container.add_child(rec)

    return OK