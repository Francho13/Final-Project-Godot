extends Control

#SFX
@onready var sfx_buttons = $"SFX Buttons"
@onready var hover_sound = $Buttons_Hover

#GUI animations
@export var tween_instensity: float
@export var tween_duration: float
@onready var BL1 = $"CanvasLayer/Level Menu/ClipControl/GridContainer/BL1"
@onready var BL2 = $"CanvasLayer/Level Menu/ClipControl/GridContainer/BL2"
@onready var BL3 = $"CanvasLayer/Level Menu/ClipControl/GridContainer/BL3"
@onready var BL4 = $"CanvasLayer/Level Menu/ClipControl/GridContainer/BL4"
@onready var back = $CanvasLayer/Back


func _process(delta:float)->void:
	btn_hovered(BL1)
	btn_hovered(BL2)
	btn_hovered(BL3)
	btn_hovered(BL4)
	btn_hovered(back)
	
	

func start_Tween(object: Object, property: String, final_val: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object,property,final_val,duration)

func btn_hovered(button:Button):
	button.pivot_offset = button.size/2
	if button.is_hovered():
		start_Tween(button, "scale", Vector2.ONE * tween_instensity, tween_duration)
	else:
		start_Tween(button, "scale", Vector2.ONE , tween_duration)

func _on_button_mouse_entered():
	hover_sound.play()


func _on_back_pressed():
	sfx_buttons.play()
	await $"SFX Buttons".finished
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")

func _on_bl_1_pressed():
	sfx_buttons.play()
	await $"SFX Buttons".finished
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Level 1.tscn")
	


func _on_bl_2_pressed():
	sfx_buttons.play()
	await $"SFX Buttons".finished
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Level 2.tscn")





func _on_bl_3_pressed():
	sfx_buttons.play()
	await $"SFX Buttons".finished
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Level 3.tscn")
	





func _on_bl_4_pressed():
	sfx_buttons.play()
	await $"SFX Buttons".finished
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Level 4.tscn")
