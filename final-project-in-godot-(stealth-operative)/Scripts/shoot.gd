extends State
class_name ShootState
 
@export var bullet_node : PackedScene 
@onready var timer = $Timer
@onready var shoot_origin = $ShootOrigin
@onready var animated_boss = $"../../AnimatedSprite2D"


func transition():
	if not ray_cast.is_colliding():
			get_parent().change_state("Follow")

func enter():
	super.enter()
	timer.start()
 
func exit():
	super.exit()
	timer.stop()

func _shoot():
	animated_boss.play("Boss Shoot")
	await animated_boss.animation_finished
	var bullet_instance = bullet_node.instantiate()
	add_sibling(bullet_instance)
	bullet_instance.global_position = shoot_origin.global_position
	bullet_instance.set_direction(player.global_position)


func _on_timer_timeout():
	_shoot()
