class_name EncounterOptionResource
extends Resource

@export var optTitle : String = "";
@export var description : String = "";
@export var imageFilename : String = "";
var eligible : bool = true;

@export var requirements := {};
@export var actions : Array[EncounterActionResource];
