class_name Map
extends Node2D

@export var paths : Array[Path2D] = []
@export var flyingSpawnPoint: PathFollow2D = null
## Set the difficulty of the map lower the difficulty value is, higher the real difficulty
@export var enemy_health_increment : int = 1
@export var enemy_speed_increment : int = 20
@export var starting_spawn_rate : float = 2
@export var unparsed_easy_sequences : Array[String]
@export var unparsed_medium_sequences : Array[String]
@export var unparsed_hard_sequences : Array[String]
@export var win_hat_index : int = 1
@export var player_starting_mana = 30

@export var map_index = 1
@export var chapter_index = 1
@export var is_hub = false

var sequences : Array[Array]

func _ready():
	match Global.selected_difficulty:
		1:
			sequences = _parse_sequence(unparsed_easy_sequences)
		2:
			sequences = _parse_sequence(unparsed_medium_sequences)
		3:
			sequences = _parse_sequence(unparsed_hard_sequences)
			

func _parse_sequence(sequences: Array[String]):
	var parsed_sequences : Array[Array]
	for i in range(sequences.size()):
		# "2x2,3x1" => ["2x2","3x1"]
		var splited_sequences = Array(sequences[i].rsplit(","))
		var string_parsed_sequence = Array()
		for j in range(splited_sequences.size()):
			#["2x2"] => [ "2","2"]
			var x = Array(splited_sequences[j].rsplit("x"))
			string_parsed_sequence.append_array(x)
		var parsed_sequence = Array()
		for j in range(string_parsed_sequence.size()):
			parsed_sequence.append(string_parsed_sequence[j] as int)
		parsed_sequences.append(parsed_sequence)
	return parsed_sequences


