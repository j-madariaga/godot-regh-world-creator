extends Panel

const PROJ_BUTTON_ARCH = preload("res://src/Scenes/Utils/ProjectButton.tscn")
const FLOOR_BUTTON_ARCH = preload("res://src/Scenes/FloorButton.tscn")
const DIAL_ENTRY_OBJ = preload("res://src/Scenes/Utils/DialogueEntry.tscn")
const WORLD_ENDING_OBJ = preload("res://src/Scenes/Utils/WorldEndingObj.tscn")
const GAME_VAR_OBJ = preload("res://src/Scenes/Utils/GameplayVarEntry.tscn")

@onready var sideMenu = $SideMenu
@onready var sideMenuButton = $SideMenuButton

const OUTPUT_PATH = "res://output";
@onready var fileExtensionList = $SideMenu/VBoxContainer/FileSave/FileExtensions
@onready var projectList = $SideMenu/VBoxContainer/SavedFiles/SavedList

@onready var worldInfoScreen = $WorldInfoScreen
@onready var floorInfoScreen = $FloorInfoScreen
@onready var specFloorInfoScreen = $SpecialFloorScreen
@onready var gameplayScreen = $GameplayScreen
@onready var difficultyScreen = $DifficultyScreen
@onready var endingScreen = $EndingsScreen

@onready var inputFilename = $SideMenu/VBoxContainer/FileSave/FilenameInput

@onready var internalName = $WorldInfoScreen/NameContainer/InternalNameInput
@onready var imageInput = $WorldInfoScreen/SplashImage/TextureName
@onready var bootDialogueList = $WorldInfoScreen/BootDialogues/List

@onready var maxFloorsInput = $FloorInfoScreen/HBoxContainer2/MaxFloorInput
@onready var floorList = $FloorInfoScreen/FloorScroll/FloorList
@onready var specialFloorList = $SpecialFloorScreen/FloorScroll/FloorList

@onready var gameplayVarList = $GameplayScreen/Hold/Rules/GameplayVarList

@onready var endingList = $EndingsScreen/Scroll/EndingList

signal onProjectLoad(String);


func _ready():
	onProjectLoad.connect(Load)
	
	ToggleSideMenu(true);
	LoadSavedProjects();
	return;

# ---- DATA CREATION -----
func AddFloorButton():
	var button = FLOOR_BUTTON_ARCH.instantiate();
	floorList.add_child(button)
	button.floorTag.text = "Floor " + str(floorList.get_child_count());
	
func AddSpecialFloorButton():
	var button = FLOOR_BUTTON_ARCH.instantiate();
	specialFloorList.add_child(button)

func AddBootDialogueEntry():
	var dial := DIAL_ENTRY_OBJ.instantiate();
	bootDialogueList.add_child(dial)

func AddWorldEnding():
	var end = WORLD_ENDING_OBJ.instantiate();
	endingList.add_child(end);
	
	return;

# ---- SIDE MENU --------
func ToggleSideMenu(v : bool):
	sideMenu.visible = v;
	sideMenuButton.visible = !v;
	
func OpenMenu(mode : int = 0):
	worldInfoScreen.visible = false;
	floorInfoScreen.visible = false;
	specFloorInfoScreen.visible = false;
	gameplayScreen.visible = false;
	difficultyScreen.visible = false;
	endingScreen.visible = false;
	
	match mode:
		0:
			OpenWorldInfo();
		1:
			OpenFloorInfo();
		2:
			OpenSpecFloorInfo();
		3: 
			OpenGameplayInfo();
		4:
			OpenDifficultyInfo();
		5:
			OpenEndingsInfo();
			
	return;
			
func OpenWorldInfo():
	worldInfoScreen.visible = true;
	return;
	
func OpenFloorInfo():
	floorInfoScreen.visible = true;
	return;
	
func OpenSpecFloorInfo():
	specFloorInfoScreen.visible = true;
	return;
	
func OpenEndingsInfo():
	endingScreen.visible = true;
	return;
	
func OpenGameplayInfo():
	gameplayScreen.visible = true;
	return;
	
func OpenDifficultyInfo():
	difficultyScreen.visible = true;
	return;
	
func ClearSavedProjects():
	for ch in projectList.get_children():
		ch.queue_free();

func LoadSavedProjects():
	ClearSavedProjects();
	
	var dir = DirAccess.open(OUTPUT_PATH)
	if dir:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
		
			var projButton = PROJ_BUTTON_ARCH.instantiate() as ProjectButton;
			projectList.add_child(projButton)
			
			
			projButton.projectName.text = fileName;			
			projButton.loadButton.connect("pressed", Load.bind(projButton.projectName.text))
						
			fileName = dir.get_next()	
			
	else:
		print("An error occurred when trying to access the path.")
		
	return

# --------------------------------
# ------ FILE MGMNT -------------
func _notification(what):
	# Save before closing
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if inputFilename.text == "":
			inputFilename.text = "TMP_SAVE"
		
		SaveResource();
		get_tree().quit()

	
