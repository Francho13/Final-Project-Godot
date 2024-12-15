extends State
class_name IdleState

@onready var background_bar = $"../../UI/BackgroundBar"
@onready var progressbar = $"../../UI/BackgroundBar/Progressbar"



func transition():
	if ray_cast.is_colliding():
		background_bar.visible = true
		progressbar.visible = true
		get_parent().change_state("Shoot")
