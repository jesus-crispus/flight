extends Area3D

@export var thrust: float
@export var curve: Curve
#@export var thrust
#@export var thrust

@onready var rigid_body: RigidBody3D = get_parent()
@onready var ship_resourse: ShipResource = get_parent().ship_resourse


@onready var particle_system: GPUParticles3D = $GPUParticles3D
@onready var liniar_damp = (1 - ProjectSettings.get_setting("physics/3d/default_linear_damp") ) / ProjectSettings.get_setting("physics/common/physics_ticks_per_second")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ship_resourse.changed:
		
		var throttle: float = ship_resourse.throttle
		
		#particle_system.emitting = ship_resourse.engine_on_off
		
		$OmniLight3D.update_range(throttle)
		$SpotLight3D.update_range(throttle)
		$SpotLight3D2.update_range(throttle)
		$SpotLight3D3.update_range(throttle)
		
		particle_system.amount_ratio = throttle 



func _physics_process(delta: float) -> void:
	
	
	
	
	var future_basis: Basis = rigid_body.basis
	var future_position_offset: Vector3
	
	future_position_offset += (rigid_body.linear_velocity) * delta
	future_basis.rotated(Vector3(0,0,1),rigid_body.angular_velocity.z * delta)
	
	var particle_system_offset: Vector3 = -future_position_offset + rigid_body.position
	
	particle_system_offset += future_basis * self.position
	
	#print(future_basis.y * self.position)
	
	particle_system.position = particle_system_offset
	particle_system.basis = rigid_body.basis
