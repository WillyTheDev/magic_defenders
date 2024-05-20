class_name Map
extends Node2D

@export var paths : Array[Path2D] = []
@export var flyingSpawnPoint: PathFollow2D = null
## Set the difficulty of the map lower the difficulty value is, higher the real difficulty
@export var difficulty : int = 30
@export var enemy_health_increment : int = 1

@export var min_wave_star_1 = 5.0
@export var min_wave_star_2 = 10.0
@export var min_wave_star_3 = 15.0

@export var map_index = 1
@export var chapter_index = 1

@export var flying_enemy_start_wave = 1
@export var medium_enemy_start_wave = 5
@export var hard_enemy_start_wave = 10
