extends Control

var scene_path_to_load

func _ready():
	for button in $Menu2/Center/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
func _on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
	var val = get_tree().change_scene(scene_path_to_load)
	print(val)
