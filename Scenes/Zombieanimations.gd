extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

export var HasFinished = false
func _on_AnimationPlayer_animation_finished(_anim_name):
	print("PP")
	if HasFinished == false:
		HasFinished = true
