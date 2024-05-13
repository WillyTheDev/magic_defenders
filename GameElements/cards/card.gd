class_name Card
extends Node

var img_path: String
var img_path_hover: String
var img_path_clicked: String
var effect: Callable
var is_unique : bool

func _init(path :String,unique : bool, effect_to_apply: Callable):
	img_path = path % ""
	img_path_hover = path % "_hover"
	img_path_clicked = path % "_clicked"
	effect = effect_to_apply
	is_unique = unique

func apply_effect():
	effect.call()
