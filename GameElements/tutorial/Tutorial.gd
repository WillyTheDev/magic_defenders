class_name Tutorial
extends Node

var processCallable: Callable
var text: String

func _init(text:String,process: Callable,):
	self.processCallable = process
	self.text = text

 
