//c2t donegg
//c2t

since r27795;//egg preferences

//donate mimic eggs randomly
//caution: there is currently no protection from donating an egg that already has been maximally donated

//cli flag
boolean c2t_donegg_CLI = false;

//global to be set when main function ran
familiar c2t_donegg_oldFam;

//returns true if either all eggs donated, or max eggs donated reached, or no more donateable eggs left
//returns false with specific error if there were troubles donating
boolean c2t_donegg();

//for error messages
boolean c2t_donegg_error(string s);

//for success messages
boolean c2t_donegg_success(string s);

//print
void c2t_donegg_print(string s);

//mafia's xpath won't let me just grab from one form directly without this workaround
boolean c2t_donegg_isExtractPage(buffer buf);
boolean c2t_donegg_isDonatePage(buffer buf);
int c2t_donegg_numForms(buffer buf);

//CLI
void main() {
	c2t_donegg_CLI = true;
	c2t_donegg();
}

boolean c2t_donegg() {
	item egg = $item[mimic egg];
	familiar mimic = $familiar[chest mimic];
	string pref = "_mimicEggsDonated";
	int tries = 0;
	int MAX_TRIES = 7;
	string[int] options;
	int numForms;
	string mon;
	buffer buf;
	c2t_donegg_oldFam = my_familiar();

	//maybe don't have to go
	if (!have_familiar(mimic))
		return c2t_donegg_error("no chest mimic detected");
	if (get_property(pref).to_int() >= 3)
		return c2t_donegg_success("max eggs donated already");
	if (item_amount(egg) == 0)
		return c2t_donegg_success("no eggs on hand to donate");

	//go
	use_familiar(mimic);
	buf = visit_url("place.php?whichplace=town_right&action=townright_dna",false,true);

	//choice check
	if (!handling_choice()
		|| last_choice() != 1517)
	{
		return c2t_donegg_error("couldn't enter choice adventure to donate eggs");
	}

	/* this doesn't happen... yet?
	//forms check
	if (buf.c2t_donegg_isDonatePage())
		numForms = 1 + c2t_donegg_isExtractPage(buf).to_int();
	else
		return c2t_donegg_success(`none of the {item_amount(egg)} eggs you have can be donated`);
	*/
	numForms = c2t_donegg_numForms(buf);

	//do the things
	repeat {
		/* this doesn't happen... yet?
		if (!buf.c2t_donegg_isDonatePage())
			return c2t_donegg_success(`none of the remaining {item_amount(egg)} eggs you have can be donated`);
		*/
		options = xpath(buf,`//form[@action="choice.php"][{numForms}]/select/option/@value`);
		mon = options.count() > 2
			? options[random(options.count()-1)+1]
			: options[1];
		//bare egg protection for now
		if (mon.to_monster() == $monster[knob goblin embezzler])
			continue;
		c2t_donegg_print(`c2t_donegg: donating egg of {mon.to_monster().manuel_name}`);
		buf = visit_url(`choice.php?pwd&whichchoice=1517&option=1&mid={mon}`,true,true);
	} until (item_amount(egg) == 0
		|| get_property(pref).to_int() >= 3
		|| ++tries >= MAX_TRIES);//just in case logic is off or there is a desync with mafia, don't let this loop infinitely

	//result
	if (get_property(pref).to_int() >= 3)
		return c2t_donegg_success("max eggs donated");
	if (item_amount(egg) == 0)
		return c2t_donegg_success("ran out of eggs to donate");
	if (tries >= MAX_TRIES)
		return c2t_donegg_error(`mafia out of sync? tried to donate {tries} times without fully succeeding`);

	//something happened that I didn't think of; or something to do with protection
	c2t_donegg_print(`{get_property(pref)},{item_amount(egg)},{tries},{mon},{options.count()}`);
	return c2t_donegg_error("maximum overfail");
}

boolean c2t_donegg_error(string s) {
	string msg = "c2t_donegg error: "+s;
	use_familiar(c2t_donegg_oldFam);

	if (c2t_donegg_CLI)
		abort(msg);

	print(msg,"red");
	return false;
}

boolean c2t_donegg_success(string s) {
	use_familiar(c2t_donegg_oldFam);
	c2t_donegg_print(s);
	return true;
}

void c2t_donegg_print(string s) {
	print("c2t_donegg: "+s);
}

boolean c2t_donegg_isExtractPage(buffer buf) {
	return buf.contains_text('Extract an egg containing the dna of <select name="mid">');
}

boolean c2t_donegg_isDonatePage(buffer buf) {
	return buf.contains_text('Donate the egg of <select name="mid">');
}

int c2t_donegg_numForms(buffer buf) {
	return c2t_donegg_isDonatePage(buf).to_int() + c2t_donegg_isExtractPage(buf).to_int();
}

