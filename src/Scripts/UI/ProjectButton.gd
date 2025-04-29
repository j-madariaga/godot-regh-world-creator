class_name ProjectButton
extends HBoxContainer

@onready var projectName = $Name

func SetName(n : String = ""):
	projectName.text = ("\t" + n);
	return
