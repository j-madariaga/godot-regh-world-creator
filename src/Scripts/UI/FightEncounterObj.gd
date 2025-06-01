class_name FightEncounterObj
extends GameEncounterObj

@onready var bgName = $VBoxContainer/Background/BackgroundName
@onready var enemyNameInput = $VBoxContainer/Resource/EnemyName
@onready var dialogueList = $VBoxContainer/Scroll/DialogueList
@onready var eligibleToggle = $VBoxContainer/EligibleFromPool

func AddDialogue():
	var dialEntry = DIAL_ENTRY_OBJ.instantiate();
	dialogueList.add_child(dialEntry);
	return;

func SaveResource() -> FightEncounterResource:
	var res := FightEncounterResource.new();
	
	res.enemyResourceName = enemyNameInput.text;
	res.eligible = eligibleToggle.button_pressed;
	res.backgroundFilename = bgName.text;
	
	for ch in dialogueList.get_children():
		res.dialogueData.append(ch.SaveResource());
	return res;
	
func LoadResource(res : FightEncounterResource):

	enemyNameInput.text = res.enemyResourceName;
	eligibleToggle.button_pressed = res.eligible;
	bgName.text = res.backgroundFilename;
	
	for dial in res.dialogueData:
		
		var dialEntry = DIAL_ENTRY_OBJ.instantiate();
		dialogueList.add_child(dialEntry);
		dialEntry.LoadResource(dial);

	
