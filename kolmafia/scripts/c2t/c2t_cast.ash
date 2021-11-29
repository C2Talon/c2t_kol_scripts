//c2t cast
//c2t

//multicasting for skills that don't really multicast well with mafia methods
//current skills supported are blood skills and powerful glove skills

//this function will burn all health on a blood skill or all charges on a powerful glove skill
//ski is the skill to use
//returns true if the skill was cast at least 1 time
boolean c2t_burn(skill ski);

//cast a blood skill or powerful glove skill
//num is the number of times to cast
//ski is the skill to use
//returns true if the skill was cast at least 1 time
boolean c2t_cast(int num,skill ski);
//single-cast version
boolean c2t_cast(skill ski);


//probably don't use these 2 in a script, as name and such subject to change
boolean c2t_castBlood(int num,skill ski);
boolean c2t_castGlove(int num,skill ski);

//helper function
string _c2t_cast_joinNotFirst(string [int] arr) {
	string out;
	for i from 1 to (count(arr)-1)
		out += (i == 1?arr[i]:` {arr[i]}`);
	return out;
}



//handler if script is called directly via cli
//arg is whichever case that is wanted to enter
void main(string arg) {
	string [int] split = split_string(arg," ");
	string str;
	int num;
	skill ski;

	//parse arg
	if (split[0].to_float().to_int() > 0) {
		num = split[0].to_float().to_int();
		str = _c2t_cast_joinNotFirst(split);
	}
	else if (split[0].to_float().to_int() < 0) {
		print(`Cannot cast a negative number of times`,"red");
		return;
	}
	else if (split[0] == '0') {
		print(`Cannot cast something zero times`,"red");
		return;
	}
	else if (split[0] == '*') {
		num = -1;
		str = _c2t_cast_joinNotFirst(split);
	}
	else {
		num = 1;
		str = arg;
	}

	switch (to_lower_case(str)) {
		case 'blood bubble':
		case 'bubble':
			ski = $skill[Blood Bubble];
			break;
		case 'blood bond':
		case 'bond':
			ski = $skill[Blood Bond];
			break;
		case 'blood frenzy':
		case 'frenzy':
			ski = $skill[Blood Frenzy];
			break;
		case 'triple size':
		case 'triple':
			ski = $skill[CHEAT CODE: Triple Size];
			break;
		case 'invisible avatar':
		case 'invisible':
		case 'invis':
			ski = $skill[CHEAT CODE: Invisible Avatar];
			break;
		default://fuzzy matching?
			ski = str.to_skill();
	}

	c2t_cast(num,ski);
}

//functions for use in scripts
boolean c2t_burn(skill ski) {
	return c2t_cast(-1,ski);
}
boolean c2t_cast(skill ski) {
	return c2t_cast(1,ski);
}
boolean c2t_cast(int num,skill ski) {
	switch (ski) {
		case $skill[Blood Bubble]:
		case $skill[Blood Bond]:
		case $skill[Blood Frenzy]:
			return c2t_castBlood(num,ski);
		case $skill[CHEAT CODE: Triple Size]:
		case $skill[CHEAT CODE: Invisible Avatar]:
			return c2t_castGlove(num,ski);
		default:
			print(`{ski} is an invalid skill for c2t_cast`,"red");
			return false;
	}
}

//multicast blood skills
boolean c2t_castBlood(int num,skill spell) {
	int max = my_hp()%30 > 0 ? my_hp()/30 : (my_hp()/30)-1;
	int casts = (num >= 0?num:max);

	//errors
	if (!have_skill(spell)) {
		print(`{spell} is not a skill that you have.`,"red");
		return false;
	}
	if (spell != $skill[Blood Bubble] && spell != $skill[Blood Bond] && spell != $skill[Blood Frenzy]) {
		print(`{spell} is an invalid skill to burn health`,"red");
		return false;
	}
	if (max <= 0) {
		print(`HP too low to cast {spell}.`,"red");
		return false;
	}
	if (casts == 0) {
		print(`"{num}" is invalid for number of times to cast {spell}.`,"red");
		return false;
	}
	if (casts > max) {
		print(`Cannot cast {spell} {casts} times. Will cast it {max} times though.`,"blue");
		casts = max;
	}

	//do the thing
	return use_skill(casts,spell);
}

//multicast powerful glove skills
boolean c2t_castGlove(int num,skill spell) {
	int max = 20 - get_property('_powerfulGloveBatteryPowerUsed').to_int()/5;
	int casts = (num >= 0?num:max);

	//errors
	if (available_amount($item[Powerful Glove]) == 0) {
		print("Powerful Glove not found to use","red");
		return false;
	}
	if (spell != $skill[CHEAT CODE: Triple Size] && spell != $skill[CHEAT CODE: Invisible Avatar]) {
		print(`{spell} is an invalid skill to use Powerful Glove charges`,"red");
		return false;
	}
	if (max <= 0) {
		print("Powerful Glove charges already used","red");
		return false;
	}
	if (casts == 0) {
		print(`"{num}" is invalid for number of times to cast {spell}.`,"red");
		return false;
	}
	if (casts > max) {
		print(`Cannot cast {spell} {casts} times. Will cast it {max} times though.`,"blue");
		casts = max;
	}

	//swap in powerful glove to acc3 if need be; fourth implementation at trying to make a swap work 100% is a charm?
	item ite = $item[none];
	if (!have_equipped($item[Powerful Glove])) {
		ite = equipped_item($slot[acc3]);
		equip($slot[acc3],$item[Powerful Glove]);
	}

	//this will spam the CLI, so give some heads up:
	if (casts > 1)
		print(`Casting {spell} {casts} times...`,"blue");
	//do the thing
	for i from 1 to casts
		use_skill(1,spell);

	//reequip former acc3 item
	if (ite != $item[none])
		equip($slot[acc3],ite);

	return true;
}

