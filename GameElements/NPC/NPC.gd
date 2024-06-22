extends Node2D

@export var npc_index = 1
@export var npc_texture : Texture2D = null
@export var voice : AudioStream = null
@export var dialog : Array = [""]
@export var starting_animation : String = "idle"
@export var is_unlock = false
@export var urgent_quest_to_unlock = 0
@export var has_notification = false

func _ready():
	print("NPC Index = %s" % npc_index)
	print("is unlocked = %s " % is_unlock)
	print("has_notification = %s" % has_notification)
	%AnimationSprite.play(starting_animation)
	%Sprite.texture = npc_texture
	%AudioStreamPlayer2D.stream = voice
	if Global.urgent_quests_completed >= urgent_quest_to_unlock:
		is_unlock = true
	if is_unlock:
		visible = true
		$Area2D/InteractingZone.disabled = false
		$StaticBody2D/CollisionBody.disabled = false
	else:
		visible = false
		$Area2D/InteractingZone.disabled = true
		$StaticBody2D/CollisionBody.disabled = true
	if has_notification:
		%NotificationLabel.visible = true
	else:
		%NotificationLabel.visible = false
	

func _on_area_2d_body_entered(body):
	if body is Player:
		body.nearest_npc_index = npc_index
		%AnimationDialog.play("show_dialog")
		play_voice()


func _on_area_2d_body_exited(body):
	if body is Player:
		body.nearest_npc_index = 0
		%AnimationDialog.play("hide_dialog")

func play_voice():
	%AudioStreamPlayer2D.play()
