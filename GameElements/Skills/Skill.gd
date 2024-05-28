class_name Skill
extends Node

var mana_cost: int
var texture_normal: Texture2D
var texture_hover: Texture2D
var scene : Resource
var information: String
var type: String
var level_required : int

func _init(mana_cost, skill_texture_normal, skill_texture_hover, skill_scene, information, type, level_required):
	self.mana_cost = mana_cost
	self.texture_normal = skill_texture_normal
	self.texture_hover = skill_texture_hover
	self.scene = skill_scene
	self.information = information
	self.type = type
	self.level_required = level_required


