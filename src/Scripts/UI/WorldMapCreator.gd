extends Panel

const PROJ_BUTTON_ARCH = preload("res://src/Scenes/ProjectButton.tscn")

@onready var sideMenu = $SideMenu
@onready var sideMenuButton = $SideMenuButton

@onready var projectList = $SideMenu/VBoxContainer/SavedFiles/SavedList

@onready var worldInfoScreen = $WorldInfoScreen
@onready var floorInfoScreen = $FloorInfoScreen
@onready var specFloorInfoScreen = $SpecialFloorScreen
@onready var gameplayScreen = $GameplayScreen
@onready var difficultyScreen = $DifficultyScreen
@onready var endingScreen = $EndingsScreen


func _ready():
	ToggleSideMenu(true);
	LoadSavedProjects();
	return;
	
func LoadSavedProjects():
	var dir = DirAccess.open("res://output")
	if dir:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
		
			var projButton = PROJ_BUTTON_ARCH.instantiate() as ProjectButton;
			projectList.add_child(projButton)			
			projButton.projectName.text = fileName;
			
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
	return;
	
func Load():
	return;	
