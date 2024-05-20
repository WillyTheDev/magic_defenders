extends Node2D

func setHat(hat_index):
	%Hat.texture = load("res://Assets/hats/hat_%s.png" % hat_index)

func play_animation_idle():
	%AnimationPlayer.play("idle")
	
func play_animation_walk():
	%AnimationPlayer.play("walk")

func play_animation_levelup():
	%AnimationPlayer.play("level_up")

func _ready():
	play_animation_idle()
