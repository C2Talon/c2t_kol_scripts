//c2t stache tracker
//c2t

/*-=-+-=-+-=-+-=-
method to track which buff from the Daylight Shavings Helmet was last obtained and which one is expected to be next
either add this script as the post-adventure script or call it inside a post-adventure script to get the most out of it

warning: the tracking will fall apart if you manipulate your buffs in such a way as to have 2 or more non-sequential buffs

properties this uses:
"c2t_stacheAscension" -- simply tracks if this script has been run in the current ascension to reset the trackers
"c2t_stacheLast" -- contains the name of the last buff obtained
"c2t_stacheNext" -- contains the name of the next buff that is expected
-=-+-=-+-=-+-=-*/

string propAsc = "c2t_stacheAscension";
string propNext = "c2t_stacheNext";
string propLast = "c2t_stacheLast";

effect [int] staches = {
	$effect[Spectacle Moustache],
	$effect[Toiletbrush Moustache],
	$effect[Barbell Moustache],
	$effect[Grizzly Beard],
	$effect[Surrealist's Moustache],
	$effect[Musician's Musician's Moustache],
	$effect[Gull-Wing Moustache],
	$effect[Space Warlord's Beard],
	$effect[Pointy Wizard Beard],
	$effect[Cowboy Stache],
	$effect[Friendly Chops]
	};

//generate order and index for current class
effect [int] order;
int [effect] index;
for i from 0 to 10 {
	if (to_int(my_class()) <=6)
		order[i] = staches[(to_int(my_class()) * i) % 11];
	else
		order[i] = staches[((to_int(my_class()) % 6) + 1) % 11];//need to double check
	index[order[i] ] = i;
}

effect c2t_nextStache(effect eff) {
	if (index contains eff)
		return order[(index[eff] + 1) % 11];
	return $effect[none];
}

effect c2t_findStache() {
	foreach i,eff in order {
		if (have_effect(eff) > 0) {
			if (i == 10 || have_effect(order[i+1]) == 0)
				return eff;
			else
				return order[i+1];
		}
	}
	return $effect[none];
}

void c2t_stacheTracker() {
	effect last,next;
	if (get_property(propAsc).to_int() != my_ascensions()) {
		set_property(propAsc,my_ascensions().to_string());
		set_property(propLast,"");
		set_property(propNext,"");
	}
	last = c2t_findStache();
	next = c2t_nextStache(last);
	if (last != $effect[none]) {
		set_property(propLast,last.to_string());
		set_property(propNext,next.to_string());
	}
}

void main() c2t_stacheTracker();

