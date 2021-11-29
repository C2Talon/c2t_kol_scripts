//c2t mapgrim
//c2t

//evenly acquires distention pills and dog hair pills using maps to grimace prime

boolean CLI;

//function to import and call
//returns true if sucessfully completed
boolean c2t_mapgrim();


//for the CLI
void main() {
	CLI = true;
	c2t_mapgrim();
}

boolean c2t_mapgrim() {
	item it = $item[Map to Safety Shelter Grimace Prime];
	string out;
	while (my_adventures() > 1 && available_amount(it) > 0) {
		//get effect to adventure in zone if needed
		if (have_effect($effect[Transpondent]) == 0 && available_amount($item[transporter transponder]) > 0)
			use(1,$item[transporter transponder]);
		if (have_effect($effect[Transpondent]) == 0) {
			out = `Unable to get the Transpondent effect. Still have {available_amount(it)} {available_amount(it) != 1?it.plural:it}.`;
			if (CLI)
				abort(out);
			else {
				print(out,"red");
				return false;
			}
		}

		//juggle choices to equalise the amount you have
		if (get_property('choiceAdventure536').to_int() == 1 && available_amount($item[synthetic dog hair pill]) <= available_amount($item[distention pill]))
			set_property('choiceAdventure536','2');
		else if (get_property('choiceAdventure536').to_int() == 2 && available_amount($item[synthetic dog hair pill]) > available_amount($item[distention pill]))
			set_property('choiceAdventure536','1');

		use(1,it);
	}

	if (available_amount(it) == 0) {
		print(`Finished using all {it.plural}.`,'blue');
		return true;
	}
	else if (my_adventures() <= 1) {
		print(`Ran out of adventures to use {it.plural}. {available_amount(it)} remain.`,"blue");
		return false;
	}

	out = `Something broke using {it.plural}.`;
	if (CLI)
		abort(out);

	print(out,"red");
	return false;
}

