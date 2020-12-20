extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var my_random_number3 = 0
var BODY_PLAYER 
var DoDamage = false
var HasCollided = false
var Animation_State = 0
var Target
var speed = 400
var Gravity = 0.98
var Move = Vector3(0,0,0)
var Health = 100
var Time = 0
var velocity1 = Vector3()
onready var HealthBar = $Zombie2/HealthBar/Viewport/HealthBar2D
	#$HealthBar3D.update(Health, 100)
#func _ready():
	#HealthBar.value = Health
func _physics_process(_delta):
	if self.get_global_transform().origin.y < 0:
		Die()
	if Animation_State == 2:
		$Zombie2/AnimationPlayer.play("Armature|Walking")
	elif Animation_State == 1:
			$Zombie2/AnimationPlayer.play("Armature|ArmatureAction.001")
	Time += _delta
	if Target:
		look_at(Target.global_transform.origin, Vector3.UP)
		self.rotate_object_local(Vector3(0,1,0), 3.14)
		if HasCollided == false:
			Animation_State = 2
		else:
			Animation_State = 1
		move_to_target(_delta)
	else:

		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var my_random_number = rng.randf_range(-5.0, 5.0)
		var my_random_number2 = rng.randf_range(-5.0, 5.0)

		if Time > 0.3:
			my_random_number3 = rng.randf_range(-180.0, 180.0)
			#look_at(Target.global_transform.origin, Vector3.UP)
			#self.rotate_object_local(Vector3(my_random_number3 * _delta * 10,1,my_random_number3 * _delta * 10), 3.14)
			velocity1 = Vector3(my_random_number, 0 , my_random_number2)
			velocity1 = velocity1.linear_interpolate(velocity1, 1 * _delta)
			my_random_number = 0
			my_random_number2 = 0
			Time = 0
	Move.y -= Gravity
	velocity1 = move_and_slide(velocity1, Vector3.UP)
	var _velocity = move_and_slide(Move, Vector3(0, 1, 0))
	self.rotate_y(deg2rad(my_random_number3 * _delta))
func TakeDamage(var Damage):
	Target = get_parent().get_node("Player")
	Health -= Damage
	print(Health)
	HealthBar.value = Health
	if Health <= 0:
		Die()
func Die():
	get_parent().KillCounter = get_parent().KillCounter + 1
	Health = 100
	HealthBar.value = Health
	visible = false
	queue_free()
	#Run respawn script
# Called when the node enters the scene tree for the first time.
func move_to_target(delta):
	var direction = (Target.transform.origin - transform.origin).normalized()
	var _velocity = move_and_slide(direction * speed * delta, Vector3.UP)
func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		Target = body

func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		Target = null



func _on_Area2_body_entered(body):
	if body.is_in_group("Player"):
		BODY_PLAYER = body
		HasCollided = true
		$Timer.start()
		#Animation_State = 1


func _on_Area2_body_exited(body):
	if body.is_in_group("Player"):
		HasCollided = false
		#Animation_State = 2



func _on_Timer_timeout():
	$SwipeAttack.play()
	BODY_PLAYER.TakeDamage(10)
	DoDamage = true
	$Timer.stop()
	if HasCollided:
		$Timer.start()
		DoDamage = false
	


func _on_ZombieNoise_timeout():
	if DoDamage == false:
		$BaseZombieNoise.play()
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var my_random_number = rng.randf_range(2, 10)
		$ZombieNoise.wait_time = my_random_number
