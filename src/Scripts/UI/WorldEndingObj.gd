class_name WorldEndingObj
extends PanelContainer

const DIAL_ENTRY_OBJ = preload("res://src/Scenes/Utils/DialogueEntry.tscn")

@onready var titleInput = $Organizer/Title/TitleInput
@onready var bgNameInput = $Organizer/BackgroundImage/ImageInput
@onready var descInput = $Organizer/Description/DescInput

@onready var dialogueList = $Organizer/Dialogues/Scroll/DialogueList

func AddDialogue():
	var dial = DIAL_ENTRY_OBJ.instantiate()
	dialogueList.add_child(dial)

func OnClose():
	self.queue_free();
	
func SaveResource() -> WorldEndingResource:
	var res := WorldEndingResource.new();
	res.title = titleInput.text;
	res.backgroundFilename = bgNameInput.text;
	res.description = descInput.text;
	
	for dial in dialogueList.get_children():
		res.endingDialogues.append(dial.SaveResource())
	
	return res;
	
func LoadResource(res : WorldEndingResource):
	titleInput.text = res.title;
	bgNameInput.text = res.backgroundFilename;
	descInput.text = res.description;
	
	for dial in res.endingDialogues:
		var entry = DIAL_ENTRY_OBJ.instantiate()
		dialogueList.add_child(entry)
		entry.LoadResource(dial)
	
	return;
	
