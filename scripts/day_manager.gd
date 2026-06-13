extends Node

class_name DayManager

const FIXED_ITEMS_TAG: StringName = "fixed_item"

## InteractableManager representing items that will be staying between 
## different record folders.
@export var fixed_items_scene: PackedScene = null

## List of InteractableManagers representing record folders.
## IMPORTANT: Order matters.
@export var record_scenes: Array[PackedScene]

## Main InteractableManager in which all items will be a child of.
## If null, a new InteractableManager will be used
@export var main_manager: InteractableManager

## Scene container which the Main Manager will be reparented to.
## If null, will use the Main Manager parent. 
## If MainManager is null, the parent will be checked.
## If there's no parent, self will be used.
@export var items_container: Node = null


var _curr_record: int = -1

var fixed_items_manager: InteractableManager = null
var record_managers: Array[InteractableManager] = []

var has_fixed_items: bool = false


func _ready() -> void:
	if not items_container:
		if main_manager:
			items_container = main_manager.get_parent()
		else:
			items_container = get_parent()
		if not items_container:
			items_container = self
			
	# ! IMPORTANT: visible items are going to be in items_container > main_manager > items
	if main_manager:
		main_manager.reparent(items_container)
	else:
		main_manager = InteractableManager.new()
		items_container.add_child.call_deferred(main_manager)

	if fixed_items_scene:
		fixed_items_manager = fixed_items_scene.instantiate() as InteractableManager
		has_fixed_items = true
		
		# Just to start the fixed_items_manager and call its _ready()
		add_child(fixed_items_manager)
		fixed_items_manager.move_items_to.call_deferred(main_manager, main_manager, FIXED_ITEMS_TAG)

		remove_child.call_deferred(fixed_items_manager)

	for rec_scene in record_scenes:
		var rec := rec_scene.instantiate() as InteractableManager
		record_managers.append(rec)
	

func clean_record_scene(clean_fixed: bool = false):
	for item in main_manager.interactable_items:
		if not item.has_meta(FIXED_ITEMS_TAG) or clean_fixed:
			if item.get_parent() == main_manager:
				main_manager.remove_child(item)
	
	for item in main_manager.z_idx_stack:
		if not item.has_meta(FIXED_ITEMS_TAG) or clean_fixed:
			if item.get_parent() == main_manager:
				main_manager.remove_child(item)

	# This is just used to make sure all items are enabled again
	main_manager.change_state(false, false)


func load_record(rec_idx: int) -> Error:
	clean_record_scene()
	
	if rec_idx < 0 or rec_idx >= record_managers.size():
		return ERR_DOES_NOT_EXIST

	_curr_record = rec_idx
	var new_record: InteractableManager = record_managers[rec_idx]

	# Just to start the fixed_items_manager and call its _ready()
	add_child(new_record)
	new_record.move_items_to.call_deferred(main_manager, main_manager)

	remove_child.call_deferred(new_record)
	print("Record %d" % (_curr_record + 1))
	return OK


func next_record() -> Error:
	return load_record(_curr_record + 1)


## Returns old container if everything was correct
func change_items_container(new: Node) -> Node:
	if not new:
		return null

	var old: Node = items_container
	main_manager.reparent(new)
	items_container = new
	return old

	
