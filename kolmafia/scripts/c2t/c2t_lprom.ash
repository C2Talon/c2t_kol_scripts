//c2t lprom
//c2t

//uses the warbear LP-ROM burner to automatically make recordings of skills, using magical sausages to fuel it

//need to prep:
//make sure to wear something that gives alot of MP; probably best with at least 1000 MP
//make sure to have at least as much pre-made magical sausages as it would cost to burn stuff
//if the script ends up having to make a magical sausage, it will break since it changes to the kramco choice adventure
//if mafia tracking breaks somehow, this will likely break as well and probably would need to be finished manually


//import and use this function
//sausageMode is whether to eat magical sausages to restore MP or not
//false will use mafia's restore_mp() to restore MP
boolean c2t_lprom(boolean sausageMode);

//default sausageMode to true if no argument
boolean c2t_lprom() return c2t_lprom(true);

//helper functions to get to and leave the LP-ROM
buffer c2t_lprom_enter();
buffer c2t_lprom_leave() return visit_url('choice.php?pwd&option=2&whichchoice=821',true,true);
boolean c2t_lprom_error(string str);

//running from the CLI is fine
void main() c2t_lprom();


boolean c2t_lprom(boolean sausageMode) {
	//check campground for LP-ROM
	if (!(get_campground() contains $item[warbear LP-ROM burner])) {
		print("Campground does not contain an LP-ROM, so skipping the recording of skills");
		//only want to return false if it is possible to make the recordings in the first place, but fails to deliver
		return true;
	}

	buffer buf;//for visit_url() results
	int num;//number of casts
	int lim;//infinite loop detection in case of mafia tracking breakage
	int sau;//number of sausages to eat
	int used = 0;//tracking times LP-ROM used
	int useLimit = 37;//limit times to use LP-ROM as infinite loop protection

	//just doing it this way so don't have to deal with things changing text, such as April fools stuff
	skill [int] lpromit;
	lpromit[530] = $skill[The Ballad of Richie Thingfinder];
	lpromit[531] = $skill[Benetton's Medley of Diversity];
	lpromit[532] = $skill[Elron's Explosive Etude];
	lpromit[533] = $skill[Chorale of Companionship];
	lpromit[534] = $skill[Prelude of Precision];
	lpromit[614] = $skill[Donho's Bubbly Ballad];
	lpromit[716] = $skill[Inigo's Incantation of Inspiration];

	//get to the LP-ROM
	buf = c2t_lprom_enter();
	//if (!buf.contains_text('name="whichchoice" value="821"'))
	//	return c2t_lprom_error("failed to enter the LP-ROM choice adventure");

	//do the thing
	foreach id, ski in lpromit {
		while (ski.dailylimit > 0) {
			//break out of a possible infinite loop if too many tries
			if (++used > useLimit)
				return c2t_lprom_error(`possibly was stuck in an infinite loop; used the LP-ROM {used-1} times and didn't finish`);

			//restore MP with magical sausages or with mafia's built-in function with the user's settings
			if (my_mp() < mp_cost(ski)) {
				if (sausageMode) {
					if (get_property('_sausagesEaten').to_int() >= 23)
						return c2t_lprom_error("maximum magical sausages already eaten for the day");

					sau = (my_maxmp()-my_mp())/999;
					//6750 MP to make all recordings, so don't eat more than 7 sausages at a time, but also eat at least 1
					eat(sau==0?1:(sau > 7?7:sau),$item[magical sausage]);

					if (my_mp() < mp_cost(ski))
						return c2t_lprom_error("was unable to restore MP with magical sausages");
				}
				else {
					//6750 MP to make all recordings normally; not sure if this will behave badly with low maxmp, though hopefully keep people with really high MP sated
					restore_mp(7000);
					if (my_mp() < mp_cost(ski))
						return c2t_lprom_error("was not able to restore MP with mafia's built-in restoration");
				}
			}

			//record via LP-ROM
			lim = ski.dailylimit;
			num = my_mp()/mp_cost(ski) > lim?lim:my_mp()/mp_cost(ski);
			buf = visit_url('choice.php?pwd&option=1&whichchoice=821&whicheffect='+id+'&times='+num,true,true);

			//break out of an infinite loop if mafia tracking breaks
			if (lim == ski.dailylimit) {
				print(`Skill tracking for {ski} probably broke, so skipping trying to finish making recordings of it`,"red");
				break;
			}
		}
	}

	//exit the LP-ROM
	c2t_lprom_leave();
	print("Should be finished using the LP-ROM to burn things","blue");
	return true;
}

boolean c2t_lprom_error(string str) {
	print(`c2t_lprom error: {str}`,"red");
	c2t_lprom_leave();
	return false;
}

buffer c2t_lprom_enter() {
	visit_url('campground.php?action=workshed',false,true);
	return visit_url('campground.php?action=lprom',true,true);
}

