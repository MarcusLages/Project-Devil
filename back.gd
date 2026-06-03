extends Button


func _on_pressed():
	%Foreground.hide()
	for child in %Foreground.get_children():
		child.hide()
		for sub_child in child.get_children():
			sub_child.hide()
