extends CharacterBody2D

#Referencia al Mananager
var Level1 : Node2D 

#Animacion
@onready var anim_player = $AnimatedSprite2D
@export var speed = 200


#Vida
@onready var heal = $Heal
@export var life = 100;
var HealthBar: Node = null

#Daño y Ataque
@onready var AttackShape = $HitBox
@export var player_damage = 10

#Damage Area
@export var area_damage = 10
var is_in_green_area: bool = false  # Para rastrear si está en la zona verde.
@onready var damage_timer = Timer.new()

#Enemgios
var force: Vector2
var enemies_on_stage: Array = []

#Estados y Booleanos
var pause_or_end = false
var is_moving : bool 
var isAttacking = false
var direction = "right"
var is_blinking = false
var is_flashing = false
var is_dead = false
var is_Shooting = false

#SFX 
@onready var attackknife_1 = $Attack_01
@onready var attackknife_2 = $Attack_02
@onready var Scream1 = $"ScreamHit 1"
@onready var Scream2 = $ScreamHit2
@onready var Footsteps = $Footsteps

#VFX
@export var blink_duration = 1
@export var force_value = 250
@export var flash_duration = 0.2


#Señales
signal died


func _ready():
	var HealthBars = get_tree().get_nodes_in_group("Health_Bar")
	if HealthBars.size() > 0:
		HealthBar = HealthBars[0]
		
	damage_timer.wait_time = 1.0  # Daño cada 1 segundo
	damage_timer.one_shot = false
	damage_timer.connect("timeout", Callable(self, "_apply_area_damage"))
	add_child(damage_timer)
	
func _physics_process(delta):
	if !pause_or_end: 
		if (!isAttacking):
			movement(delta)
		update_animations()
		attack()
	
	


func GetDamage(damage):
	if(!Scream1.is_playing() && !Scream2.is_playing()):
			var random_number = randi() % 2 + 1
			if(random_number == 1):
				Scream1.play()
			elif(random_number == 2):
				Scream2.play()
	is_blinking = true
	var material = anim_player.material as ShaderMaterial
	material.set("shader_parameter/blink", 1.0)
	await get_tree().create_timer(blink_duration).timeout
	material.set("shader_parameter/blink", 0.0)
	is_blinking = false
	life -= damage
	HealthBar.update_health_bar(life)
	print("Damage received:", damage, "Life remaining:", life)
	if(life <= 0 && !is_dead):
		is_dead = true
		emit_signal("died", )
		anim_player.play("Death")


func _process(delta: float) -> void:
	ShaderUpdate(delta)
		
func ShaderUpdate(delta):
	if is_blinking:
		var material = anim_player.material as ShaderMaterial
		material.set("shader_parameter/blink", 1.0)
		material.set("shader_parameter/blink_time", material.get("shader_parameter/blink_time") + delta)
	else:
		var material = anim_player.material as ShaderMaterial
		material.set("shader_parameter/blink_time", 0.0)




func GetLife(_life):
	heal.play()
	if not is_flashing:
		is_flashing = true
		var material = anim_player.material as ShaderMaterial
		material.set("shader_parameter/damage_flash", 1.0)
		await get_tree().create_timer(flash_duration).timeout
		material.set("shader_parameter/damage_flash", 0.0)
		is_flashing = false
	life += life
	if (life > 100):
		life = 100
	HealthBar.update_health_bar(life)

func attack():
	if (Input.is_action_pressed("attack") && !isAttacking):
		isAttacking = true
		var random_number = randi() % 2 + 1
		if(random_number == 1):
			attackknife_1.play()
		else:
			attackknife_2.play()
		#Ataque de izquierda y/o derecha
		if (direction == "left" || direction == "right"):
			if(random_number == 1):
				anim_player.play("Attack_01")
			else:
				anim_player.play("Attack_02")

func movement(delta):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	move_and_slide()
	footspets_sound(input_direction)
	
func footspets_sound(input_direction):
	if (input_direction.x != 0 || input_direction.y != 0):
		if(!Footsteps.is_playing()):
			Footsteps.play()
func update_animations():
	if velocity.y != 0 && !isAttacking:
		anim_player.play("Run")
	if velocity.x > 0 && !isAttacking:
		AttackShape.scale.x = 1
		anim_player.scale.x = 1;
		anim_player.play("Run")
	if velocity.x < 0 && !isAttacking:
		AttackShape.scale.x = -1
		anim_player.scale.x = -1;
		anim_player.play("Run")
	if (velocity.x == 0 && velocity.y == 0 && !isAttacking):
		anim_player.play("Idle")

func SET_pause_or_end(state):
	pause_or_end = state	

func _on_animated_sprite_2d_animation_finished()-> void:
	if(anim_player.animation == "Attack_01"
	|| anim_player.animation == "Attack_02"):
		for body in enemies_on_stage:
			if has_method("GetDamage"):
				body.GetDamage(player_damage)
				body.velocity += force
		isAttacking = false
		anim_player.play("Idle")	


func _on_hurt_box_area_entered(area:Area2D) -> void:
	if (area.is_in_group("Kit Medic")):
		GetLife(area.get_parent().life)
		area.get_parent().queue_free()
	if area.is_in_group("Area Green"):
		is_in_green_area = true
		damage_timer.start()


func _on_hit_box_body_exited(body:Node2D) -> void:
	if enemies_on_stage.has(body):
		enemies_on_stage.erase(body)


func _on_hit_box_body_entered(body:Node2D)->void:
	if (body.is_in_group("enemies")):
		enemies_on_stage.append(body)



func _on_hurt_box_bullet_area_entered(area: Area2D) -> void:
	if(area.is_in_group("projectile")):
		if(area.get_performer() != name):
			GetDamage(area.damage)
		
	


func _apply_area_damage() -> void:
	if is_in_green_area:
		GetDamage(area_damage)
		HealthBar.update_health_bar(life)
		if(life <= 0 && !is_dead):
			is_dead = true
			emit_signal("died", )
			anim_player.play("Death")


func _on_hurt_box_area_exited(area):
	if area.is_in_group("Area Green"):
		# Salir de la zona verde detiene el daño continuo
		is_in_green_area = false
		damage_timer.stop()
