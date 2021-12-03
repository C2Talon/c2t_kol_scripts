//c2t coldMedicineTracker
//c2t

since r25965;

//simply gets the list of items offered by the cold medicine cabinet and puts them into the property `_c2t_coldMedicineItems`

//`_c2t_coldMedicineItems` is arraged based on the choice order in the adventure. Example:
//"ice crown,frozen tofu pop,Doc's Fortifying Wine,anti-odor cream,Fleshazole&trade;"


//`import` this script to use this function to update the property
void c2t_coldMedicineTracker();

//running from CLI will also update the property
void main() c2t_coldMedicineTracker();

void c2t_coldMedicineTracker() {
	int cooldown = get_property("_nextColdMedicineConsult").to_int();
	int consults = get_property("_coldMedicineConsults").to_int();
	string prop = "_c2t_coldMedicineItems";
	buffer page;
	string out;

	if (!(get_campground() contains $item[cold medicine cabinet]))
		return;

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
}

