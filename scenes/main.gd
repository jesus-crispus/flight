extends Node

<<<<<<< Updated upstream
@export var Scene = preload("res://scenes/level_1.tscn")
=======
@export var Scene : PackedScene
>>>>>>> Stashed changes
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
func reset():
	var instance = Scene.instantiate()
	self.add_child(instance)
	%MainMenu.hide()
	%MeshInstance3D.hide()
	

func main_menu():
	%MainMenu.show()
	%MeshInstance3D.show()


func _on_check_box_toggled(toggled_on: bool) -> void:
	Global.high_graphics = toggled_on
