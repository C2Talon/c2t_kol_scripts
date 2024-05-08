//c2t apriling
//c2t

//functions to handle apriling stuff

since r27888;//apriling band properties


//--declarations--

//all the variations to get things
//returns true if some or all obtained
boolean c2t_apriling(effect eff,item it1,item it2);
boolean c2t_apriling(item it1,effect eff,item it2);
boolean c2t_apriling(item it1,item it2,effect eff);
boolean c2t_apriling(effect eff,item it1);
boolean c2t_apriling(item it1,effect eff);
boolean c2t_apriling(item it1,item it2);
boolean c2t_apriling(effect eff);
boolean c2t_apriling(item it1);

//play an item
//returns true on success
boolean c2t_aprilingPlay(item ite);


//--implementations--

boolean c2t_apriling(effect eff,item it1,item it2) {
	//can't get what you don't have
	if (available_amount($item[apriling band helmet]) == 0)
		return false;

	boolean[effect] effects = $effects[
		apriling band patrol beat,
		apriling band battle cadence,
		apriling band celebration bop
		];
	boolean[item] items = $items[
		apriling band saxophone,
		apriling band quad tom,
		apriling band tuba,
		apriling band staff,
		apriling band piccolo
		];
	boolean [int] go;
	int successes = 0;

	//figure out which options to choose
	if (have_effect(eff) == 0
		&& effects contains eff
		&& get_property("nextAprilBandTurn").to_int() <= total_turns_played())
	{
		go[eff.id - $effect[apriling band patrol beat].id + 1] = true;
	}
	if (available_amount(it1) == 0
		&& items contains it1
		&& get_property("_aprilBandInstruments").to_int() < 2)
	{
		go[it1.id - $item[apriling band saxophone].id + 4] = true;
	}
	if (available_amount(it2) == 0
		&& items contains it2
		&& get_property("_aprilBandInstruments").to_int() < 2)
	{
		go[it2.id - $item[apriling band saxophone].id + 4] = true;
	}

	//already have everything, or all options invalid
	if (go.count() == 0)
		return false;

	//get to choice adventure
	if (!handling_choice() || last_choice() != 1526) {
		visit_url(`inventory.php?pwd={my_hash()}&action=apriling`,false,true);
		if (!handling_choice() || last_choice() != 1526)
			return false;
	}

	//go get 'em
	foreach x in go
		successes += run_choice(x).contains_text("You acquire an ") ? 1 : 0;

	return successes > 0;
}
boolean c2t_apriling(item it1,effect eff,item it2) {
	return c2t_apriling(eff,it1,it2);
}
boolean c2t_apriling(item it1,item it2,effect eff) {
	return c2t_apriling(eff,it1,it2);
}
boolean c2t_apriling(effect eff,item it1) {
	return c2t_apriling(eff,it1,$item[none]);
}
boolean c2t_apriling(item it1,effect eff) {
	return c2t_apriling(eff,it1,$item[none]);
}
boolean c2t_apriling(item it1,item it2) {
	return c2t_apriling($effect[none],it1,it2);
}
boolean c2t_apriling(effect eff) {
	return c2t_apriling(eff,$item[none],$item[none]);
}
boolean c2t_apriling(item it1) {
	return c2t_apriling($effect[none],it1,$item[none]);
}
boolean c2t_aprilingPlay(item ite) {
	int start = ite.dailyusesleft;

	if (available_amount(ite) == 0)
		return false;
	if (start == 0)
		return false;

	boolean[item] items = $items[
		apriling band saxophone,
		apriling band quad tom,
		apriling band tuba,
		apriling band staff,
		apriling band piccolo
		];
	if (!(items contains ite))
		return false;

	visit_url(`inventory.php?pwd={my_hash()}&iid={ite.id}&action=aprilplay`,false,true);

	return ite.dailyusesleft != start;
}

