class_name TutorialManager
extends MarginContainer

func _ready():
	print("Objective : \nTutorials size = %s" % tutorials.size())
	if Global.tutorial_steps >= tutorials.size():
		print("Deleting Tutorials !")
		queue_free()
	else:
		load_tutorial_step(Global.tutorial_steps)
	
func _process(delta):
	tutorials[Global.tutorial_steps].processCallable.call()

func load_tutorial_step(step:int):
	%TutorialAnimation.play("Valid_quest")
	await %TutorialAnimation.animation_finished
	%TutorialLabel.text = tutorials[Global.tutorial_steps].text
	%TutorialAnimation.play("show_quest")
	
	
var tutorials = [
	Tutorial.new("[u][b]Objective :[/b][/u] \n Move your character [right][b]0/1[/b][/right]
	", func ():
		if Input.get_vector("move_left", "move_right", "move_up", "move_down") != Vector2(0,0):
			Global.tutorial_steps += 1
			load_tutorial_step(Global.tutorial_steps)
			print("Is urgent quest ?! %s" % Global.is_urgent_quest)
			return true
		),
	Tutorial.new("[u][b]Objective :[/b][/u] \nGet a new Quest from Harold 
	[img width=42 height=42]res://Assets/loots/Harold.png[/img] [right][b]0/1[/b][/right]
	", func ():
		if Global.is_urgent_quest == true:
			Global.tutorial_steps += 1
			load_tutorial_step(Global.tutorial_steps)
			return true
		),
	Tutorial.new("[u][b]Objective :[/b][/u] \nshoot with your wand
	[img width=30 height=30]res://Assets/UI/input/tile_0111.png[/img]
	 [right][b]0/1[/b][/right]
	", func ():
		if Input.is_action_just_pressed("left_click"):
			Global.tutorial_steps += 1
			load_tutorial_step(Global.tutorial_steps)
			return true
		),
	Tutorial.new("[u][b]Objective :[/b][/u] \nreload your wand
	[img width=30 height=30]res://Assets/UI/input/tile_0088.png[/img]
	 [right][b]0/1[/b][/right]
	", func ():
		if Input.is_action_just_pressed("reload"):
			Global.tutorial_steps += 1
			load_tutorial_step(Global.tutorial_steps)
			return true
		),
	Tutorial.new("[u][b]Objective :[/b][/u] \nPlace a Defense 
	[img width=80 height=42]res://Assets/Defense/defense.png[/img] [right][b]0/1[/b][/right]", func ():
		if Input.is_action_just_pressed("skill_1"):
			Global.tutorial_steps += 1
			load_tutorial_step(Global.tutorial_steps)
			return true
		),
	Tutorial.new("[u][b]Objective :[/b][/u] \nPlace a Turret 
	[img width=80 height=42]res://Assets/Defense/turret.png[/img] [right][b]0/1[/b][/right]", func ():
		if Input.is_action_just_pressed("skill_2"):
			Global.tutorial_steps += 1
			load_tutorial_step(Global.tutorial_steps)
			return true
		),
	Tutorial.new("[u][b]Objective :[/b][/u] \n Earn 20 mana to level up ! [right][b]0/1[/b][/right]", func ():
	if Global.player_level == 2:
		Global.tutorial_steps += 1
		load_tutorial_step(Global.tutorial_steps)
		return true
	),
	Tutorial.new("[u][b]Objective :[/b][/u] \nSurvive until wave 4 [right][b]0/1[/b][/right]", func ():
		if $/root/Game.current_wave >= 4:
			Global.tutorial_steps += 1
			load_tutorial_step(Global.tutorial_steps)
			return true
		),
	Tutorial.new("[u][b]Objective :[/b][/u] \nProtect the core against the bat 
	[img width=70 height=42]res://Assets/Ennemies/bat.png[/img] [right][b]0/1[/b][/right]", func ():
		if $/root/Game.current_wave >= 5:
			Global.tutorial_steps += 1
			load_tutorial_step(Global.tutorial_steps)
			return true
		),
	Tutorial.new("[u][b]Objective :[/b][/u] \nProtect the core against Ghost slime 
	[img width=42 height=42]res://Assets/Ennemies/Slime_v2_ghost.png[/img] [right][b]0/1[/b][/right]", func ():
		if $/root/Game.current_wave >= 6:
			Global.tutorial_steps += 1
			load_tutorial_step(Global.tutorial_steps)
			return true
		),
	Tutorial.new("[u][b]Objective :[/b][/u] \nSurvive 10 waves ! [right][b]0/1[/b][/right]", func ():
		if $/root/Game.current_wave >= 10:
			Global.tutorial_steps += 1
			print("Deleting Tutorials !")
			queue_free()
		),
]
