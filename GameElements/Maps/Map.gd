class_name Map
extends Node2D

@export var paths : Array[Path2D] = []
@export var flyingSpawnPoint: PathFollow2D = null
## Set the difficulty of the map lower the difficulty value is, higher the real difficulty
@export var player_starting_mana = 30

@export var map_index = 1
@export var chapter_index = 1
@export var is_hub = false

var sequences : Array[Array]

func _ready():
		sequences = _parse_sequence(Global.sequences)
			

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


