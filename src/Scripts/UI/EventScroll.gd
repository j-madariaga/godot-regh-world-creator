class_name EventScroll
extends VBoxContainer

const FIGHT_EVENT_DATA = preload("res://src/Scenes/FightEventObj.tscn")

var eventType : String = "";
@onready var eventList = $EventScroll/EventList


func AddEventBox():
	match eventType:
		"FIGHT":
			var fightEv = FIGHT_EVENT_DATA.instantiate();
			eventList.add_child(fightEv);
			
		"ENCOUNTER":
			return;
		
		"BOSS":
			return;
			

	
