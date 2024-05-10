class_name TurretDefenseManager
extends Node2D

static var turret_health = 5
static var turret_fire_rate = 1.5
static var turret_damage = 1
static var turret_nb_projectile = 1
static var turret_price = 20

signal turret_modified

static var defense_health = 20
static var defense_price = 10

signal defense_modified

#Special Defense Effect
static var defense_counter_attack = false
static var defense_health_regeneration = false

func apply_turret_modification():
	turret_modified.emit()

func apply_defense_modification():
	defense_modified.emit()

