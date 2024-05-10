class_name PlayerManager
extends Node2D

static var player_damage_factor = 1
static var player_movement_speed_factor = 1

signal player_modified

func apply_player_modification():
	player_modified.emit()
