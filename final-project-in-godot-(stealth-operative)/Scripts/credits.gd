extends Control

#GUI animations

@onready var Back_Menu = $CanvasLayer/Back
@export var tween_instensity: float
@export var tween_duration: float
var scene_menu = load("res://Scenes/Main Menu.tscn")

#SFX
@onready var sfx_buttons = $"SFX Buttons"
@onready var hover_sound = $Buttons_Hover
@onready var music_credits = $"Music Credits"

func _ready():
	AudioManager.stop_audio()
	music_credits.play()


func _process(delta: float) -> void:
	btn_hovered(Back_Menu)
	
	

func start_Tween(object: Object, property: String, final_val: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)

func btn_hovered(button: Button):
	button.pivot_offset = button.size / 2
	if button.is_hovered():
		start_Tween(button, "scale", Vector2.ONE * tween_instensity, tween_duration)
	else:
		start_Tween(button, "scale", Vector2.ONE, tween_duration)



func _on_back_pressed():
	sfx_buttons.play()
	await $"SFX Buttons".finished
	get_tree().change_scene_to_packed(scene_menu)


func _on_back_mouse_entered():
	hover_sound.play()
