class_name Follower
extends CharacterBody2D

@export var speed = 0.1

func _process(delta):
	get_parent().progress_ratio += delta * speed
	
func no_longer_attacking_defense():
	speed = 0.1
