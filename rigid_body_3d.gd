extends RigidBody3D

@export var ship_resourse: ShipResource


@onready var thrust_curve: Curve = ship_resourse.thrust_curve

@onready var engine_shift_speed = ship_resourse.engine_shift_speed

@onready var engine_on_off: bool = ship_resourse.engine_on_off
@onready var throttle: float = ship_resourse.throttle



@onready var thrust: float = ship_resourse.thrust
@onready var speed_lable = %Label
@onready var throttle_lable = %Label2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(self.get_center_of_mass())
	pass


func _input(event: InputEvent) -> void:
	#print(self.get_center_of_mass())
	
	if event.is_action_pressed("ui_accept"):
		engine_on_off = true
		ship_resourse.engine_on_off = true
		#$GPUParticles3D.emitting = true
		#throttle = 1
	
	if event.is_action_released("ui_accept"):
		engine_on_off = false
		ship_resourse.engine_on_off     = false
		#$GPUParticles3D.emitting = false
		#throttle = 0
	
	if event.is_action_pressed("breaking_thrusters"):
		linear_damp = 1
	
	if event.is_action_released("breaking_thrusters"):
		linear_damp = 0.7
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#var throttle_axis = Input.get_axis("throttle_down", "throttle_up")
	#
	#if throttle_axis:
		#
 		#throttle += throttle_axis * 0.01
		#throttle = clampf(throttle, 0.0, 1.0)
	
	
	



func _physics_process(delta: float) -> void:
	
	
	
	main_engine()
	turn()

#func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
#	step(state)



func main_engine():
	
	var physics_process_delta: float = get_physics_process_delta_time()
	
	if engine_on_off == true:
		
		throttle += engine_shift_speed * physics_process_delta
	
	elif throttle != 0:
		throttle += -(engine_shift_speed*3) * physics_process_delta
	
	throttle = clampf(throttle ,0 ,1)
	ship_resourse.throttle = throttle
	
	
	
	
	
	self.apply_central_force(self.basis.y * ((thrust_curve.sample(throttle) * mass * thrust) * physics_process_delta))
	speed_lable.text = "speed : " + str( int( abs(self.linear_velocity.x) + abs(self.linear_velocity.y) + abs(self.linear_velocity.z)))
	throttle_lable.text = "throttle : " + str(throttle)


func breaking_thrusters():
	
	pass
	
	
	










@onready var camera = %Camera3D
func turn():
	var mouse_position_2d: Vector2 = get_viewport().get_mouse_position()
	var mouse_position_3d: Vector3 = camera.project_position(mouse_position_2d, 1)
	
	#var angle_to_mouse = Vector2(camera.position.x, camera.position.y).angle_to(Vector2(mouse_position_3d.x ,mouse_position_3d.y))
	
	
	var angular_force = Vector2(self.basis.y.x,self.basis.y.y).angle_to(Vector2(mouse_position_3d.x - self.position.x,mouse_position_3d.y - self.position.y))
	#
	
	self.apply_torque((Vector3(0,0, angular_force) * 20000))
	#print(basis.x,"  ",Vector2(self.basis.x.x,self.basis.x.y),"  ",mouse_position_3d.x,"  ", mouse_position_3d.y, "   ", angular_force)
