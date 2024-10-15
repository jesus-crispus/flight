extends Node3D



var projectile_packed_scene: PackedScene = preload("res://scenes/projectile.tscn")
var reload_time: float
var fire_rate: float
var magazine_size: int
var curent_magazine: int
@export var cooldown_time: float
var cooling_down: bool
var firing: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$Timer.wait_time = cooldown_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if firing == true:
		fire()
	


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("fire_gun"):
			firing = true
	
	if event.is_action_released("fire_gun"):
			firing = false


func fire():
	if cooling_down == false:
		
		
		
		var projectile = instanciate_projectile()
		projectile.transform = %projectile_spawn_point.global_transform
		$Timer.start()
		
		cooling_down = true
		


func instanciate_projectile() -> Node3D:
	var projectile = projectile_packed_scene.instantiate()
	self.add_child(projectile)
	projectile.basis = self.global_basis
	projectile.apply_central_impulse(get_parent().linear_velocity)
	projectile.apply_central_impulse(projectile.basis.y * 100)
	#projectile.set_angular_velocity(get_parent().get_angular_velocity())
	
	return projectile


func _on_timer_timeout() -> void:
	cooling_down = false
