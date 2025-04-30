class_name ProjectButton
extends HBoxContainer

@onready var projectName = $Name
@onready var loadButton = $Button

func SetName(n : String = ""):
	projectName.text = ("\t" + n);
	return 
	
