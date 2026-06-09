extends Node

class_name SceneManager

## DayManagers responsible for going through records throughout the day
@export var day_manager_scenes: Array[PackedScene]

## Where the DayManagers and other managers will be added, created and moved to as children nodes.
## If null, parent will be used. If no parent, self will be used.
@export var manager_container: Node

## Scene container which every item folder will be a child of when instantiated.
## If null, each DayManager will use their own
@export var items_container: Node

var day_managers: Array[DayManager]
var has_items_container: bool = false

var _curr_day: int = -1

func _enter_tree() -> void:
    get_tree().node_added.connect(_on_node_added)
    get_tree().node_removed.connect(_on_node_removed)

func _ready() -> void:
    # Load containers and scenes
    if not manager_container:
        manager_container = get_parent() if get_parent() else self

    if not day_manager_scenes or day_manager_scenes.is_empty():
        var dm1: DayManager = get_node_or_null("../DayManager")
        if dm1:
            day_managers.append(dm1)
        else:
            dm1 = get_node_or_null("DayManager")
            if dm1:
                day_managers.append(dm1)
        if dm1:
            var dm1_parent: Node = dm1.get_parent()
            dm1_parent.remove_child(dm1)
    else:
        for dm_scene in day_manager_scenes:
            var dm: DayManager = dm_scene.instantiate() as DayManager
            day_managers.append(dm)

    assert(day_managers, "Must have DayManagers associated or as brother nodes to the SceneManager.")

    # Leaving all the items_containers as the same for now
    # Have different ones only if necessary
    if not items_container:
        has_items_container = true

    # TODO: leave it only for testing
    next_day.call_deferred()


func load_day(day: int) -> Error:
    if day < 0 or day >= day_managers.size():
        return ERR_DOES_NOT_EXIST

    if _curr_day >= 0 and _curr_day < day_managers.size():
        manager_container.remove_child(day_managers[_curr_day])
    manager_container.add_child(day_managers[day])

    if has_items_container:
        day_managers[day].change_items_container(items_container)
    else:
        items_container = day_managers[day].items_container

    # TODO: load next record for testing too
    day_managers[day].next_record()
    _curr_day = day
    return OK


func next_day() -> Error:
    return load_day(_curr_day + 1)


func _on_node_added(node: Node):
    if node is Stampable:
        (node as Stampable).stamped.connect(_on_stampable_stamped)


func _on_node_removed(node: Node):
    if node is Stampable:
        (node as Stampable).stamped.disconnect(_on_stampable_stamped)


func _on_stampable_stamped(correct: bool): # TODO: handle stamp being correct or not
    if correct:
        print("Correct stamp")
    else:
        GameManager._lives -= 1
        print("Wrong stamp")

    if day_managers[_curr_day].next_record() == OK: # TODO: handle last record
        print("Next record")
    else:
        print("Last record already")
