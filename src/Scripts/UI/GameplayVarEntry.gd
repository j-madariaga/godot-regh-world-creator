class_name GameplayVarEntry
extends HBoxContainer

@onready var varName = $VarNameInput
@onready var varType = $VarType
@onready var initValue = $InitialValue

func Load(key : String, data : Variant):
	varName.text = key;
	initValue.text = str(data)
	
	if data is int:
		varType.select(0);
	if data is float:
		varType.select(1);
	if data is String:
		varType.select(2);
	
	return;
	
func Save() -> Dictionary:
	var entry = {}
	
	entry["entryName"] = varName.text;
	
	match varType.get_item_text(varType.selected):
		"int":
			entry["entryValue"] = int(initValue.text)
		"float":
			entry["entryValue"] = float(initValue.text)
		"String":
			entry["entryValue"] = initValue.text
	
	
	return entry;
