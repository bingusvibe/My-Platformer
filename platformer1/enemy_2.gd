extends Area2D

@export var SPEED = 150


func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	velocity.x = SPEED
	
	position += velocity * delta


func _on_enemy_collision_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	SPEED *= -1
