extends Node2D

@export var npc_index = 1
@export var npc_texture : Texture2D = null
@export var voice : AudioStream = null
@export var dialog : Array = [""]
@export var starting_animation : String = "idle"

func _ready():
	%AnimationSprite.play(starting_animation)
	%Sprite.texture = npc_texture
	%AudioStreamPlayer2D.stream = voice

func _on_area_2d_body_entered(body):
	if body is Player:
		body.is_interacting_with_npc = npc_index
		%AnimationDialog.play("show_dialog")


func _on_area_2d_body_exited(body):
	if body is Player:
		body.is_interacting_with_npc = 0
		%AnimationDialog.play("hide_dialog")
