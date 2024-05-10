class_name EnemyManager
extends Node2D

static var health_factor = 1
static var mana_factor = 1
static var damage_factor = 1
static var speed_factor = 1

signal enemy_modified

func apply_enemy_modification():
	enemy_modified.emit("health")
