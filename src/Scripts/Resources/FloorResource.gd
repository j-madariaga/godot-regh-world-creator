class_name FloorResource
extends Resource

@export_group("General info")
@export var name : String = "";
@export var description : String = "";
@export var splashImageFilename : String= "";
@export var floorMusicName : String = "";

@export_group("Map Generation")
@export var minLayers : int = 0;
@export var maxLayers : int = 0
@export var maxNodesPerLayer : int = 0;
@export var minNodesPerLayer : int = 0;
@export var minNodePaths : int = 0;
@export var maxNodePaths : int = 0;
@export var nodeTypeWeights : Dictionary = {}
@export var additionalMapGenRules : String = "";

@export_group("Events")
@export var events : Dictionary = {};

@export_group("Dialogues")
@export var bootDialogues : Dictionary = {};
