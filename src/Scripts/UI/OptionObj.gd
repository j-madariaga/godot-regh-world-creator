class_name EncounterOptionObj
extends VBoxContainer

const DICT_ENTRY_OBJ = preload("res://src/Scenes/Utils/DictEntry.tscn");


@onready var imageInput = $Organizer/Left/Image/ImageInput
@onready var endIdxInput = $"Organizer/Left/EndingIndex/EndIdxInput"

@onready var reqList = $Organizer/Right/Requirements/Scroll/ReqList
@onready var actionList = $Organizer/Right/Effects/Scroll/ActionList

func OnClose():
	self.queue_free();


func AddEffect():
	var entry = DICT_ENTRY_OBJ.instantiate();
	actionList.add_child(entry);
	return;
	
func AddRequirement():
	var entry = DICT_ENTRY_OBJ.instantiate();
	reqList.add_child(entry);
	return;
	


func LoadResource(res : EncounterOptionResource):
	imageInput.text = res.imageFilename;
	endIdxInput.value = res.endIdx;
	
	for req in res.requirements:
		var entry = DICT_ENTRY_OBJ.instantiate();
		reqList.add_child(entry); 
		entry.LoadResource(req);
		
	for act in res.actions:
		var entry = DICT_ENTRY_OBJ.instantiate();
		actionList.add_child(entry); 
		entry.LoadResource(act);
	
	return;
	
func SaveResource() -> EncounterOptionResource:
	var res := EncounterOptionResource.new();
	res.imageFilename = imageInput.text;
	res.endIdx = endIdxInput.value;
	
	res.requirements = []
	for entry in reqList.get_children():
		entry.SaveResource(res.requirements);
	
	res.actions = []
	for entry in actionList.get_children():
		entry.SaveResource(res.actions);
	
	return res;
