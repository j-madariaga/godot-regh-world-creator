class_name CharacterEntry
extends HBoxContainer

@onready var charName = $CharName

func OnDelete():
	queue_free();
