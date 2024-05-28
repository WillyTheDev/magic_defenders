class_name Hat
extends Node

var effect: Callable
var information: String
var texture: Texture2D

func _init(effect_to_apply: Callable, info, texture):
	self.effect = effect_to_apply
	self.information = info
	self.texture = texture

func apply_effect():
	effect.call()
