extends Node2D


func play_animation_idle():
	%AnimationPlayer.play("idle")
	
func play_animation_walk():
	%AnimationPlayer.play("walk")

func _ready():
	play_animation_idle()
