class_name Hat
extends Node

var effect: Callable
var information: String

func _init(effect_to_apply: Callable, info):
	effect = effect_to_apply
	information = info

func apply_effect():
	effect.call()
