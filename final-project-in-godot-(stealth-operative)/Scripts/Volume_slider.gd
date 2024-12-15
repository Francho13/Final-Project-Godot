extends HSlider

@export var bus_name: String  # Nombre del bus de audio (ej. "Master", "SFX", "Music")
var bus_index: int
var config_file_path: String = "user://audio_settings.json"

func _ready() -> void:
	# Obtener el índice del bus de audio a partir de su nombre
	bus_index = AudioServer.get_bus_index(bus_name)
	
	# Cargar la configuración de audio guardada y ajustar el slider
	var config = load_audio_settings()
	if bus_name in config:
		value = db_to_linear(config[bus_name])  # Si existe en config, usar el valor guardado
	else:
		value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))  # Si no existe, usar el valor actual del bus

	# Conectar el cambio de valor del slider al método _on_value_changed
	self.value_changed.connect(_on_value_changed)

# Método llamado cuando cambia el valor del slider
func _on_value_changed(value: float) -> void:
	var db_value = linear_to_db(value)  # Convertir el valor del slider de lineal a decibelios
	AudioServer.set_bus_volume_db(bus_index, db_value)  # Aplicar el nuevo valor de volumen al bus
	save_audio_settings(bus_name, db_value)  # Guardar el valor de volumen en la configuración

# Guardar la configuración de audio en un archivo JSON
func save_audio_settings(bus_name: String, db_value: float) -> void:
	var config = load_audio_settings()  # Cargar la configuración existente
	config[bus_name] = db_value  # Actualizar o agregar el valor de volumen para el bus dado
	
	var file = FileAccess.open(config_file_path, FileAccess.WRITE)  # Abrir el archivo en modo escritura
	if file:
		file.store_string(JSON.stringify(config, "  "))  # Guardar el JSON formateado
		file.close()

# Cargar la configuración de audio desde el archivo JSON
func load_audio_settings() -> Dictionary:
	var config = {}
	if FileAccess.file_exists(config_file_path):
		var file = FileAccess.open(config_file_path, FileAccess.READ)
		if file:
			var content = file.get_as_text()  # Leer el contenido del archivo
			file.close()
			var result = JSON.parse_string(content)  # Parsear el contenido JSON
			if typeof(result) == TYPE_DICTIONARY:
				config = result
			else:
				print("Error: El archivo JSON no tiene un formato válido.")
	return config

