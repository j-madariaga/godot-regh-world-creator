class_name DictionaryEntryObj
extends CodeEdit

func SaveResource(list := []):
	var entry = {}
	entry = str_to_var(text)
	
	list.append(entry)
	return;
	
func LoadResource(entry):
	text = var_to_str(entry);
	return;
