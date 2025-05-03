class_name DialogueInfo
extends Resource

@export var internalName : String = "";
@export_range(0,100,1) var triggerChance : int = 100;
@export var autoSkip : bool = true;
@export var firstBootTrigger : bool = true;
