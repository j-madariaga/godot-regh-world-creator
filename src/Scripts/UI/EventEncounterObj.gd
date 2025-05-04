class_name EventEncounterObj
extends GameEncounterObj

@onready var mainScreen = $MainScreen
@onready var optionsScreen = $OptionContainer

@onready var eventName = $MainScreen/Name/EventName
@onready var descName = $MainScreen/Description/DescInput
@onready var eligibleToggle = $MainScreen/EligibleFromPool
@onready var dialogueList = $MainScreen/Scroll/DialogueList

func _ready():
	CloseOptionsTab();
	
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
	return res;
	
func LoadResource(res : EventEncounterResource):
	eventName.text = res.title;
	eligibleToggle.button_pressed = res.eligible;
	
	for dial in res.dialogueData:
		
		var dialEntry = DIAL_ENTRY_OBJ.instantiate();
		dialogueList.add_child(dialEntry);
		dialEntry.LoadResource(dial);

	
