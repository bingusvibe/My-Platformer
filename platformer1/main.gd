extends Node
@export var ball_scene: PackedScene

func _on_ball_timer_timeout() -> void:
	# Get all enemy nodes
	var enemies = get_tree().get_nodes_in_group("enemies")

	for enemy in enemies:
		if enemy:  # Ensure the node exists
			var ball = ball_scene.instantiate()
			ball.position = enemy.position
			add_child(ball)
