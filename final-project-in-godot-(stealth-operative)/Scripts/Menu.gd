extends Control

#GUI animations

@onready var play = $CanvasLayer/ColorRect/VBoxContainer/Play
@onready var options = $CanvasLayer/ColorRect/VBoxContainer/Options
@onready var exit = $CanvasLayer/ColorRect/VBoxContainer/Credits
@onready var credits = $CanvasLayer/ColorRect/VBoxContainer/Exit
@export var tween_instensity: float
@export var tween_duration: float

#SFX
@onready var sfx_buttons = $"SFX Buttons"
@onready var hover_sound = $Buttons_Hover



var config_file_path: String = "user://audio_settings.json"
var buttons: Array[Button] = []
var current_button_index: int = 0

func _ready():
	
	AudioManager.play_audio()
	for button in get_tree().get_nodes_in_group("buttons"):
		if button is Button:
			button.connect("mouse_entered", Callable(self, "_on_button_mouse_entered"))
	apply_audio_settings("Master")
	apply_audio_settings("Music")
	apply_audio_settings("SFX")


func _process(delta: float) -> void:
	btn_hovered(play)
	btn_hovered(options)
	btn_hovered(credits)
	btn_hovered(exit)
	

func start_Tween(object: Object, property: String, final_val: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)

func btn_hovered(button: Button):
	button.pivot_offset = button.size / 2
	if button.is_hovered():
		start_Tween(button, "scale", Vector2.ONE * tween_instensity, tween_duration)
	else:
		start_Tween(button, "scale", Vector2.ONE, tween_duration)

func apply_audio_settings(bus_name: String) -> void:
	var config = load_audio_settings()
	var bus_index = AudioServer.get_bus_index(bus_name)

	if bus_name in config:
		var db_value = config[bus_name]
		AudioServer.set_bus_volume_db(bus_index, db_value)
	else:
		var default_db = AudioServer.get_bus_volume_db(bus_index)
		AudioServer.set_bus_volume_db(bus_index, default_db)

func load_audio_settings() -> Dictionary:
	if FileAccess.file_exists(config_file_path):
		var file = FileAccess.open(config_file_path, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		var parse_result = JSON.parse_string(content)
		if typeof(parse_result) == TYPE_DICTIONARY:
			return parse_result
	return {}


func _on_play_pressed():
	sfx_buttons.play()
	await $"SFX Buttons".finished
	get_tree().change_scene_to_file("res://Scenes/Level Selector.tscn")

func _on_options_pressed():
	sfx_buttons.play()
	await $"SFX Buttons".finished
	get_tree().change_scene_to_file("res://Scenes/Menu_Options.tscn")
	
	
func _on_button_mouse_entered():
	hover_sound.play()

func _on_credits_pressed():
	sfx_buttons.play()
	await $"SFX Buttons".finished
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")


func _on_exit_pressed():
	sfx_buttons.play()
	await $"SFX Buttons".finished
	get_tree().quit()
