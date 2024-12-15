extends CharacterBody2D

#Animacion
@onready var animated_enemy = $AnimatedSprite2D
var HealthBarEnemy: Node = null
# Señales
signal died

#Detection
@onready var detection_area: Area2D = $AreaDetection # Referencia al área de detección
#Vida
@export var life = 150

#Booleanos
var isShoot = true
var moving = true  # Controla si el enemigo está en movimiento
var pause_or_end = false
var is_flashing = false
var is_dead = false
var isActivate = false

#Movimiento
@export var speed = 100.0
@export var dist = 90.0  

#Disparar
var player: Node2D = null  # Referencia al jugador, inicialmente nula
@onready var shoot_position = $"AnimatedSprite2D/Shoot Origin"
@onready var timer = $Timer
const bullet: PackedScene = preload("res://Scenes/bullet.tscn")

# SFX
@onready var hurtRobot = $HurtRobot1
@onready var hurtRobot2 = $HurtRobot2
@onready var alert = $Alert
@onready var shoot = $Shoot
@onready var explosion = $Explosion

# VFX
var unique_material: ShaderMaterial
@export var shader_material_resource: ShaderMaterial
@export var hit_flash = 0.2
@onready var icon = $Icon

func _ready():

	detection_area.body_entered.connect(_on_player_detected)
	detection_area.body_exited.connect(_on_player_lost)

	var HealthBars = get_tree().get_nodes_in_group("HealthBarEnemyM")
	if HealthBars.size() > 0:
		HealthBarEnemy = HealthBars[0]
	
	
	unique_material = shader_material_resource.duplicate() as ShaderMaterial
	animated_enemy.material = unique_material

func _on_player_detected(body: Node) -> void:
	if body.is_in_group("Player"):
		player = body  # Establece la referencia al jugador al ser detectado

func _on_player_lost(body: Node) -> void:
	if body.is_in_group("Player"):
		player = null  # Restablece la referencia al jugador al salir del área


func _physics_process(delta):
	if is_dead:
		velocity = Vector2.ZERO  # Detén cualquier movimiento
		return
	
	if not isShoot:
		return
	
	if player and isShoot:
		chase_player()
		icon.visible = true
	else:
		stop_chase()
		icon.visible = false

	if moving:
		move_and_slide()  # Aplica el movimiento al enemigo


func _update_sprite_direction() -> void:
	# Cambia la escala del sprite según la dirección en el eje X
	if velocity.x > 0:
		animated_enemy.scale.x = 1  # Mirar hacia la derecha
	elif velocity.x < 0:
		animated_enemy.scale.x = -1  # Mirar hacia la izquierda

func _shoot():
	var bullet_instance = bullet.instantiate()
	add_sibling(bullet_instance)
	bullet_instance.global_position = shoot_position.global_position
	bullet_instance.set_direction(player.global_position)
	isShoot = false
	shoot.play()
	timer.start()

func chase_player() -> void:
	if global_position.distance_to(player.global_position) < dist:
		# Si el jugador está dentro de la distancia mínima
		moving = false
		velocity = Vector2.ZERO
		animated_enemy.play("EnemyM_Shoot")
		_shoot()
		moving = true
		
	else:
		# Si el jugador está fuera de la distancia mínima
		moving = true
		animated_enemy.play("EnemyM_Run")
		velocity = (player.global_position - global_position).normalized() * speed
	_update_sprite_direction()


func stop_chase():
	moving = false
	animated_enemy.play("EnemyM_Idle")


func SET_pause_or_end(state):
	pause_or_end = state
	animated_enemy.pause()
	timer.stop()

func SET_lose(state):
	pause_or_end = state
	animated_enemy.play("EnemyM_Idle")
	timer.stop()

func _on_timer_timeout():
	isShoot = true

func GetDamage(gdamage):
	var random_number = randi() % 2 + 1
	if random_number == 1:
		hurtRobot.play()
	else:
		hurtRobot2.play()

	if not is_flashing:
		is_flashing = true
		unique_material.set("shader_parameter/damage_flash", 1.0)
		await get_tree().create_timer(hit_flash).timeout
		unique_material.set("shader_parameter/damage_flash", 0.0)
		is_flashing = false
	life -= gdamage
	HealthBarEnemy.update_health_bar(life)
	if (life <= 0 && !is_dead):
		is_dead = true
		emit_signal("died", )
		moving = false
		isShoot = false
		animated_enemy.play("EnemyM_Death")
		explosion.play()
		await animated_enemy.animation_finished
		queue_free()


func _on_area_detection_body_entered(body):
	if(body.is_in_group("Player") && !isActivate):
			alert.play()
			animated_enemy.play("EnemyM_Active")
			await animated_enemy.animation_finished
			isActivate = true
			
