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
	print(self.get_center_of_mass())
pass

func _input(event: InputEvent) -> void:
	print(self.get_center_of_mass())
	
	if event.is_action_pressed("ui_accept"):
		engine_on_off = true
		#throttle = 1
	
	if event.is_action_released("ui_accept"):
		engine_on_off = false
		#throttle = 0
	
	if event.is_action_pressed("breaking_thrusters"):
		linear_damp = 1
	
	if event.is_action_released("breaking_thrusters"):
		linear_damp = 0
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#var throttle_axis = Input.get_axis("throttle_down", "throttle_up")
	#
	#if throttle_axis:
		#
		#print(throttle)
		#throttle += throttle_axis * 0.01
		#throttle = clampf(throttle, 0.0, 1.0)
	
	
	



func _physics_process(delta: float) -> void:
	
	main_engine()
	turn()


func main_engine():
	
	if engine_on_off == true:
		
		throttle += engine_shift_speed * get_physics_process_delta_time()
	
	elif throttle != 0:
		throttle += -engine_shift_speed * get_physics_process_delta_time()
	
	throttle = clampf(throttle ,0 ,1)
	
	self.apply_central_force(self.basis.x * (thrust_curve.sample(throttle) * mass * thrust))
	speed_lable.text = "speed : " + str( int(abs(self.linear_velocity.x) + abs(self.linear_velocity.y) + abs(self.linear_velocity.z)))
	throttle_lable.text = "throttle : " + str(throttle)


func breaking_thrusters():
	
	pass
	
	
	










@onready var camera = %Camera3D
func turn():
	var mouse_position_2d: Vector2 = get_viewport().get_mouse_position()
	var mouse_position_3d: Vector3 = camera.project_position(mouse_position_2d, 1)
	
	#var angle_to_mouse = Vector2(camera.position.x, camera.position.y).angle_to(Vector2(mouse_position_3d.x ,mouse_position_3d.y))
	
	
	var angular_force = Vector2(self.basis.x.x,self.basis.x.y).angle_to(Vector2(mouse_position_3d.x - self.position.x,mouse_position_3d.y - self.position.y))
	#
	
	self.apply_torque((Vector3(0,0, angular_force) * 20000))
	#print(basis.x,"  ",Vector2(self.basis.x.x,self.basis.x.y),"  ",mouse_position_3d.x,"  ", mouse_position_3d.y, "   ", angular_force)
