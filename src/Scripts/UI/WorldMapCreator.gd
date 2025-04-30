extends Panel

const PROJ_BUTTON_ARCH = preload("res://src/Scenes/ProjectButton.tscn")
const FLOOR_BUTTON_ARCH = preload("res://src/Scenes/FloorButton.tscn")

@onready var sideMenu = $SideMenu
@onready var sideMenuButton = $SideMenuButton

const OUTPUT_PATH = "res://output";
@onready var projectList = $SideMenu/VBoxContainer/SavedFiles/SavedList

@onready var worldInfoScreen = $WorldInfoScreen
@onready var floorInfoScreen = $FloorInfoScreen
@onready var specFloorInfoScreen = $SpecialFloorScreen
@onready var gameplayScreen = $GameplayScreen
@onready var difficultyScreen = $DifficultyScreen
@onready var endingScreen = $EndingsScreen

@onready var inputFilename = $SideMenu/VBoxContainer/FileSave/FilenameInput

@onready var projName = $WorldInfoScreen/NameContainer/NameInput
@onready var internalName = $WorldInfoScreen/NameContainer/InternalNameInput
@onready var descInput = $WorldInfoScreen/DescInput
@onready var imageInput = $WorldInfoScreen/SplashImage/TextureName
@onready var firstBootDialogueInput = $WorldInfoScreen/FirstBootDialogue/DialFileInput

@onready var floorList = $FloorInfoScreen/FloorScroll/FloorList
@onready var specialFloorList = $SideMenu/VBoxContainer/FloorInfo/SpecialFloors

signal onProjectLoad(String);

func AddFloorButton():
	var button = FLOOR_BUTTON_ARCH.instantiate();
	floorList.add_child(button)
	button.floorTag.text = "Floor " + str(floorList.get_child_count());
	
func AddSpecialFloorButton():
	var button = FLOOR_BUTTON_ARCH.instantiate();
	specialFloorList.add_child(button)

func _ready():
	onProjectLoad.connect(Load)
	
	ToggleSideMenu(true);
	LoadSavedProjects();
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

func Quit():
	Save();

func Save():
	var worldData = {
		"worldInfo" : {},
		"floors" : {},
		"specFloors" : {},
		"gameplay" : {},
		"difficulty" : [],
		"endings" : {},
	};	
	
	
	worldData["worldInfo"]["name"] = projName.text;
	worldData["worldInfo"]["internalName"] = internalName.text;
	worldData["worldInfo"]["description"] = descInput.text;
	worldData["worldInfo"]["image"] = imageInput.text;
	worldData["worldInfo"]["firstBootDialogue"] = firstBootDialogueInput.text;
	
	worldData["floors"] = []
	
	for fl : FloorButton in floorList.get_children():
		worldData["floors"].append(fl.Save());
		
	for fl : FloorButton in specialFloorList.get_children():
		worldData["specialFloors"].append(fl.Save());
	
	var filePath = OUTPUT_PATH + "/" + inputFilename.text + ".world";
	var file = FileAccess.open(filePath, FileAccess.WRITE);
	
	if file.is_open():
		
		file.store_var(JSON.stringify(worldData, "\t"))
		
		file.close();
	
	LoadSavedProjects();
	return;
	
func Load(fileName):	
	
	var filePath = OUTPUT_PATH + "/" + fileName;
	var file = FileAccess.open(filePath, FileAccess.READ);
	
	if file.is_open():
		#currentWorld = load(filePath)
		#print(currentWorld.name)
		file.close();
	else:
		printerr("ERROR: COULD NOT LOAD FILE")
	
	return;	
