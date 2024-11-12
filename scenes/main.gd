extends Node

@export var Scene = preload("res://scenes/level_1.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reset():
	var instance = Scene.instantiate()
	self.add_child(instance)
	%MainMenu.hide()

func main_menu():
	%MainMenu.show
