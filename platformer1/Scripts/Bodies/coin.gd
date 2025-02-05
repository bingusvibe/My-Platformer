extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.score += 1
		self.queue_free()
