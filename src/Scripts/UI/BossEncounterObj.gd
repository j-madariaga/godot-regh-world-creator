class_name BossEncounterObj
extends GameEncounterObj

@onready var eventName = $VBoxContainer/Name/EventName
@onready var descName = $VBoxContainer/Description/DescInput
@onready var enemyNameInput = $VBoxContainer/Resource/EnemyName
@onready var dialogueList = $VBoxContainer/Scroll/DialogueList
@onready var eligibleToggle = $VBoxContainer/EligibleFromPool


func AddDialogue():
	var dialEntry = DIAL_ENTRY_OBJ.instantiate();
	dialogueList.add_child(dialEntry);
	return;

func SaveResource() -> BossEncounterResource:
	var res := BossEncounterResource.new();
	res.title = eventName.text;
	res.description = descName.text;
	res.enemyResourceName = enemyNameInput.text;
	res.eligible = eligibleToggle.button_pressed;
		
	for ch in dialogueList.get_children():
		res.dialogueData.append(ch.SaveResource());
	return res;
	
func LoadResource(res : BossEncounterResource):
	eventName.text = res.title;
	enemyNameInput.text = res.enemyResourceName;
	eligibleToggle.button_pressed = res.eligible;
	
	for dial in res.dialogueData:
		
		var dialEntry = DIAL_ENTRY_OBJ.instantiate();
		dialogueList.add_child(dialEntry);
		dialEntry.LoadResource(dial);

	
