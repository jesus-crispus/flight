extends Node3D
@export var start_distance_min : float
@export var start_distance_max : float



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_normal_vector = Vector3(float(randf_range(-1,1)),randf_range(-1,1),0)
	var start_distance = randf_range(start_distance_min,start_distance_max)
	self.position = start_normal_vector * start_distance
	%RigidBody3D2.position = %player_spawn.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
