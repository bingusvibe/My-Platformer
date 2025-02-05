extends RigidBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _physics_process(delta):
	apply_central_impulse(Vector2(2, 0))
	if ray_cast_2d.is_colliding() == false:
		apply_central_impulse(Vector2(-2, 0))
	
	
	

 
