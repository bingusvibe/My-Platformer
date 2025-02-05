extends CharacterBody2D

@export var SPEED = 200


func _physics_process(delta: float) -> void:
	velocity.x = SPEED
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("I collided with ", collision.get_collider().name)
		
	move_and_slide()


# Example usage when colliding with another body
func _on_enemy_collision_body_entered(body):
	SPEED *= -1
