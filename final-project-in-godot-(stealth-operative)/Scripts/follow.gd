extends State
class_name FollowState
 
@onready var animated_boss = $"../../AnimatedSprite2D"


func transition():
	if ray_cast.is_colliding():
		get_parent().change_state("Shoot")

	
func enter():
	super.enter()
	owner.set_physics_process(true)
	animated_boss.play("Boss_Run")
 
func exit():
	super.exit()
	owner.set_physics_process(false)
	animated_boss.stop()
