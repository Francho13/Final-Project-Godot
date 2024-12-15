extends Node2D

#Referncia al jugador
@onready var player = $player

#Proxima Escena
@export var scene_Level_next: PackedScene

#Referencias al Menu
@onready var BTM_pause = $"CanvasLayer/ColorRect/TextureRectPause/Back To Menu"
@onready var label_pause = $CanvasLayer/ColorRect/TextureRectPause/Label
@onready var Restart_pause = $CanvasLayer/ColorRect/TextureRectPause/Restart
@onready var restart_lose = $CanvasLayer/ColorRect/TextureRectLose/Restart
@onready var back_to_menu_lose = $"CanvasLayer/ColorRect/TextureRectLose/Back To Menu"
@onready var Label_lose = $CanvasLayer/ColorRect/TextureRectLose/Label
@onready var color =$CanvasLayer/ColorRect 
@onready var TRectPause = $CanvasLayer/ColorRect/TextureRectPause
@onready var TRectWin = $CanvasLayer/ColorRect/TextureRectWin
@onready var label = $CanvasLayer/ColorRect/TextureRectWin/Label
@onready var restart = $CanvasLayer/ColorRect/TextureRectWin/Restart
@onready var next_level = $"CanvasLayer/ColorRect/TextureRectWin/Next Level"
@onready var back_to_menu = $"CanvasLayer/ColorRect/TextureRectWin/Back To Menu"
@onready var TRectLose = $CanvasLayer/ColorRect/TextureRectLose

#UI Animations
@export var tween_instensity: float
@export var tween_duration: float


#Booleanos
var is_pause = false
var level_finished = false

#Timer
var paused_timer_time: float = 0
@export var time_left: float
var timer: Timer = null
var active_timer: SceneTreeTimer = null
@onready var coutndown = $CanvasLayer/Timer

#SFX
@onready var MusicofLevel = $"Music of Level"
@onready var MusicofWin = $"Music of Win"
@onready var game_over = $GameOver
@onready var sfx_button = $Buttons_Hover
@onready var Get = $GetItem

func _ready() -> void:
	AudioManager.stop_audio()
	MusicofLevel.play()
	player.connect("died", Callable(self, "_on_player_died"))
	coutndown.text = str(time_left)
	create_timer()
	

func _process(delta):
	btn_hovered(BTM_pause)
	btn_hovered(Restart_pause)
	btn_hovered(restart_lose)
	btn_hovered(back_to_menu_lose)
	btn_hovered(restart)
	btn_hovered(next_level)
	btn_hovered(back_to_menu)
	if(!level_finished):
		pause_controller()


func pause_controller():
	if Input.is_action_just_pressed("Pause"):
		if (is_pause):
			is_pause = false
			color.visible = false
			TRectPause.visible = false
			Restart_pause.visible = false
			back_to_menu.visible = false
			BTM_pause.visible = false
			label_pause.visible = false
			player.SET_pause_or_end(false)
			get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFAULT, "enemies", "SET_pause_or_end", false)
			if paused_timer_time > 0:
				active_timer = get_tree().create_timer(paused_timer_time)
				active_timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
		else:
			is_pause = true
			color.visible = true
			TRectPause.visible = true
			Restart_pause.visible = true
			back_to_menu.visible = true
			BTM_pause.visible = true
			label_pause.visible = true
			get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFAULT, "enemies", "SET_pause_or_end", true)
			player.SET_pause_or_end(true)
			if active_timer:
				paused_timer_time = active_timer.time_left
				active_timer = null

#Animacion de los Botones  
func start_Tween(object: Object, property: String, final_val: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object,property,final_val,duration)

func btn_hovered(button:Button):
	button.pivot_offset = button.size/2
	if button.is_hovered():
		start_Tween(button, "scale", Vector2.ONE * tween_instensity, tween_duration)
	else:
		start_Tween(button, "scale", Vector2.ONE , tween_duration)

func _on_restart_pressed():
	$"SFX Buttons".play()
	await sfx_button.finished
	get_tree().reload_current_scene()


func _on_back_to_menu_pressed():
	$"SFX Buttons".play()
	await $"SFX Buttons".finished
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")

func SetWin():
	MusicofLevel.stop()
	player.SET_pause_or_end(true)
	level_finished = true
	MusicofWin.play()
	color.visible = true
	TRectWin.visible = true
	restart.visible = true
	next_level.visible = true
	back_to_menu.visible = true
	label.visible = true

func SetLose():
	MusicofLevel.stop()
	get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFAULT, "enemies", "SET_lose", true)
	player.SET_pause_or_end(true)
	level_finished = true
	game_over.play()

func _on_player_died() -> void:
	if !level_finished:
		SetLose()


func _on_portal_body_entered(body):
	if body.is_in_group("Player"):
		print("Player Colliding")
		SetWin()
		


func _on_game_over_finished():
	color.visible = true
	TRectLose.visible = true
	restart_lose.visible = true
	back_to_menu_lose.visible = true
	Label_lose.visible = true

func create_timer() -> void:
	active_timer = get_tree().create_timer(1.0)
	active_timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _on_Timer_timeout() -> void:
	if !level_finished && !is_pause:
		if time_left > 0:
			time_left -= 1
			coutndown.text = str(time_left)
			if time_left > 0:
				create_timer()
		if (time_left == 0):
			SetLose()



func _on_next_level_pressed():
	TRectWin.visible = false
	restart_lose.visible = false
	back_to_menu_lose.visible = false
	Label_lose.visible = false
	$"SFX Buttons".play()
	await $"SFX Buttons".finished
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(scene_Level_next)


