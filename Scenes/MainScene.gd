extends Spatial
var KillCounter = 0
onready var raycast = $Player/Head/Camera/RayCast
var sc = preload("res://Scenes/Ememy.gd")
onready var BulletDecal = preload("res://Scenes/BulletHole.tscn") 
#func _ready():
	#pass # Replace with function body.

func _process(_delta):
	if KillCounter == 5: 
		$Player.Winner()
#	if $Player.KinematicCollision().collider:
	#	$Player.TakeDamage(1)
	if $Player.isShooting and $Player/Head/Camera/machinegun/MuzzleFlash.visible:
		var B = BulletDecal.instance()
		var Hit = raycast.get_collider()

			
		if Hit != null:
			if Hit.is_in_group("Enemies"):
				if !$Player/ZombieDamage.playing:
					$Player/ZombieDamage.play()

			#$Player/ZombieDamage.stop()
			Hit.add_child(B)
				#raycast.add_child(B)
				#raycast.get_collider().add_child(B)
			B.global_transform.origin = raycast.get_collision_point()
			#B.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
			if raycast.get_collider().is_in_group("Enemies"):
				#get_node(Hit.name).TakeDamage(5)
				B.scale = B.scale * 100
			if raycast.get_collision_normal() == Vector3.DOWN:
				B.rotation_degrees.x = 90
			elif Vector3.UP.cross(raycast.get_collision_point() + raycast.get_collision_normal()) != Vector3():
				B.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
			var random = RandomNumberGenerator.new()
			random.randomize()
			B.rotation_degrees.z = random.randf_range(0.0,180.0)
			yield(get_tree().create_timer(15.0,false),"timeout")
			if is_instance_valid(B):
				B.queue_free() 
			#if raycast.get_collision_normal() == Vector3.DOWN: 
		#	B.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.DOWN)
	if Input.is_action_just_pressed("Fire"):
		var B = BulletDecal.instance()
		var Hit = raycast.get_collider()
		if Hit != null:
			#if Hit.name == "Enemy1":
			#	get_node("Enemy1").TakeDamage(1)
			Hit.add_child(B)
			#raycast.add_child(B)
			#raycast.get_collider().add_child(B)
			B.global_transform.origin = raycast.get_collision_point()
				
			if raycast.get_collider().is_in_group("Enemies"):
				B.scale = B.scale * 100
			if raycast.get_collision_normal() == Vector3.UP:
				B.look_at(raycast.get_collision_point() + raycast.get_collision_normal(), Vector3.UP)
	 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
