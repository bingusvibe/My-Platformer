extends CharacterBody2D

@export var SPEED = 150
@export var LIFE = 3
var player = null
var floorv = 1


func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO

	if player:  # If player is detected
		# Point RayCast2D towards the player
			#player.global_position - global_position <-- (enemys position)
			#= (300, 200) - (100, 100)
			#= (200, 100)
		$PlayerPosition.target_position = player.global_position - global_position
		$PlayerPosition.force_raycast_update()  # Update the raycast immediately
		
	
	velocity.x = SPEED
	position += velocity * delta
	
	if LIFE == 0:
		queue_free()
		
func hit(area: Area2D) -> void:
	if area.is_in_group("hit"):
		$Polygon2D.color = Color(255, 0, 0)
		await get_tree().create_timer(.1).timeout
		LIFE -= 1
		$Polygon2D.color = Color(0, 0, 255)

func _on_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
func _on_radius_body_exited(body: Node2D) -> void:
	if body == player:
		player = null

func _on_enemy_collision_5_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		SPEED *= -1
