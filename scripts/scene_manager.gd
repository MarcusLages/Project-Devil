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

@export var game_over_scene: PackedScene = preload("res://scenes/game_over_screen.tscn")
@export var ending_scene: PackedScene = preload("res://scenes/ending_scene.tscn")

var day_managers: Array[DayManager]
var has_items_container: bool = false
var lamp: Lamp = null

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

	_get_lamp.call_deferred()

	_curr_day = day
	print("Day %d" % (_curr_day + 1))
	return OK


func next_day() -> Error:
	fade("Day %d" % (_curr_day + 2))
	return load_day(_curr_day + 1)


func fade(text: String = ""):
	var fade_rect = $CanvasLayer/ColorRect
	var text_label = $CanvasLayer/Label
	text_label.text = text
		
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.0)
		
	tween.tween_callback(func(): text_label.visible = true)
	tween.tween_callback(func(): await get_tree().create_timer(2.0).timeout)
		
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.0)
	tween.tween_callback(func(): text_label.visible = false)


func _get_lamp():
	# Workaround to get the lamp
	lamp = null
	for item in day_managers[_curr_day].main_manager.interactable_items:
		print("Item: ", item.name)
		if item is Lamp:
			lamp = (item as Lamp)
			break


func _on_node_added(node: Node):
	if node is Stampable:
		(node as Stampable).stamped.connect(_on_stampable_stamped)


func _on_node_removed(node: Node):
	if node is Stampable:
		(node as Stampable).stamped.disconnect(_on_stampable_stamped)


func _on_stampable_stamped(correct: bool):
	if lamp: lamp.change_state(false, false)
	await get_tree().create_timer(0.05).timeout

	if correct:
		print("Correct stamp")
	else:
		GameManager.lives -= 1

		if GameManager.lives == 2:
			if lamp: lamp.scare(true, true)
		elif GameManager.lives == 1:
			if lamp: lamp.scare(true, true)
		else:
			if lamp: lamp.scare(false, true)

			# await get_tree().create_timer(1.).timeout
			# DANILO, SOM DE GAME OVER AQUI

			get_tree().change_scene_to_packed(game_over_scene)
			return

	if day_managers[_curr_day].next_record() == OK:
		if lamp: lamp.change_state(true, false)
		print("Next record")
	else:
		print("Last record of the day")
		day_managers[_curr_day].clean_record_scene(true)
		next_day()

		await get_tree().create_timer(0.5).timeout
		if lamp: lamp.change_state(true, false)
