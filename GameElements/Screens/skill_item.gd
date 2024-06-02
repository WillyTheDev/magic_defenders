extends TextureButton

var price = 0
var skill : Skill = null
signal unlocked_skill

func _ready():
	tooltip_text = skill.information
	%item.texture = skill.texture_normal
	%Amount.text = "%s" % price
	



func _on_pressed():
	if Global.accumulated_gold >= price:
		print("Skill Button is pressed !")
		Global.unlocked_skills[skill.identifier] = true
		Global.accumulated_gold -= price
		unlocked_skill.emit()
