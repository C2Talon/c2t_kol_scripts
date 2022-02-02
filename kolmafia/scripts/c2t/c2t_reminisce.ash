//c2t reminisce
//c2t

//enter combat with a monster from combat lover's locket


//tries to enter combat with monster `mon`
//returns `true` if successful
boolean c2t_reminisce(monster mon);

//for the cli
//`arg` is name of monster to fight from the locket. A monster's ID number should also work to disambiguate same-named monsters.
void main (string arg) {
	if (!c2t_reminisce(arg.to_monster())) {
		print(`Combat was not entered with {arg.to_monster()}`,"red");
		return;
	}
	print(`Should be in combat with {arg.to_monster()}`,"blue");
}

boolean c2t_reminisce(monster mon) {
	buffer page = visit_url('inventory.php?reminisce=1',false,true);
	string[int] choices = xpath(page,'//form[@action="choice.php"]//option/@value');
	string err = "";

	if (mon == $monster[none])
		err += " Invalid monster.";
	if (page.contains_text("You don't want to reminisce any more today."))
		err += " Out of locket uses.";
	else if (!page.contains_text('<b>Reminiscing About Those Monsters You Fought</b>'))
		err += " Don't own a combat lover's locket?";
	if (page.contains_text('There are no photos in your locket that you wish to reminisce about.'))
		err += " Need to add monsters to the locket first.";

	if (err != "") {
		print(`c2t_reminisce errors:{err}`,"red");
		visit_url('main.php');//exit the choice for mafia
		return false;
	}

	//mon check
	foreach i,x in choices
		if (x.to_monster() == mon) {
			visit_url(`choice.php?pwd&whichchoice=1463&option=1&mid={x}`,true,true);
			return true;
		}

	print(`c2t_reminisce errors: "{mon}" not in the selection pool`,"red");
	visit_url('main.php');//exit the choice for mafia
	return false;
}

