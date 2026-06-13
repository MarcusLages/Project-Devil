extends Area2D

@export var pages_container: Node2D

@onready var interactable: Interactable = $Interactable

var pages: Array[Page]
var curr_page: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if not pages_container:
        pages_container = get_node_or_null("ZoomedContent")
    
    assert(pages_container != null, "Pages container cannot be null")

    for p in pages_container.get_children():
        pages.append(p)
        p.next_page.connect(_on_page_next_page)
        p.prev_page.connect(_on_page_prev_page)

    # Godot is weird
    pages.sort_custom(func(a, b): return int(a.name) < int(b.name))
    for p in pages:
        p.visible = false
        print(p.name)

    pages[0].visible = true


func _on_page_next_page():
    if curr_page < pages.size() - 1:
        pages[curr_page].visible = false
        curr_page += 1
        pages[curr_page].visible = true


func _on_page_prev_page():
    if curr_page > 0:
        pages[curr_page].visible = false
        curr_page -= 1
        pages[curr_page].visible = true


func _on_zoomable_zoomed() -> void:
    interactable.hard_disabled = true

func _on_zoomable_unzoomed() -> void:
    interactable.hard_disabled = false
    pages[curr_page].visible = false
    curr_page = 0
    pages[curr_page].visible = true
