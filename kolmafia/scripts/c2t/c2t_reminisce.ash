//c2t reminisce
//c2t

//enter combat with a monster from combat lover's locket

since r26218;//locket support


//tries to enter combat with monster `mon`
//returns `true` if successful
boolean c2t_reminisce(monster mon);

//for the cli
//`monsterNameOrId` is name of monster to fight from the locket. A monster's ID number should also work to disambiguate same-named monsters.
void main (string monsterNameOrId) {
	monster mon = monsterNameOrId.to_monster();
	if (!c2t_reminisce(mon)) {
		print(`Combat was not entered with "{mon}".`,"red");
		return;
	}
	print(`Should be in combat with "{mon}".`,"blue");
}

boolean _c2t_reminisce_error(string err) {
	print(`c2t_reminisce error:{err}`,"red");
	return false;
}

boolean c2t_reminisce(monster mon) {
	string monId = mon.to_int().to_string();
	string[int] fought = split_string(get_property("_locketMonstersFought"),",");
	buffer page;
	string[int] choices;
	string err = "";

	//what mafia knows
	if (mon == $monster[none])
		err += " Invalid monster.";
	if (my_adventures() == 0)
		err += " No adventures to reminisce.";
	if (available_amount($item[combat lover's locket]) == 0)
		err += " Don't own a combat lover's locket?";
	if (fought.count() >= 3)
		err += " Out of locket uses.";
	foreach i,x in fought if (x == monId) {
		err += ` "{mon}" already fought today.`;
		break;
	}
	if (err != "")
		return _c2t_reminisce_error(err);

	//locket choice adventure
	page = visit_url('inventory.php?reminisce=1',false,true);
	choices = xpath(page,'//form[@action="choice.php"]//option/@value');

	if (page.contains_text("You don't want to reminisce any more today."))
		err += " Out of locket uses.";
	else if (page.contains_text("You don't have time to reminisce."))
		err += " Not enough adventures to reminisce.";
	else if (!page.contains_text('>Reminiscing About Those Monsters You Fought</b>'))
		err += " Don't own a combat lover's locket?";
	if (page.contains_text('There are no photos in your locket that you wish to reminisce about.'))
		err += " Need to add monsters to the locket first.";
	if (err != "")
		return _c2t_reminisce_error(err);

	//monster check and choice submission
	foreach i,x in choices if (x == monId) {
		page = visit_url(`choice.php?pwd&whichchoice=1463&option=1&mid={x}`,true,true);
		if (page.contains_text(`<!-- MONSTERID: {x} -->`))
			return true;
		return _c2t_reminisce_error(" The monster was detected in the locket, but combat was not entered?");
	}

	return _c2t_reminisce_error(` "{mon}" not in the selection pool.`);
}

