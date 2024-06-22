extends Node

func interact_with_npc(npc_index):
	match npc_index:
		0:
			print("Player is not interacting with any NPC")
		1:
			print("Quest giver interactions")
			%SelectMapScreen.show_quests()
		2:
			print("Merchant interactions")
			%Shop.show_shop()
		3:
			print("Challenge interactions")
			%Challenge.show_challenge()
		var _other:
			print("Player is interacting with an useless NPC : %s" % _other)
		

		
