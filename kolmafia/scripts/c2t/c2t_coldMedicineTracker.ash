//c2t coldMedicineTracker
//c2t

since r25967;

//simply gets the list of items offered by the cold medicine cabinet and puts them into the property `_c2t_coldMedicineItems`

//`_c2t_coldMedicineItems` is arraged based on the choice order in the adventure. Example:
//"ice crown,frozen tofu pop,Doc's Fortifying Wine,anti-odor cream,Fleshazole&trade;"


//`import` this script to use this function to update the property
void c2t_coldMedicineTracker();

//running this script from the CLI will also update the property
void main() c2t_coldMedicineTracker();


void c2t_coldMedicineTracker() {
	int cooldown = get_property("_nextColdMedicineConsult").to_int();
	int consults = get_property("_coldMedicineConsults").to_int();
	string prop = "_c2t_coldMedicineItems";
	buffer page;
	string[int] cNum,cOpt,cIte;
	string out;

	//check if the cabinet is available
	if (!(get_campground() contains $item[cold medicine cabinet]))
		return;
	if (total_turns_played() < cooldown)
		return;
	if (consults >= 5)
		return;

	//enter choice and snag stuff needed
	page = visit_url('campground.php?action=workshed');
	cNum = xpath(page,'//form[@action="choice.php"]//input[@type="hidden"][@name="whichchoice"]/@value');
	cOpt = xpath(page,'//form[@action="choice.php"]//input[@type="hidden"][@name="option"]/@value');
	cIte = xpath(page,'//form[@action="choice.php"]//img[@class="hand"]/@title');

	//check choice adventure number
	if (cNum[0].to_int() != 1455)
		return;

	//build the string
	for i from 0 to count(cOpt)-2
		out += (i == 0?"":",")+cIte[i];

	//send it
	set_property(prop,out);
}

