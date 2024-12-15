extends ProgressBar

# Vida
@export var max_health: float = 200
@export var current_health: float = 200


func _ready() -> void:
	max_value = max_health


func update_health_bar(value: float):
	current_health = value
	current_health = clamp(current_health, 0, max_health)
	self.value = current_health
