extends Area2D

@export var speed = 200 
@export var damage = 8
var direction = Vector2.ZERO
var performer

func get_performer():
	return performer

func Destroy():
	queue_free()

func _physics_process(delta):
	# Mover la bala en la dirección establecida
	position += direction * speed * delta

func set_direction(target_position: Vector2):
	# Calcula la dirección hacia el objetivo y la normaliza
	direction = (target_position - global_position).normalized()



func _on_body_entered(body):
	if(body.name != performer):
		Destroy()
