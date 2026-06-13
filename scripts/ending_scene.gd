extends "res://scripts/text_screen.gd"

@export var chosen_one: String
@export var endings: Dictionary = {}

const DEFAULT_CHOSEN: String = "board"

func _ready() -> void:
    if not chosen_one:
        chosen_one = (
            GameManager.final_stamp
            if GameManager.final_stamp 
            else DEFAULT_CHOSEN
        )
    
    assert(
        endings != null and chosen_one in endings,
        "Endings must not be empty and the chosen one must be a key in endings"
    )

    var paragraph := endings[chosen_one] as String
    lines = paragraph.replace("\\n", "\n").split("\\")
    super._ready()
