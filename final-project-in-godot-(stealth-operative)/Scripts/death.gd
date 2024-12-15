extends State
class_name DeathState

@onready var animated_boss = $"../../AnimatedSprite2D"
@onready var explosion = $"../../Explosion"
@onready var ligth_enemy = $"../../AnimatedSprite2D/Ligth Enemy"
@onready var hurt_box = $"../../HurtBox"



func enter():
	super.enter()
	explosion.play()
	ligth_enemy.visible = false
	animated_boss.play("Boss Death")
	await animated_boss.animation_finished
	hurt_box.set_deferred("disabled", true)
