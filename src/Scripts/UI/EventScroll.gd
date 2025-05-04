class_name EventScroll
extends VBoxContainer

const FIGHT_EVENT_DATA = preload("res://src/Scenes/EncounterTypes/FightEventObj.tscn");
const BOSS_EVENT_DATA = preload("res://src/Scenes/EncounterTypes/BossEventObj.tscn");
const ENCOUNTER_EVENT_DATA = preload("res://src/Scenes/EncounterTypes/EncounterEventObj.tscn");


var eventType : String = "";
@onready var eventList = $EventScroll/EventList


func AddEventBox():
	match eventType:
		"FIGHT":
			var fightEv = FIGHT_EVENT_DATA.instantiate();
			eventList.add_child(fightEv);
			
		"ENCOUNTER":
			var encEv = ENCOUNTER_EVENT_DATA.instantiate();
			eventList.add_child(encEv);
			return;
			
		"BOSS":
			var bossEv = BOSS_EVENT_DATA.instantiate();
			eventList.add_child(bossEv);
			return;
			

	
