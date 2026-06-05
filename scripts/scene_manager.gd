extends Node

## DayManager responsible for going through records throughout the day
@export var day_manager: DayManager = null

func _enter_tree() -> void:
    get_tree().node_added.connect(_on_node_added)
    get_tree().node_removed.connect(_on_node_removed)

func _ready() -> void:
    if not day_manager:
        day_manager = get_node_or_null("../DayManager")

    assert(day_manager != null, "Must have a DayManager associated or as a brother node to the SceneManager.")

    # TODO: Delete this, just for testing
    day_manager.load_record(0)

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

    if day_manager.next_record() == OK: # TODO: handle last record
        print("Next record")
    else:
        print("Last record already")