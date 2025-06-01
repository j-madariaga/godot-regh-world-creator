class_name EventEncounterObj
extends GameEncounterObj

const OPTION_OBJ = preload("res://src/Scenes/Utils/EncounterOptionObj.tscn")
const ENDING_OBJ = preload("res://src/Scenes/Utils/EventEndingObj.tscn")

@onready var mainScreen = $Organizer/MainScreen
@onready var optionsScreen = $Organizer/OptionContainer
@onready var endingScreen = $Organizer/EndingScreen


@onready var eligibleToggle = $Organizer/MainScreen/EligibleFromPool
@onready var dialogueList = $Organizer/MainScreen/Scroll/DialogueList

@onready var optionList = $Organizer/OptionContainer/OptScroll/OptList
@onready var endingList = $Organizer/EndingScreen/Scroll/Endings

func _ready():
	SwitchTab(0);

func SwitchTab(idx : int = 0):
	mainScreen.visible = false;
	optionsScreen.visible = false;
	endingScreen.visible = false;
	
	match idx:
		0:
			mainScreen.visible = true;	
		1:
			optionsScreen.visible = true;	
		2:
			endingScreen.visible = true;	
	return;

func AddEnding():
	var end = ENDING_OBJ.instantiate();
	endingList.add_child(end);
	

func CreateOptionHolder():
	var obj = OPTION_OBJ.instantiate();
	optionList.add_child(obj);

func AddDialogue():
	var dialEntry = DIAL_ENTRY_OBJ.instantiate();
	dialogueList.add_child(dialEntry);
	return;

func SaveResource() -> EventEncounterResource:
	var res := EventEncounterResource.new();
	res.eligible = eligibleToggle.button_pressed;
	
	for ch in dialogueList.get_children():
		res.dialogueData.append(ch.SaveResource());
		
	for opt : EncounterOptionObj in optionList.get_children():
			res.encounterOptions.append(opt.SaveResource());
			
	for end : EventEndingObj in endingList.get_children():
			res.encounterEndings.append(end.SaveResource())
	
	return res;
	
func LoadResource(res : EventEncounterResource):
	eligibleToggle.button_pressed = res.eligible;
	
	for dial in res.dialogueData:
		
		var dialEntry = DIAL_ENTRY_OBJ.instantiate();
		dialogueList.add_child(dialEntry);
		dialEntry.LoadResource(dial);

	for opt in res.encounterOptions:
		var optObj = OPTION_OBJ.instantiate();
		optionList.add_child(optObj);
		optObj.LoadResource(opt);
		
	for end in res.encounterEndings:
		var endObj = ENDING_OBJ.instantiate();
		endingList.add_child(endObj);
		endObj.LoadResource(end);
			
	
