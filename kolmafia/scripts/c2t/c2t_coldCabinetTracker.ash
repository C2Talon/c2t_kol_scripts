//c2t coldCabinetTracker
//c2t

since r25965;

//simply gets the list of items offered by the cold medicine cabinet and puts them into the property `c2t_coldCabinetItems`

//`c2t_coldCabinetItems` is arraged based on the choice order in the adventure. Example:
//"ice crown,frozen tofu pop,Doc's Fortifying Wine,anti-odor cream,Fleshazole&trade;"


//`import` this script to use these functions
//`autoExit` is optional, but will default to `true` if omitted
//if `autoExit` is `true`, the choice adventure will be exited once the function is finished
//if `autoExit` is `false`, you will have to exit the choice adventure on your own. Use this if you want to select an item once it is available, for example. In this way, you won't have to reenter the choice adventure to get the item.
void c2t_coldCabinetTracker(boolean autoExit);
void c2t_coldCabinetTracker() c2t_coldCabinetTracker(true);

//running from CLI will only auto-exit the choice adventure; blame not having default parameters as part of the language
void main() c2t_coldCabinetTracker(true);


void c2t_coldCabinetTracker(boolean autoExit) {
	int cooldown = get_property("_nextColdMedicineConsult").to_int();
	int consults = get_property("_coldMedicineConsults").to_int();
	string prop = "c2t_coldCabinetItems";
	buffer page;
	string out;

	if (total_turns_played() < cooldown)
		return;
	/*tracking of consults is broken in 25965, so uncomment this if/when it's fixed
	if (consults >= 5)
		return;
	*/

	page = visit_url('campground.php?action=workshed');
	//using this over mafia tracking of consults since mafia's is broke; can remove this check when fixed in mafia
	if (page.contains_text("Looks like the doctors are out for the day."))
		return;
	//cooldown detected //should be rudundant once mafia tracking is fixed
	if (page.contains_text("You can visit the doctors again in"))
		return;

	string[int] cAdvNum = xpath(page,'//form[@action="choice.php"]//input[@type="hidden"][@name="whichchoice"]/@value');
	string[int] cOption = xpath(page,'//form[@action="choice.php"]//input[@type="hidden"][@name="option"]/@value');
	//string[int] cText   = xpath(page,'//form[@action="choice.php"]//input[@type="submit"]/@value');
	string[int] cItem   = xpath(page,'//form[@action="choice.php"]//img[@class="hand"]/@title');

	if (cAdvNum[0].to_int() != 1455)
		return;

	for i from 0 to count(cOption)-2
		out += (i == 0?cItem[i]:","+cItem[i]);

	set_property(prop,out);

	if (autoExit)
		run_choice(6);
}

