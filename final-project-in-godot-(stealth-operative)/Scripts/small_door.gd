extends StaticBody2D



func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		$"Door Open".play()
		$AnimatedSprite2D.play("Small Door Open")
		await $AnimatedSprite2D.animation_finished
		$CollisionShape2D.set_deferred("disabled", true)




func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		$CollisionShape2D.set_deferred("disabled", false)
		$AnimatedSprite2D.play("Small Door Close")
