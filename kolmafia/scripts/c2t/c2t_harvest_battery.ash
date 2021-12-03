//c2t harvest battery
//c2t

//simply harvests all batteries from the potted power plant


void main() {
	//use item
	buffer buf = visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem=10738`);

	//detect correct choice adventure
	if (buf.contains_text('name="whichchoice" value="1448"')) {
		//previously harvested parts have a "disabled" flag between the "button" tag and the "type" attribute
		matcher match = create_matcher('<button\\s+type="submit"\\s+name="pp"\\s+value="(\\d)"',buf);

		print("Harvesting batteries...","blue");
		//harvest
		while (match.find())
			visit_url(`choice.php?pwd&whichchoice=1448&option=1&pp={match.group(1)}`,true,true);
		print("Should be finished harvesting batteries.","blue");
	}
	else
		print("Was not able to enter the choice adventure to harvest batteries.","red");
}

