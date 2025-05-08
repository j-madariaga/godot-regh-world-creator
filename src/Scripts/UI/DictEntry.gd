class_name DictionaryEntryObj
extends CodeEdit

func SaveResource(list := []):
	var entry = {}
	entry = str_to_var(text)
	print(entry)
	
	list.append(entry)
	return;
	
func LoadResource(entry):
	text = var_to_str(entry);
	return;
