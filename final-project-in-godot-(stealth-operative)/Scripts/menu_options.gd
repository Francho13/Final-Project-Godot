extends Control

#GUI animations

@onready var sfx_buttons = $"SFX Buttons"
@export var tween_instensity: float
@export var tween_duration: float
@onready var back = $CanvasLayer/ColorRect/Settings/Back
@onready var hover_sound = $Buttons_Hover


func _process(delta:float)->void:
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


func _on_button_pressed():
	sfx_buttons.play()
	await sfx_buttons.finished
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")


func _on_resolution_full_screen_toggled(toggled_on):
	if toggled_on:
		sfx_buttons.play()
		
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		sfx_buttons.play()
		
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



func _on_button_mouse_entered():
	hover_sound.play()
