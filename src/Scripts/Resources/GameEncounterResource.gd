class_name GameEncounterResource
extends Resource

@export var type : String = "";
@export var dialogueFile : String = "";
@export_range(0,100,1) var dialogueTriggerChance : int = 100;
@export var autoSkip : bool = false;
