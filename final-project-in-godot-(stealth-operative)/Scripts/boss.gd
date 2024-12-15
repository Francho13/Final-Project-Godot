extends CharacterBody2D

@onready var ray_cast = $RayCast2D
@onready var player = get_parent().find_child("player")
@onready var sprite = $AnimatedSprite2D
@onready var HealthBarBoss : Node = null
@onready var animated_enemy = $AnimatedSprite2D
@onready var explosion = $Explosion

# Variables para manejar el daño y la salud
@export var life = 200
var is_dead = false
var is_flashing = false
var pause_or_end = false
var unique_material: ShaderMaterial
@export var shader_material_resource: ShaderMaterial
@export var hit_flash = 0.2 # Duración del flash al recibir daño
var direction = Vector2.RIGHT
@export var speed = 100.0

signal died



func _ready():
	set_physics_process(false)
	unique_material = shader_material_resource.duplicate() as ShaderMaterial
	animated_enemy.material = unique_material
	
	var HealthBars = get_tree().get_nodes_in_group("Bar_Boss")
	if HealthBars.size() > 0:
		HealthBarBoss = HealthBars[0]

func _process(_delta):
	# Calcular dirección hacia el jugador
	direction = (player.position - global_position).normalized()
	ray_cast.target_position = direction * 250
	
	# Voltear sprite según la dirección
	if sprite:
		if direction.x < 0:
			sprite.scale.x = -abs(sprite.scale.x) # Voltear hacia la izquierda
		else:
			sprite.scale.x = abs(sprite.scale.x) # Voltear hacia la derecha

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()

# Método para manejar el daño
func GetDamage(gdamage):
	var random_number = randi() % 2 + 1
	if random_number == 1:
		$HurtRobot2.play()
	else:
		$HurtRobot1.play()

	if not is_flashing:
		is_flashing = true
		unique_material.set("shader_parameter/damage_flash", 1.0)
		await get_tree().create_timer(hit_flash).timeout
		unique_material.set("shader_parameter/damage_flash", 0.0)
		is_flashing = false
	life -= gdamage
	HealthBarBoss.update_health_bar(life)
	
	if (life <= 0 && !is_dead):
		is_dead = true
		emit_signal("died", )
		find_child("FSM").change_state("Death")
		$"../Portal".visible = true
func SET_pause_or_end(state):
	pause_or_end = state
	animated_enemy.pause()
	
func SET_lose(state):
	pause_or_end = state
	animated_enemy.play("Boss Idle")
