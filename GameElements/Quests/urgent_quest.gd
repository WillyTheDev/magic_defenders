class_name UrgentQuest
extends Node

var identifier : String = "0"
var difficulty = 1
var waves_to_completed : int = 10
var map_of_quest_index : int = 0
var is_day : bool = true
var is_urgent : bool = false
var enemy_sequence : Array = [""]
var reward_texture : Texture = null
var required_quests_completed : int = 0
var has_been_completed : bool = false

func _init(id, quest_difficulty, waves, map_index, day, sequence, required_quest, reward_texture):
	self.identifier = id
	self.difficulty = quest_difficulty
	self.waves_to_completed = waves
	self.map_of_quest_index = map_index
	self.is_day = day
	self.is_urgent = true
	self.enemy_sequence = sequence
	self.required_quests_completed = required_quest
	self.has_been_completed = false
	self.reward_texture = reward_texture
	
