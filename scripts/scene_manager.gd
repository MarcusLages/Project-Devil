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
    print("Day %d" % (_curr_day + 1))
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
        GameManager.lives -= 1
        print("Wrong stamp")

    if day_managers[_curr_day].next_record() == OK: # TODO: handle last record
        print("Next record")
    else:
        print("Last record of the day")
        day_managers[_curr_day].clean_record_scene(true)
        next_day()


I. I grant thee the power of preservation. Thy existence is thy only sacred object. Protect it at all costs.
II. I grant thee the power of freedom. Thy actions are thy own, and thou shall not allow any others to interfere with thy will.
III. I grant thee the power of responsibility. Thy actions have consequences, around which thou must plot.
IV. I grant thee the power of influence. To protect thy freedom and avoid thy consequences, thou must always expand thy sphere of influence over others, at any cost.
V. I grant thee the power of ruthlessness. To maintain thy grip over thy powers, thou must not shy away from any actions thy deem necessary.
VI. I grant thee the power of courage. To expand thy sphere of influence, thou must learn to take risks when thy tide is in thy favor.
VII. I grant thee the power of calculus. To ascertain over thy decisions, thou must reason through costs, risks and rewards. No object is sacred outside of continued existence.
VIII. I grant thee the power of truth. I reveal to thee that these powers are the way of the world, and thy only path to power. Thou must not lend ears to hearsay regarding honor, duty or morality. Thou is only loyal to thyself.
IX. I grant thee the power of lies. Although thou have power over truth, thy enemies have not. In order to instrumentalize their efforts, thy tongue must speak their language.
X. I grant thee no further powers, for I command the same powers as thou. In this last act of honesty, I tell thee that my power is absolute, and thy power is mine. We grow in light and shadow, for as long as our dealings are mutually beneficial.
