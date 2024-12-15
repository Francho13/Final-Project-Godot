extends Node2D

@onready var animated_sprite = $Sprite2D/AnimationKit
@export var life = 20 

func _on_animation_player_animation_finished(anim_name)-> void:
		animated_sprite.play("Icon to life")
