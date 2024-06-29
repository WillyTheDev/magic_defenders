class_name Skill
extends Node

var identifier: String
var mana_cost: int
var texture_normal: Texture2D
var texture_hover: Texture2D
var texture_focused: Texture2D
var icon_texture: Texture2D
var scene : Resource
var information: String
var type: String
var unlocked : bool
var profession : String


func _init(id, mana_cost, skill_texture_normal, skill_texture_hover, skill_texture_focused,skill_texture_icon, skill_scene, information, type, skill_profession, unlocked):
	self.identifier = id
	self.mana_cost = mana_cost
	self.texture_normal = skill_texture_normal
	self.texture_hover = skill_texture_hover
	self.texture_focused = skill_texture_focused
	self.scene = skill_scene
	self.information = information
	self.type = type
	self.unlocked = unlocked
	self.icon_texture = skill_texture_icon
	self.profession = skill_profession

