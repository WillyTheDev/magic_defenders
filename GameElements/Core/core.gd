class_name Core
extends Defense

signal core_destroyed
signal core_attacked

func abstract_final_action():
	destroy_core()

		
func destroy_core():
	core_destroyed.emit()
	
