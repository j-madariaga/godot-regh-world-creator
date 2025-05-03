class_name FightEncounterObj
extends GameEncounterObj

const DIAL_ENTRY_OBJ = preload("res://src/Scenes/DialogueEntry.tscn")

@onready var eventName = $VBoxContainer/Name/EventName
@onready var descName = $VBoxContainer/Description/DescInput
@onready var enemyNameInput = $VBoxContainer/Resource/EnemyName
@onready var dialogueList = $VBoxContainer/Scroll/DialogueList

func AddDialogue():
	var dialEntry = DIAL_ENTRY_OBJ.instantiate();
	dialogueList.add_child(dialEntry);
	return;

func SaveResource() -> FightEncounterResource:
	var res := FightEncounterResource.new();
	res.title = eventName.text;
	res.description = descName.text;
	res.enemyResourceName = enemyNameInput.text;
	
	for ch in dialogueList.get_children():
		res.dialogueData.append(ch.SaveResource());
	return res;
	
func LoadResource(res : FightEncounterResource):
	eventName.text = res.title;
	enemyNameInput.text = res.enemyResourceName;
	
	for dial in res.dialogueData:
		
		var dialEntry = DIAL_ENTRY_OBJ.instantiate();
		dialogueList.add_child(dialEntry);
		dialEntry.LoadResource(dial);

	
