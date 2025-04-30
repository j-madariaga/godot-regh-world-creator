class_name NodeWeightEntry
extends HBoxContainer

@onready var typeLabel = $NodeType
@onready var weightInput = $WeightInput


func Save() -> Dictionary:
	var weightData = {};
	weightData[typeLabel.text] = float(weightInput.text);
	return weightData
	
func Load(weightData : Dictionary = {}):
	typeLabel.text = weightData.keys()[0];
	weightInput.text = str(weightData[typeLabel.text]);
