extends Control

@onready var coffee_node = %Foreground/Items/Coffee
@onready var lamp_node = %Foreground/Items/Lamp
@onready var phone_node = %Foreground/Items/Phone


func _on_coffee_pressed():
	show_tree(coffee_node)


func _on_lamp_pressed():
	show_tree(lamp_node)


func _on_phone_pressed():
	show_tree(phone_node)
	
	
func show_tree(node: Control) -> void:
	node.show()
	node.get_parent_control().show()
	node.get_parent_control().get_parent_control().show()
