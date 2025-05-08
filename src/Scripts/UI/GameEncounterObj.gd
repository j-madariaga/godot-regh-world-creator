class_name GameEncounterObj
extends PanelContainer

const DIAL_ENTRY_OBJ = preload("res://src/Scenes/Utils/DialogueEntry.tscn")

func OnClose():
	self.queue_free();

func LoadJSON(_data := {}):
	return;
	
func SaveJSON():
	return;
	

func LoadResource(_data):
	return;
	
func SaveResource():
	return;
