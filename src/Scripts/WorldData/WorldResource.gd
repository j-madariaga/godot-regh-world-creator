class_name WorldResource
extends Resource

@export_group("General info")
@export var internalName : String = "";
@export var menuImageFilename : String = "";
@export var bootDialogueArray := [];

@export_group("Floors")
@export var floors : Array[FloorResource] = []
@export var maxFloors : int = 5;

@export_group("Special Floors")
@export var specFloors : Array[FloorResource] = []

@export_group("Endings")
@export var endings : Array[WorldEndingResource] = [];

@export_group("Gameplay variables")
@export var characters : Array[String] = [];
@export var initCharacters : Array[String] = [];
@export var initPartySize : int = 1;
@export var artifacts : Array[String] = [];
@export var gameplayVariables : Dictionary = {};
@export var gameplayScript : Script;

@export_group("Difficulty")
@export var difficultyAdditions : Dictionary = {}

@export_group("Stat tracking")
@export var stats : Dictionary = {
	"runsStarted" : 0,
	"runVictories" : 0,
};
