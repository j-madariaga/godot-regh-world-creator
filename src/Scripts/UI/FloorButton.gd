class_name FloorButton
extends PanelContainer

const WEIGHT_ENTRY_OBJ = preload("res://src/Scenes/Utils/WeightEntry.tscn");
const EVENT_SCROLL_OBJ = preload("res://src/Scenes/Utils/EventScroll.tscn");
const DIALOGUE_ENTRY_OBJ = preload("res://src/Scenes/Utils/DialogueEntry.tscn");

@onready var floorTag = $Organizer/HBoxContainer/FloorTag

# Screens
@onready var generalScreen = $Organizer/GeneralInfoData
@onready var mapGenScreen = $Organizer/MapGenData
@onready var eventScreen = $Organizer/EventData
@onready var dialogueScreen = $Organizer/DialogueData

# General data
@onready var floorImage = $Organizer/GeneralInfoData/Right/Splash/ImageInput
@onready var musicTrackName = $Organizer/GeneralInfoData/Left/Music/MusicInput

# Map generation
@onready var minLayers = $Organizer/MapGenData/Right/Layers/MinInput
@onready var maxLayers = $Organizer/MapGenData/Right/Layers/MaxInput
@onready var minNodesPerLayer = $Organizer/MapGenData/Right/NPLayer/MinInput
@onready var maxNodesPerLayer = $Organizer/MapGenData/Right/NPLayer/MaxInput
@onready var weightList = $Organizer/MapGenData/Left/Weights/ScrollContainer/WeightList	

@onready var layerWeights = $Organizer/MapGenData/Right/LayersWeight/ScrollContainer/WeightList
@onready var nplWeights = $Organizer/MapGenData/Right/NPLayerWeight/ScrollContainer/WeightList

@onready var mapGenRulesInput = $Organizer/MapGenData/Left/AdditionalRules/ScriptInput

# Events
@onready var newTypeInput = $Organizer/EventData/Right/EventTypes/TypeInput
@onready var typeTabs = $Organizer/EventData/Right/TypeBar
@onready var eventScrollHolder = $Organizer/EventData/Right/ScrollHolder

# Floor dialogues
@onready var dialogueList = $Organizer/DialogueData/Right/ScrollHolder/DialogueList

func OnClose():
	self.queue_free();

func _ready():
	SwitchTab(0);
	SwitchEventTab(0);
	UpdateWeightTabs();
	SetEventHolders();
	return;

func AddMapGenWeightEntry(_value : float = 0.0, type : int = 0):
	match type:
		0: # Layers
			
			
			var count  = int(maxLayers.value) - int(minLayers.value) + 1
			
			for ch in layerWeights.get_children():
				ch.free();
			
			for i in count:
				var spinBox = SpinBox.new()
				spinBox.step = 0.1;
				layerWeights.add_child(spinBox);
			
		1: # Nodes per layer
			var count  = int(maxNodesPerLayer.value) - int(minNodesPerLayer.value) + 1
			
			for ch in nplWeights.get_children():
				ch.free();
			
			for i in count:
				var spinBox = SpinBox.new()
				spinBox.step = 0.1;
				nplWeights.add_child(spinBox);


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

func FindInEventScroll(label : String) -> int:
	var idx = 0;
	for i : EventScroll in eventScrollHolder.get_children():
		if i.eventType == label:
			return idx;
		idx += 1;
	return -1;

func FindInWeightTable(label : String = "") -> int:
	var idx = 0;
	for i : NodeWeightEntry in weightList.get_children():
		if i.typeLabel.text == label:
			return idx;
		idx += 1;
	return -1;
		
func SwitchEventTab(tabIdx : int = -1):
	if typeTabs.tab_count <= 1:
		return;
	
	for i in typeTabs.tab_count:
		eventScrollHolder.get_child(i).visible = false;
		
	if tabIdx == -1:
		return;
		
	eventScrollHolder.get_child(tabIdx).visible = true;

