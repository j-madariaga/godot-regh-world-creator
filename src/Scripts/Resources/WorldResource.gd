class_name WorldResource
extends Resource

@export_group("General info")
@export var name : String = "";
@export var internalName : String = "";
@export var description  : String =  "";
@export var menuImage : Texture2D = Texture2D.new();
@export var firstBootDialogue  : String = "";
@export var bootDialogueArray := [];

@export_group("Floors")
@export var floors : Array[FloorResource] = []

@export_group("Special Floors")
@export var specFloors : Array[FloorResource] = []

@export_group("Endings")
@export var endingDialogueArray := [];

@export_group("Gameplay variables")
@export var characters : Array[String] = [];
@export var artifacts : Array[String] = [];
@export var gameplayVariables : Dictionary = {};
@export var gameplayScript : Script;

@export_group("Difficulty")
@export var difficultyAdditions : Dictionary = {}

@export_group("Stat tracking")
@export var stats : Dictionary = {};
