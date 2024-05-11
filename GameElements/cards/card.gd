class_name Card
extends Node

var img_path: String
var img_path_hover: String
var img_path_clicked: String
var effect: Callable

func _init(path :String, effect_to_apply: Callable):
	img_path = path % ""
	img_path_hover = path % "_hover"
	img_path_clicked = path % "_clicked"
	effect = effect_to_apply

func apply_effect():
	effect.call()
