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
@onready var Message = $CanvasLayer/ColorRect/TextureRectMessage
@onready var MessageText = $CanvasLayer/ColorRect/TextureRectMessage/Message
@onready var icon_portal = $"CanvasLayer/ColorRect/TextureRectMessage/Icon Portal"
@onready var icon_enemies = $"CanvasLayer/ColorRect/TextureRectMessage/Icon Enemies"
@onready var icon_enemies_2 = $"CanvasLayer/ColorRect/TextureRectMessage/Icon Enemies2"
@onready var message = $Message

#Referencia a la Tarjeta y al Inventario
@export var key_id_Blue : String
@export var key_id_Green : String
@export var key_id_Red : String

#Card Blue
@onready var IconBlue = $CanvasLayer/TextureRect/ItemCollected
#CardGreen
@onready var IconGreen = $CanvasLayer/TextureRect/ItemCollected2

@onready var Icon_Red = $CanvasLayer/TextureRect/ItemCollected3


#Referencias a la Puerta 1
@onready var Icon_Desapered = $CanvasLayer/TextureRect/ItemCollected
@onready var animated_door = $GiantDoorBlue/AnimatedSprite2D
@onready var DoorOpen = $"Door Open"
@onready var ActiveColor = $CanvasLayer/ColorRect
@onready var BM = $CanvasLayer/ColorRect/Background
@onready var Text = $CanvasLayer/ColorRect/Background/Label
@onready var Icon = $"CanvasLayer/ColorRect/Background/Icon Blue"
var door_open : bool

#Referencias a la Puerta 2
#Icono 
@onready var Icon_Desapered2 = $CanvasLayer/TextureRect/ItemCollected2
@onready var animated_door2 = $GiantDoorGreen/AnimatedSprite2D
@onready var DoorOpen2 = $"Door Open"
@onready var ActiveColor2 = $CanvasLayer/ColorRect
@onready var BM2 = $CanvasLayer/ColorRect/Background2
@onready var Text2 = $CanvasLayer/ColorRect/Background2/Label
@onready var Icon2 = $CanvasLayer/ColorRect/Background2/IconGreen

#Referencia a la puerta 3
@onready var Icon_Desapered3 = $CanvasLayer/TextureRect/ItemCollected3
@onready var animated_door3 = $GiantDoorRed/AnimatedSprite2D
@onready var DoorOpen3 = $"Door Open"
@onready var ActiveColor3 = $CanvasLayer/ColorRect
@onready var BM3 = $CanvasLayer/ColorRect/Background3
@onready var Text3 = $CanvasLayer/ColorRect/Background3/Label
@onready var Icon3 = $CanvasLayer/ColorRect/Background3/IconRed

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
	await $"SFX Buttons".finished
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



func _on_card_blue_body_entered(body):
	if body.is_in_group("Player"):
		Get.play()
		InventoryManager.add_to_inventory("BLUECARD", key_id_Blue)
		await Get.finished
		IconBlue.visible = true
		$CardBlue.queue_free()


func _on_card_green_body_entered(body):
	if body.is_in_group("Player"):
		Get.play()
		InventoryManager.add_to_inventory("GREENCARD", key_id_Green)
		await Get.finished
		IconGreen.visible = true
		$CardGreen.queue_free()

#PUERTA AZUL
func _on_area_unlocked_body_entered(body):
	if body.is_in_group("Player"):
		
		var has_item : bool = InventoryManager.has_inventory_item(key_id_Blue)
		
		if !has_item:
			return
		
		if !door_open:
			door_open = true
			$GiantDoorBlue/AreaLocked/CollisionShape2D.set_deferred("disabled", true)
			$GiantDoorBlue/AreaUnlocked/CollisionShape2D.set_deferred("disabled", true)
			$"Door Open".play()
			Icon_Desapered.visible = false
			animated_door.play("Giant Door Open")
			await animated_door.animation_finished
			$GiantDoorBlue/CollisionShape2D.set_deferred("disabled", true)
			ActiveColor.visible = false
			BM.visible = false
			Text.visible = false

func _on_area_locked_body_entered(body):
	if body.is_in_group("Player"):
		door_open = false
		ActiveColor.visible = true
		BM.visible = true
		Text.visible = true
		Icon.visible = true

func _on_area_locked_body_exited(body):
	if body.is_in_group("Player"):
		ActiveColor.visible = false
		BM.visible = false
		Text.visible = false
		Icon.visible = false


func _on_area_unlocked_green_body_entered(body):
	if body.is_in_group("Player"):
		
		var has_item : bool = InventoryManager.has_inventory_item(key_id_Green)
		
		if !has_item:
			return
		
		if !door_open:
			door_open = true
			$GiantDoorGreen/AreaUnlockedGreen/CollisionShape2D.set_deferred("disabled", true)
			$GiantDoorGreen/AreaUnlockedGreen/CollisionShape2D.set_deferred("disabled", true)
			$"Door Open".play()
			Icon_Desapered2.visible = false
			animated_door2.play("Giant Door Open")
			await animated_door2.animation_finished
			$GiantDoorGreen/CollisionShape2D.set_deferred("disabled", true)
			ActiveColor2.visible = false
			BM2.visible = false
			Text2.visible = false


func _on_area_locked_green_body_entered(body):
	if body.is_in_group("Player"):
		door_open = false
		ActiveColor2.visible = true
		BM2.visible = true
		Text2.visible = true
		Icon2.visible = true


func _on_area_locked_green_body_exited(body):
	if body.is_in_group("Player"):
		ActiveColor.visible = false
		BM2.visible = false
		Text2.visible = false
		Icon2.visible = false


func _on_card_red_body_entered(body):
	if body.is_in_group("Player"):
		Get.play()
		InventoryManager.add_to_inventory("REDCARD", key_id_Red)
		await Get.finished
		IconGreen.visible = true
		$CardRed.queue_free()


func _on_area_locked_red_body_entered(body):
	if body.is_in_group("Player"):
		door_open = false
		ActiveColor3.visible = true
		BM3.visible = true
		Text3.visible = true
		Icon3.visible = true


func _on_area_locked_red_body_exited(body):
	if body.is_in_group("Player"):
		ActiveColor.visible = false
		BM3.visible = false
		Text3.visible = false
		Icon3.visible = false


func _on_area_unlocked_red_body_entered(body):
	if body.is_in_group("Player"):
		
		var has_item : bool = InventoryManager.has_inventory_item(key_id_Green)
		
		if !has_item:
			return
		
		if !door_open:
			door_open = true
			$GiantDoorRed/AreaLockedRed/CollisionShape2D.set_deferred("disabled", true)
			$GiantDoorGreen/AreaUnlockedGreen/CollisionShape2D.set_deferred("disabled", true)
			$"Door Open".play()
			Icon_Desapered3.visible = false
			animated_door3.play("Giant Door Open")
			await animated_door2.animation_finished
			$GiantDoorRed/CollisionShape2D.set_deferred("disabled", true)
			ActiveColor2.visible = false
			BM3.visible = false
			Text3.visible = false


func _on_area_message_body_entered(body):
	if body.is_in_group("Player"):
		print("Player Colliding")
		message.play()
		color.visible = true
		Message.visible = true
		MessageText.visible = true
		icon_enemies.visible = true
		icon_portal.visible = true
		icon_enemies_2.visible = true


func _on_area_message_body_exited(body):
	if body.is_in_group("Player"):
		print("Player Out")
		color.visible = false
		Message.visible = false
		MessageText.visible = false 
		icon_enemies.visible = false
		icon_portal.visible = false
		icon_enemies_2.visible = false
