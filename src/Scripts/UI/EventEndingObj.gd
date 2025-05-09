class_name EventEndingObj
extends VBoxContainer

const DIALOGUE_ENTRY_OBJ = preload("res://src/Scenes/Utils/DialogueEntry.tscn")

@onready var endingInput = $ScreenTextInput
@onready var endDialogues = $VBoxContainer/Scroll/DialogueList

func AddEndDialogue():
	var dial = DIALOGUE_ENTRY_OBJ.instantiate();
	endDialogues.add_child(dial);

func SaveResource() -> EncounterEndingResource:
	var res := EncounterEndingResource.new();
	res.endScreenText = endingInput.text;
	
	for end in endDialogues.get_children():
		res.endDialogues.append(end.SaveResource())
	
	return res;
	
func LoadResource(res : EncounterEndingResource):
	endingInput.text = res.endScreenText;
	
	for end in res.endDialogues:
		var dial = DIALOGUE_ENTRY_OBJ.instantiate();
		endDialogues.add_child(dial);
		dial.LoadResource(end)
	
	return;
