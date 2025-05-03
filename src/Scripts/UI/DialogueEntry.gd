class_name DialogueEntry;
extends Panel

@onready var dialName = $Organizer/Name/NameInput
@onready var triggerChance = $Organizer/TriggerChance/TriggerChance
@onready var autoSkip = $Organizer/AutoSkip

func Load(_data : Variant = null):
	if _data == null:
		return;
	return;
	
func LoadJSON(data := {}):
	dialName.text = data["internalName"];
	triggerChance.text = str(data["triggerChance"]);
	autoSkip.button_pressed = data["autoSkip"];
	return;
		
func LoadResource(dialData : DialogueInfo):
	dialName.text = dialData.internalName;
	triggerChance.text = dialData.triggerChance;
	autoSkip.button_pressed = dialData.autoSkip;
	return;
	
func SaveJSON() -> Dictionary:
	var data := {};
	data["internalName"] = dialName.text;
	data["triggerChance"] = int(triggerChance.text);
	data["autoSkip"] = autoSkip.button_pressed;
	return data;

func SaveResource() -> DialogueInfo:
	var dial := DialogueInfo.new();
	dial.internalName = dialName.text;
	dial.triggerChance = int(triggerChance.text);
	dial.autoSkip = autoSkip.button_pressed;
	return dial;
