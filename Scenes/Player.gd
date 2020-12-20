extends RigidBody

export (NodePath) var target
var events = {}

#Movement Variables
var JumpForce = Vector3(0, 5, 0)
var Move = Vector3(0,0,0)
var Force = Vector3(0,0,0)
export var Movement_speed = 5
onready var Check_Ground = get_node("RayCast")
#MuzzleFlash/gun
export var DoneReloading = false 
export var Decrease = false
export var Ammo = 30
var TotalAmmo = 300
onready var Amin = $CameraParent/Camera/machinegun2/AnimationPlayer
#onready var MachineGunFlash = $CameraParent/Camera/machinegun2/MuzzleFlash
#MouseLook Variables
var MOUSE_SENSITIVITY = 0.1
var isShooting = false
export var Shoot = false
export var Reloading = false
onready var camera = $CameraParent/Camera
onready var Parent = $CameraParent
onready var JumpButton = $CameraParent/Camera/MarginContainer/VBoxContainer/Control/Control2/TouchScreenButton
onready var MoveButton = $CameraParent/Camera/MarginContainer2/VBoxContainer/Control3/Health/TouchScreenButton
#Health Variables
var Health = 100 
onready var HealthBar = $CameraParent/Camera/Control/TextureProgress
func _ready():
	$CameraParent/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
	HealthBar.value = Health
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func TakeDamage(var Damage):
	Health -= Damage
	HealthBar.value = Health
	if Health <= 0:
		Die()
func Die():
	Health = 100
	HealthBar.value = Health
	#Run respawn script

func _integrate_forces(_state):
	if !$AudioStreamPlayer.is_playing():
		$AudioStreamPlayer.play()
	var direction = $CameraParent.get_global_transform()
	if Move.x == 0:
		Move.x = MoveButton.get_value().x
	else:
		Move.x = 0
		Force.x = 0
	if Move.z == 0:
		Move.z = MoveButton.get_value().y
	else:
		Move.z = 0
		Force.z = 0 
	#elif Input.is_action_just_released("Move"):
		#Move.x = 0
		#Force.x = 0
		#Move.z = 0
		#Force.z = 0
	#if Input.is_key_pressed(KEY_W):
	#	Move.z -= 1
	#else:
	#	Move.z = 0
	#	Force.z = 0
	#if Input.is_key_pressed(KEY_S):
	#	Move.z += 1
	#if Input.is_key_pressed(KEY_A):
	#	Move.x -= 1
	#else:
	#	Move.x = 0
	#	Force.x = 0
	#if Input.is_key_pressed(KEY_D):
	#	Move.x += 1

	Move = Move.normalized()

	Force += direction.basis.z * Move.z
	Force += direction.basis.x * Move.x
	Force.y = 0
	#Force = Vector3(Force.x * Movement_speed, 0, Force.z * Movement_speed)
	Force = Force.normalized()
	#apply_impulse(Vector3.ZERO, Force)
	#add_force(Force, Vector3.ZERO)
	#apply_impulseVector3.ZERO, Force)
	#add_central_force(Force * Movement_speed)
	set_axis_velocity(Force * Movement_speed)
	if DoneReloading:
		DoneReloading = false 
		$CameraParent/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
	if Input.is_action_just_pressed("Reload"):
		$CameraParent/Camera/machinegun2/AnimationPlayer3.play("Reload")
		Reloading = true
	if Reloading:
		if !Decrease:
			Decrease = true
			var Difference = 30 - Ammo
			TotalAmmo -= Difference
			$CameraParent/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
	if Input.is_action_just_pressed("Fire"):
		isShooting = true
		#MachineGunFlash.visible = true
	elif Input.is_action_just_released("Fire"):
		isShooting = false
	if isShooting:
		if Shoot == false:
			if Ammo > 0 and !Reloading:
				Ammo = Ammo - 1
				$CameraParent/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
				Shoot = true
				#if $CameraParent/Camera/machinegun2/HitScan.is_colliding():
					
			else:
				$CameraParent/Camera/machinegun2/AnimationPlayer2.stop()
				Reloading = true 
				$CameraParent/Camera/machinegun2/AnimationPlayer3.play("Reload")
				$CameraParent/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
		#else:
			#reload
		if !$CameraParent/Camera/machinegun2/AnimationPlayer2.is_playing():
			if Ammo > 0 and !Reloading:
				#print(Ammo)
				Ammo = Ammo - 1
				$CameraParent/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
				$CameraParent/Camera/machinegun2/AnimationPlayer2.play("PlayerAmin")
			else:
				Reloading = true 
				$CameraParent/Camera/machinegun2/AnimationPlayer3.play("Reload")
				$CameraParent/Camera/AmmoControl/bullet2/Label.text = str(Ammo) + "\n" + "Total " + str(TotalAmmo)
			
	else:
		$CameraParent/Camera/machinegun2/AnimationPlayer2.stop()
		$CameraParent/Camera/machinegun2/MuzzleFlash.visible = false
	#	MachineGunFlash.visible = false
	if Input.is_action_just_pressed("ui_up") and Check_Ground.is_colliding():
			if !$AnimationPlayer3.is_playing():
				$AnimationPlayer3.play("Jump")
			apply_impulse(Vector3.ZERO, JumpForce)
	#if $JumpSound.is_playing() and !Check_Ground:
	#	$JumpSound.stop()
	#if Input.is_key_pressed(KEY_SPACE) and Check_Ground.is_colliding():
			#apply_impulse(Vector3.ZERO, JumpForce)
			
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event is InputEventScreenDrag:
			if event.index == MoveButton.ongoing_drag:
				return
	#	if event.index == 1:
			camera.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
			Parent.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

			var camera_rot = camera.rotation_degrees
			camera_rot.x = clamp(camera_rot.x, -90, 90)
			camera.rotation_degrees = camera_rot
	#if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
	#	camera.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
	#	Parent.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		#var camera_rot = camera.rotation_degrees
	#	camera_rot.x = clamp(camera_rot.x, -90, 90)
	#	camera.rotation_degrees = camera_rot


func _on_Area_body_entered(body):
	if body.get_script() == get_parent().sc:
		$Damage.play()
		TakeDamage(10)
	pass # Replace with function body.
