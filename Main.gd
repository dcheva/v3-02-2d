extends Node2D


func _ready():
	$"StartPosition".set_deferred("position", Vector2(240, 450))
