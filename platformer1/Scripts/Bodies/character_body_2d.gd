extends CharacterBody2D

@export var score = 0
@onready var SwordScene: Node = $weapon
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var jumps = 0
var Playerdir = 1
var is_ready: bool = true

func _ready():
	remove_child(SwordScene)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#Checks if the jumps value is 1 to make the orb work
	if Input.is_action_just_pressed("up") and jumps == 1 :
		velocity.y = JUMP_VELOCITY
		
	# sword script
	if Input.is_action_just_pressed("Attack") and $weapon/Sword == null and is_ready:

		add_child(SwordScene)
		is_ready = false
		$Cooldown.start()
		
		if Playerdir == 1:
			$weapon/Sword.position.x = -32
			$weapon/Sword.rotation_degrees = 0
		else:
			$weapon/Sword.position.x = 32
			$weapon/Sword.rotation_degrees = 180
			#essentially wait() method
		await get_tree().create_timer(.2).timeout
		remove_child(SwordScene)
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
	if velocity.x < 0:
		$Sprite2D.flip_h = false
		Playerdir = 1
		if $weapon/Sword == null:
			pass
		else:
			$weapon/Sword.position.x = -32
			$weapon/Sword.rotation_degrees = 0
	if velocity.x > 0:
		$Sprite2D.flip_h = true
		Playerdir = 0
		if $weapon/Sword == null:
			pass
		else:
			$weapon/Sword.position.x = 32
			$weapon/Sword.rotation_degrees = 180
	
		
		
	move_and_slide()
	
func die():
	hide()
	#await get_tree().create_timer(.5).timeout
	get_tree().reload_current_scene()

func _on_spike_body_entered(_body: CharacterBody2D):
	die()
func _on_visible_on_screen_notifier_2d_screen_exited() -> void: # checks if player is in the screen
	die()
func _on_bounce_pad_body_entered(body): # bounce pad script
	velocity.y = -600
func _on_orb_body_entered(body): # orb jump script
	jumps += 1
func _on_orb_body_exited(body):#<
	jumps -= 1
func _on_enemy_2_body_entered(body: Node2D) -> void:
	if get_tree().has_group("weapons"):
		print(1)
	die()

func _on_cooldown_timeout() -> void:
	is_ready = true
	
