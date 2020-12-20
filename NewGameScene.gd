extends Control

func _on_Button_pressed():
	var val = get_tree().change_scene("res://Scenes/TitleScreen.tscn")
	print(val)


func _on_Button2_pressed():
	var val = get_tree().change_scene("res://Scenes/Level2.tscn")
	print(val)
