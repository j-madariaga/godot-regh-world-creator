class_name EncounterOptionResource
extends Resource

@export var title : String = "";
@export var description : String = "";
@export var imageFilename : String = "";
var eligible : bool = true;
@export var endIdx : int = 0;

@export var requirements : Array[Dictionary] = [];
@export var actions : Array[Dictionary] = [];
