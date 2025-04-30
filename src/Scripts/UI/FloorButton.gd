class_name FloorButton
extends PanelContainer

const WEIGHT_ENTRY_OBJ = preload("res://src/Scenes/WeightEntry.tscn")
const EVENT_SCROLL_OBJ = preload("res://src/Scenes/EventScroll.tscn");

@onready var floorTag = $Organizer/HBoxContainer/FloorTag

@onready var generalScreen = $Organizer/GeneralInfoData
@onready var mapGenScreen = $Organizer/MapGenData
@onready var eventScreen = $Organizer/EventData

@onready var floorName = $Organizer/GeneralInfoData/Right/Name/NameInput
@onready var floorDesc = $Organizer/GeneralInfoData/Right/Description/DescInput
@onready var minLayers = $Organizer/MapGenData/Right/Layers/MinInput
@onready var maxLayers = $Organizer/MapGenData/Right/Layers/MaxInput
@onready var minNodesPerLayer = $Organizer/MapGenData/Right/NPLayer/MinInput
@onready var maxNodesPerLayer = $Organizer/MapGenData/Right/NPLayer/MaxInput
@onready var minPaths = $Organizer/MapGenData/Right/Paths/MinInput
@onready var maxPaths = $Organizer/MapGenData/Right/Paths/MaxInput
@onready var weightList = $Organizer/MapGenData/Left/Weights/ScrollContainer/WeightList	

@onready var newTypeInput = $Organizer/EventData/Right/EventTypes/TypeInput
@onready var typeTabs = $Organizer/EventData/Right/TypeBar

@onready var eventScrollHolder = $Organizer/EventData/Right/ScrollHolder

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

func Save() -> Dictionary:
	var floorData = {};
	floorData["info"] = {};
	floorData["info"]["name"] = floorName.text;
	floorData["info"]["description"] = floorDesc.text;
	
	floorData["mapGen"] = {};
	floorData["mapGen"]["layers"] = [int(minLayers.text), int(maxLayers.text)];
	floorData["mapGen"]["nodesPerLayer"] = [int(minNodesPerLayer.text), int(maxNodesPerLayer.text)];
	floorData["mapGen"]["paths"] = [int(minPaths.text), int(maxPaths.text)];
	
	floorData["eventPool"] = {};
	for i in typeTabs.tab_count:
		floorData["eventPool"][typeTabs.get_tab_title(i)] = [];

	floorData["dialogues"] = {}
	
	return floorData;
	
func Load(_floorData := {}):
	return;
	
func SwitchTab(tabIdx : int = 0):	
	generalScreen.visible = false;
	mapGenScreen.visible = false;
	eventScreen.visible = false;
	
	match tabIdx:
		0:
			generalScreen.visible = true;
			
		1:
			mapGenScreen.visible = true;
		2:
			eventScreen.visible = true;
	return;