func UpdateWeightTabs():	
	var typeNames = []
	for i in typeTabs.tab_count:
		typeNames.append(typeTabs.get_tab_title(i));
	
	# Adding tabs
	for n in typeNames:
		
		# Do not alter existing ones
		if FindInWeightTable(n) != -1:
			continue
			
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
	floorData["info"]["splashImage"] = floorImage.text;
	floorData["info"]["musicTrack"] = musicTrackName.text;
	
	floorData["mapGen"] = {};
	floorData["mapGen"]["layers"] = [int(minLayers.text), int(maxLayers.text)];
	floorData["mapGen"]["nodesPerLayer"] = [int(minNodesPerLayer.text), int(maxNodesPerLayer.text)];
	
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
	floorRes.splashImageFilename = floorImage.text;
	floorRes.floorMusicName = musicTrackName.text;
	
	floorRes.minLayers = int(minLayers.value);
	floorRes.maxLayers = int(maxLayers.value);
	floorRes.minNodesPerLayer = int(minNodesPerLayer.value);
	floorRes.maxNodesPerLayer = int(maxNodesPerLayer.value);	
	
	floorRes.additionalMapGenRules = mapGenRulesInput.text;
	
	# Map gen weights
	floorRes.layerWeights = []
	for ch : SpinBox in layerWeights.get_children():
		floorRes.layerWeights.append(ch.value)
		
	floorRes.nodesPerLayerWeights = []
	for ch : SpinBox in nplWeights.get_children():
		floorRes.nodesPerLayerWeights.append(ch.value);
	
	# Event pools
	floorRes.nodeTypeWeights = {}
	for i in typeTabs.tab_count:
		var weightChild = weightList.get_child(i) as NodeWeightEntry
		var typeKey = typeTabs.get_tab_title(i)
		floorRes.nodeTypeWeights[typeKey] = float(weightChild.weightInput.text);
		
	for i in eventScrollHolder.get_child_count():
		var evScroll: EventScroll = eventScrollHolder.get_child(i);
		floorRes.events[evScroll.eventType] = [];
		
		var idInit := "";
		match evScroll.eventType:
			"ENCOUNTER":
				idInit = "Ev";
			"BOSS":
				idInit = "B";
			"FIGHT":
				idInit = "F";
			"CHALLENGE":
				idInit = "C";
			
		var count = 0;
		for ev : GameEncounterObj in evScroll.eventList.get_children():
			floorRes.events[evScroll.eventType].append(ev.SaveResource());
			floorRes.events[evScroll.eventType][count].internalID = idInit + str(count);
			count += 1;
			
	# Floor init dialogues
	for dial in dialogueList.get_children():
		floorRes.bootDialogues.append(dial.SaveResource())
	
	return floorRes;

func Load(_floorData : Variant):
	if _floorData is FloorResource:
		LoadResource(_floorData);
	elif _floorData is Dictionary:
		LoadJSON(_floorData);	
	return;
	
func LoadJSON(_floorData := {}):
	return;
	
func LoadResource(floorData : FloorResource):
	floorImage.text = floorData.splashImageFilename;
	musicTrackName.text = floorData.floorMusicName;
	
	minLayers.set_value_no_signal(floorData.minLayers);
	maxLayers.set_value_no_signal(floorData.maxLayers);
	minNodesPerLayer.set_value_no_signal(floorData.minNodesPerLayer);
	maxNodesPerLayer.set_value_no_signal(floorData.maxNodesPerLayer);
	
	mapGenRulesInput.text = floorData.additionalMapGenRules;
	
	# Map gen weights
	for ch in layerWeights.get_children():
		ch.free();
	for ch in nplWeights.get_children():
		ch.free();
	
	for i in floorData.layerWeights:
		var spinBox = SpinBox.new()
		spinBox.step = 0.1;
		spinBox.value = i;
		layerWeights.add_child(spinBox);
	for i in floorData.nodesPerLayerWeights:
		var spinBox = SpinBox.new()
		spinBox.step = 0.1;
		spinBox.value = i;
		nplWeights.add_child(spinBox);	
	
	# Node weight table
	for ch in eventScrollHolder.get_children():
		ch.queue_free()
		
	for tb in typeTabs.tab_count:
		typeTabs.remove_tab(0);
		
	for w in weightList.get_children():
		w.free()
	
	for i in floorData.nodeTypeWeights.size():
		var key = floorData.nodeTypeWeights.keys()[i];
		var idx = FindInWeightTable(key);
		if idx != -1:			
			weightList.get_child(idx).weightInput.text = str(floorData.nodeTypeWeights[key]);
			continue;

		var weightEntry = WEIGHT_ENTRY_OBJ.instantiate();
		weightList.add_child(weightEntry);
		weightEntry.typeLabel.text = key
		weightEntry.weightInput.text = str(floorData.nodeTypeWeights[key]);
	
	# Event pools
	var evTypeCount = floorData.events.size();

	
	var firstTab = true;
	for i in evTypeCount:
		
		var key = floorData.events.keys()[i];
		typeTabs.add_tab(key);
				
		var evScroll = EVENT_SCROLL_OBJ.instantiate();
		evScroll.eventType = key;
		eventScrollHolder.add_child(evScroll);
		
		evScroll.visible = false;
		if firstTab:
			evScroll.visible = true;
			firstTab = false;
			
		
		var evCount = floorData.events[key].size();
		for j in evCount:
			evScroll.AddEventBox();
			evScroll.eventList.get_child(j).LoadResource(floorData.events[key][j])
			
	# Dialogue lists
	for dial in floorData.bootDialogues:
		var dialEntry = DIALOGUE_ENTRY_OBJ.instantiate();
		dialogueList.add_child(dialEntry)
		dialEntry.LoadResource(dial);	
	
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
