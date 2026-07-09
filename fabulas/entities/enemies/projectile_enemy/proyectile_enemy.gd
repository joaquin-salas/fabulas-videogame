extends CharacterBody2D

@onready var ray: RayCast2D = $RayCast2D
@onready var muzzle: Marker2D = $Muzzle
@onready var cooldown: Timer = $FireCooldown

var player: Node2D = null
var can_fire: bool = true

const PROJECTILE = preload("res://entities/enemies/projectile_enemy/projectile/projectile.tscn")



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null

func _physics_process(_delta):
	if player == null:
		return

	ray.target_position = ray.to_local(player.global_position)
	ray.force_raycast_update()

	if ray.is_colliding() and ray.get_collider() == player:
		if can_fire:
			fire()
			SoundManager.play_sfx("Shot")

func fire():
	can_fire = false
	cooldown.start()
	var proj = PROJECTILE.instantiate()
	proj.direction = (player.global_position - muzzle.global_position).normalized()
	get_tree().current_scene.add_child(proj)
	proj.global_position = muzzle.global_position

func _on_fire_cooldown_timeout():
	can_fire = true	
