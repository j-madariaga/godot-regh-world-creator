class_name EventEncounterObj
extends GameEncounterObj

const OPTION_OBJ = preload("res://src/Scenes/Utils/EncounterOptionObj.tscn")

@onready var mainScreen = $MainScreen
@onready var optionsScreen = $OptionContainer

@onready var eventName = $MainScreen/Name/EventName
@onready var descName = $MainScreen/Description/DescInput
@onready var eligibleToggle = $MainScreen/EligibleFromPool
@onready var dialogueList = $MainScreen/Scroll/DialogueList

@onready var optionList = $OptionContainer/OptScroll/OptList


func _ready():
	CloseOptionsTab();
	

func CreateOptionHolder():
	var obj = OPTION_OBJ.instantiate();
	optionList.add_child(obj);

func OpenOptionsTab():
	optionsScreen.visible = true;
	mainScreen.visible = false;
	return;
	
func CloseOptionsTab():
	optionsScreen.visible = false;
	mainScreen.visible = true;
	return;

func AddDialogue():
	var dialEntry = DIAL_ENTRY_OBJ.instantiate();
	dialogueList.add_child(dialEntry);
	return;

func SaveResource() -> EventEncounterResource:
	var res := EventEncounterResource.new();
	res.title = eventName.text;
	res.description = descName.text;
	res.eligible = eligibleToggle.button_pressed;
	
	for ch in dialogueList.get_children():
		res.dialogueData.append(ch.SaveResource());
		
	for opt : EncounterOptionObj in optionList.get_children():
			res.encounterOptions.append(opt.SaveResource());
	
	return res;
	
func LoadResource(res : EventEncounterResource):
	eventName.text = res.title;
	descName.text = res.description;
	eligibleToggle.button_pressed = res.eligible;
	
	for dial in res.dialogueData:
		
		var dialEntry = DIAL_ENTRY_OBJ.instantiate();
		dialogueList.add_child(dialEntry);
		dialEntry.LoadResource(dial);

	for opt in res.encounterOptions:
		var optObj = OPTION_OBJ.instantiate();
		optionList.add_child(optObj);
		optObj.LoadResource(opt);
			
	