func SaveResource(textRes : bool = true):
	
	var worldRes = WorldResource.new();
	worldRes.internalName = internalName.text;

	worldRes.menuImageFilename = imageInput.text;
	worldRes.maxFloors = int(maxFloorsInput.text)
	
	for startDial : DialogueEntry in bootDialogueList.get_children():
		worldRes.bootDialogueArray.append(startDial.SaveResource());
	
	var count = 0;
	for fl : FloorButton in floorList.get_children():
		worldRes.floors.append(fl.SaveResource());
		worldRes.floors[count].internalID = "F" + str(count);
		count += 1;
		
	count = 0;
	for specFl : FloorButton in specialFloorList.get_children():
		worldRes.specFloors.append(specFl.SaveResource()); 
		worldRes.specFloors[count].internalID = "SF" + str(count);
		count += 1;
		
	worldRes.gameplayVariables.clear();
	for v in gameplayVarList.get_children():
		var entry = v.Save()		
		worldRes.gameplayVariables[entry["entryName"]] = entry["entryValue"];
		
		
		
	for end : WorldEndingObj in endingList.get_children():
		worldRes.endings.append(end.SaveResource())
	
	var filePath = OUTPUT_PATH + "/" + inputFilename.text;
	if textRes:
		filePath += ".tres";
	else:
		filePath += ".res";
	ResourceSaver.save(worldRes, filePath);
	return;

func SaveJSON():
	var worldData = {};
	worldData["worldInfo"] = {};
	worldData["floors"] = [];
	worldData["specFloors"] = []
	worldData["gameplay"] = {};
	worldData["difficulty"] = [];
	worldData["endings"] = [];
	
	worldData["worldInfo"]["internalName"] = internalName.text;
	worldData["worldInfo"]["image"] = imageInput.text;
	
	worldData["bootDialogueArray"] = [];
	for startDial : DialogueEntry in bootDialogueList.get_children():		
		worldData["bootDialogueArray"].append(startDial.SaveJSON());
	
	worldData["floors"] = []
	
	for fl : FloorButton in floorList.get_children():
		worldData["floors"].append(fl.SaveJSON());
		
	for fl : FloorButton in specialFloorList.get_children():
		worldData["specialFloors"].append(fl.SaveJSON());
	
	var filePath = OUTPUT_PATH + "/" + inputFilename.text + ".json";
	var file = FileAccess.open(filePath, FileAccess.WRITE);
	
	if file.is_open():
		
		file.store_string(JSON.stringify(worldData, "\t"))
		file.close();
	return;

func Save():
	match  fileExtensionList.get_item_text(fileExtensionList.selected):
		".json":
			SaveJSON();
		".res":
			SaveResource(false);
		".tres":
			SaveResource(true);
	
	LoadSavedProjects();
	return;

func LoadJSON(fileName : String = ""):
	var filePath = OUTPUT_PATH + "/" + fileName;
	var file = FileAccess.open(filePath, FileAccess.READ);
	if file.is_open():
		#currentWorld = load(filePath)
		#print(currentWorld.name)
		file.close();
	
	return;
	
func LoadResource(fileName : String = ""):
	
	var worldRes := ResourceLoader.load(OUTPUT_PATH + "/" + fileName) as WorldResource;
	
	if worldRes == null:
		print("ERROR: resource % s failed to load!" % [fileName]);
		return;
		
	internalName.text = worldRes.internalName;

	imageInput.text = worldRes.menuImageFilename;
	maxFloorsInput.text = str(worldRes.maxFloors);

	for dial in worldRes.bootDialogueArray:
		var dialEntry := DIAL_ENTRY_OBJ.instantiate();
		bootDialogueList.add_child(dialEntry);
		dialEntry.dialName.text = dial.internalName;
		dialEntry.triggerChance.text = str(int(dial.triggerChance));
		dialEntry.autoSkip.button_pressed = dial.autoSkip;
		dialEntry.firstBoot.button_pressed = dial.firstBootTrigger;
		
	for fl in worldRes.floors:
		var floorButton = FLOOR_BUTTON_ARCH.instantiate();
		floorList.add_child(floorButton);
		floorButton.Load(fl);
		
	for fl in worldRes.specFloors:
		var floorButton = FLOOR_BUTTON_ARCH.instantiate();
		specialFloorList.add_child(floorButton);
		floorButton.Load(fl);
		
		
	for v in worldRes.gameplayVariables:
		var vObj = GAME_VAR_OBJ.instantiate();
		gameplayVarList.add_child(vObj);
		
		vObj.Load(v, worldRes.gameplayVariables[v]);
		
	
		
	for end in worldRes.endings:
		var endObj = WORLD_ENDING_OBJ.instantiate();
		endingList.add_child(endObj);
		endObj.LoadResource(end)
	
	return;

func Load(fileName : String = ""):
	Clear();
	
	if fileName.contains(".json"):
		inputFilename.text = fileName.trim_suffix(".json");
		fileExtensionList.select(0);
		LoadJSON()
		
	if fileName.contains(".res"):
		inputFilename.text = fileName.trim_suffix(".res");
		fileExtensionList.select(2);
		LoadResource(fileName)
		
	if fileName.contains(".tres"):
		inputFilename.text = fileName.trim_suffix(".tres");
		fileExtensionList.select(1);
		LoadResource(fileName);
	
	return;	

func Clear():
	internalName.text = "";
	imageInput.text = "";
	
	for ch in bootDialogueList.get_children():
		ch.queue_free();
		
	for fl in floorList.get_children():
		fl.queue_free();
		
	for specFl in specialFloorList.get_children():
		specFl.queue_free();
		
	for v in gameplayVarList.get_children():
		v.queue_free();
		
	for end in endingList.get_children():
		end.queue_free()
	
func AddGameplayVariable(data := {}):
	var varObj = GAME_VAR_OBJ.instantiate();
	gameplayVarList.add_child(varObj)
	
	if data != {}:
		varObj.Load(data)
	
	
func NewWorld():
	Clear();
