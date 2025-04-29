class_name FloorResource
extends Resource

@export_group("General info")
@export var name : String = "";
@export var description : String = "";
@export var splashImage = "";
@export var floorEnterDialogues := []

@export_group("Map Generation")
@export var minLayers : int = 0;
@export var maxLayers : int = 0
@export var maxNodesPerLayer : int = 0;
@export var minNodesPerLayer : int = 0;
@export var minNodePaths : int = 0;
@export var maxNodePaths : int = 0;
@export var additionalRules : Dictionary;

@export_group("Events")
@export var events : Dictionary = {};
