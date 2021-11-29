//c2t cartographyHunt
//c2t
//handles the Map the Monsters non-combat adventure and places player in the combat that follows

// loc is target location
// mon is target monster
// returns whether the combat was entered after the correct non-combat adventure or not
// uses Map the Monsters skill as needed
// aborts in the non-combat adventure if the loc and mon pair is invalid
// aborts if something other than correct non-combat adventure is encountered

boolean c2t_cartographyHunt(location loc,monster mon) {
	//check for skill
	if (!have_skill($skill[Map the Monsters])) {
		print("Map the Monsters skill not detected","blue");
		return false;
	}

	//use skill if needed
	if (!get_property('mappingMonsters').to_boolean() && get_property('_monstersMapped').to_int() < 3)
		use_skill(1,$skill[Map the Monsters]);
	
	//attempt to enter combat
	if (get_property('mappingMonsters').to_boolean()) {
		buffer buf;

		//check for the correct non-combat
		buf = visit_url(loc.to_url(),false,true);
		if (!buf.contains_text('name="whichchoice" value="1435"') || !buf.contains_text("Leading Yourself Right to Them"))
			abort("Wrong thing came up when using Map the Monsters at "+loc+" with "+mon);

		//select choice
		buf = visit_url("choice.php?pwd&whichchoice=1435&option=1&heyscriptswhatsupwinkwink="+mon.to_int(),true,true);

		//combat check
		matcher combat = create_matcher("<!--\\s+MONSTERID:\\s+(\\d+)\\s+-->",buf);
		if (combat.find()) {
			if (combat.group(1).to_int() == mon.to_int()) {
				print("Should be in combat with "+mon,"blue");
				return true;
			}
			abort("Entered combat with the wrong monster somehow");
		}
		abort("Did not enter combat using Map the Monsters at "+loc+" with "+mon);
	}
	//skill use exhausted
	else if (get_property('_monstersMapped').to_int() >= 3) {
		print("Ran out of Map the Monsters skill uses","blue");
		return false;
	}

	//should not get here
	print("Something went wrong with Map the Monsters. Used some of the skill uses outside of mafia?","blue");
	return false;
}

