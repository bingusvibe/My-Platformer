extends CharacterBody2D

@onready var WeaponScene = get_node("weapon")
@export var score = 0
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

var jumps = 0
var Playerdir = 1
var is_ready: bool = true
var is_dead: bool = false


func _ready():
	remove_child($weapon)
	$Dead.hide()

func _physics_process(delta: float) -> void:
	
	if is_dead == true:
		SPEED = 0
		JUMP_VELOCITY = 0
		velocity.x = 0
		
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
	if Input.is_action_just_pressed("Attack") and is_ready:
		if is_dead == true or is_ready == false:
			return
		add_child(WeaponScene)
		is_ready = false
		$Cooldown.start()
		
		#checks the players direction and predicts where the sword location should be
		if Playerdir == 1:
			$weapon.position.x = -10
			$AnimationPlayer.play("swing")
		elif Playerdir == 0:
			$weapon.position.x = 10
			$AnimationPlayer.play("swing2")
			#essentially wait() method
		await get_tree().create_timer(.2).timeout
		remove_child($weapon)
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#checks if there is no sword. Flips the player sprite
	#and sword sprite when held
	if velocity.x < 0:
		$Sprite2D.flip_h = false
		Playerdir = 1
		if $weapon == null:
			pass
		else:
			$weapon.position.x = -10
			$AnimationPlayer.play("swing")
	if velocity.x > 0:
		$Sprite2D.flip_h = true
		Playerdir = 0
		if $weapon == null:
			pass
		else:
			$weapon.position.x = 10
			$AnimationPlayer.play("swing2")
	
	move_and_slide()
	
func die():
	is_dead = true
	$Sprite2D.hide()
	$Dead.show()
	if $weapon == null:
		pass
	else:
		$weapon.queue_free()
	await get_tree().create_timer(.5).timeout
	get_tree().reload_current_scene()

func _on_spike_body_entered(_body: CharacterBody2D):
	die()
# checks if player is in the screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void: 
	die()
func _on_bounce_pad_body_entered(body): # bounce pad script
	velocity.y = -600
func _on_orb_body_entered(body): # orb jump script
	jumps += 1
func _on_orb_body_exited(body):#<
	jumps -= 1

#sword cooldown
func _on_cooldown_timeout() -> void:
	is_ready = true
func _on_enemy_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		die()
