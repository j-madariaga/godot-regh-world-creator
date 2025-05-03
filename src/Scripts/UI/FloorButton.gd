class_name FloorButton
extends PanelContainer

const WEIGHT_ENTRY_OBJ = preload("res://src/Scenes/WeightEntry.tscn");
const EVENT_SCROLL_OBJ = preload("res://src/Scenes/EventScroll.tscn");
const DIALOGUE_ENTRY_OBJ = preload("res://src/Scenes/DialogueEntry.tscn");

@onready var floorTag = $Organizer/HBoxContainer/FloorTag

# Screens
@onready var generalScreen = $Organizer/GeneralInfoData
@onready var mapGenScreen = $Organizer/MapGenData
@onready var eventScreen = $Organizer/EventData
@onready var dialogueScreen = $Organizer/DialogueData

# General data
@onready var floorName = $Organizer/GeneralInfoData/Right/Name/NameInput
@onready var floorDesc = $Organizer/GeneralInfoData/Right/Description/DescInput
@onready var floorImage = $Organizer/GeneralInfoData/Right/Splash/ImageInput

# Map generation
@onready var minLayers = $Organizer/MapGenData/Right/Layers/MinInput
@onready var maxLayers = $Organizer/MapGenData/Right/Layers/MaxInput
@onready var minNodesPerLayer = $Organizer/MapGenData/Right/NPLayer/MinInput
@onready var maxNodesPerLayer = $Organizer/MapGenData/Right/NPLayer/MaxInput
@onready var minPaths = $Organizer/MapGenData/Right/Paths/MinInput
@onready var maxPaths = $Organizer/MapGenData/Right/Paths/MaxInput
@onready var weightList = $Organizer/MapGenData/Left/Weights/ScrollContainer/WeightList	

# Events
@onready var newTypeInput = $Organizer/EventData/Right/EventTypes/TypeInput
@onready var typeTabs = $Organizer/EventData/Right/TypeBar
@onready var eventScrollHolder = $Organizer/EventData/Right/ScrollHolder

# Floor dialogues
@onready var dialogueList = $Organizer/DialogueData/Right/ScrollHolder/DialogueList



func _ready():
	SwitchTab(0);
	UpdateWeightTabs();
	SetEventHolders();
	return;

func SetEventHolders():
	var typeNames = []
	for i in typeTabs.tab_count:
		typeNames.append(typeTabs.get_tab_title(i))
	
	#Additions
	for typeN in typeNames:
		if FindInEventScroll(typeN):
			continue;

		var scroll = EVENT_SCROLL_OBJ.instantiate();
		eventScrollHolder.add_child(scroll);
		scroll.eventType = typeN;
		
		scroll.visible = false;
		if eventScrollHolder.get_child_count() == 1:
			scroll.visible = true;
			
		print(scroll.eventType);
	
	return;

func RemoveNodeType(idx : int = 0):
	typeTabs.remove_tab(idx);
	
	UpdateWeightTabs();
	SetEventHolders();
	return;

func AddNodeType():
	var typeName = newTypeInput.text;
	if typeName == "":
		return;	
	
	typeTabs.add_tab(typeName);

	UpdateWeightTabs();
	SetEventHolders();
	return;

func AddFloorDialogue():
	var dialEntry = DIALOGUE_ENTRY_OBJ.instantiate()
	dialogueList.add_child(dialEntry);
	return;

func FindInEventScroll(label : String) -> bool:
	for i : EventScroll in eventScrollHolder.get_children():
		if i.eventType == label:
			return true;
	return false;

func FindInWeightTable(label : String = "") -> bool:
	for i : NodeWeightEntry in weightList.get_children():
		if i.typeLabel.text == label:
			return true;
	return false;
		
func SwitchEventTab(tabIdx : int = 0):
	for i in typeTabs.tab_count:
		eventScrollHolder.get_child(i).visible = false;
		
	eventScrollHolder.get_child(tabIdx).visible = true;

func UpdateWeightTabs():	
	var typeNames = []
	for i in typeTabs.tab_count:
		typeNames.append(typeTabs.get_tab_title(i));
	
	# Adding tabs
	for n in typeNames:
		
		# Do not alter existing ones
		if FindInWeightTable(n):
			continue;
			
		var weightObj = WEIGHT_ENTRY_OBJ.instantiate() as NodeWeightEntry;
		weightList.add_child(weightObj)
		weightObj.typeLabel.text = n;
		
	# Removal	
	for w : NodeWeightEntry in weightList.get_children():
		if not (typeNames.has(w.typeLabel.text)):
			w.queue_free();
	return;

func SaveJSON() -> Dictionary:
	var floorData = {};
	floorData["info"] = {};
	floorData["info"]["name"] = floorName.text;
	floorData["info"]["description"] = floorDesc.text;
	floorData["info"]["splashImage"] = floorImage.text;
	
	floorData["mapGen"] = {};
	floorData["mapGen"]["layers"] = [int(minLayers.text), int(maxLayers.text)];
	floorData["mapGen"]["nodesPerLayer"] = [int(minNodesPerLayer.text), int(maxNodesPerLayer.text)];
	floorData["mapGen"]["paths"] = [int(minPaths.text), int(maxPaths.text)];
	
	floorData["mapGen"]["nodeWeights"] = {}
	for i in typeTabs.tab_count:
		floorData["mapGen"]["nodeWeights"][typeTabs.get_tab_title(i)] = float(weightList.get_child(i).weightInput.text);
	
	floorData["eventPool"] = {};
	for i in typeTabs.tab_count:
		var evList = eventScrollHolder.get_child(i);
		floorData["eventPool"][typeTabs.get_tab_title(i)] = [];
		
		for ev in evList.get_children():
			floorData["eventPool"][typeTabs.get_tab_title(i)].append(ev.SaveJSON());
		
		
	floorData["dialogues"] = {}
	
	return floorData;
	
func SaveResource() -> FloorResource:
	var floorRes := FloorResource.new();
	floorRes.name = floorName.text;
	floorRes.description = floorDesc.text;
	floorRes.splashImage = floorImage.text;
	
	floorRes.minLayers = int(minLayers.text);
	floorRes.maxLayers = int(maxLayers.text);
	floorRes.minNodesPerLayer = int(minNodesPerLayer.text);
	floorRes.maxNodesPerLayer = int(maxNodesPerLayer.text);	
	floorRes.minNodePaths = int(minPaths.text);
	floorRes.maxNodePaths = int(maxPaths.text);
	
	floorRes.nodeTypeWeights = {}
	for i in typeTabs.tab_count:
		floorRes.nodeTypeWeights[typeTabs.get_tab_title(i)] = float(weightList.get_child(i).weightInput.text);
	
	return floorRes;

func Load(_floorData := {}):
	return;
	
func SwitchTab(tabIdx : int = 0):	
	generalScreen.visible = false;
	mapGenScreen.visible = false;
	eventScreen.visible = false;
	dialogueScreen.visible = false;
	
	match tabIdx:
		0:
			generalScreen.visible = true;
			
		1:
			mapGenScreen.visible = true;
		2:
			eventScreen.visible = true;
		3:
			dialogueScreen.visible = true;
			
	return;
