class_name EventEndingObj
extends VBoxContainer

const DIALOGUE_ENTRY_OBJ = preload("res://src/Scenes/Utils/DialogueEntry.tscn")

@onready var endDialogues = $VBoxContainer/Scroll/DialogueList

func OnClose():
	self.queue_free();

func AddEndDialogue():
	var dial = DIALOGUE_ENTRY_OBJ.instantiate();
	endDialogues.add_child(dial);

func SaveResource() -> EncounterEndingResource:
	var res := EncounterEndingResource.new();
	
	for end in endDialogues.get_children():
		res.endDialogues.append(end.SaveResource())
	
	return res;
	
func LoadResource(res : EncounterEndingResource):
	
	for end in res.endDialogues:
		var dial = DIALOGUE_ENTRY_OBJ.instantiate();
		endDialogues.add_child(dial);
		dial.LoadResource(end)
	
	return;
