//c2t trainSet
//c2t


/* train set part reference
1: meat
2: mp regen
3: all stats
4: hot resist, cold damage
5: stench resist, spooky damage
6: wood, joiners, or stats (orc chasm bridge stuff); never good for CS
7: candy
8: double next stop
9: cold resist, stench damage
11: spooky resist, sleaze damage
12: sleaze resist, hot damage
13: monster level
14: mox stats
15: basic booze
16: mys stats
17: mus stats
18: food drop buff
19: copy last food drop
20: ore
*/

//train pieces are arranged clockwise starting from the upper-left-most position
//input is the form of 1,2,3,4,5,6,7,8
//returns true if successful
//returns false on any error or if train set not ready to be changed
boolean c2t_trainSet(string s) {
	string msg = "";
	if (get_workshed() != $item[model train set])
		msg += " Model train set not in the workshed.";

	//check input
	string [int] x = s.split_string(",");
	//number of elements
	if (x.count() != 8)
		msg += " Number of elements not correct.";
	//extra characters
	foreach i,v in x
		if (v != v.to_int().to_string()) {
			msg += " Invalid characters in configuration.";
			break;
		}
	//bounds
	foreach i,v in x {
		int temp = v.to_int();
		if (temp < 1 || temp > 20 || temp == 10)
			msg += ` "{v}" is not a valid train piece.`;
	}
	//duplication
	int dupe = 0;
	foreach i,v1 in x
		foreach j,v2 in x
			if (v1 == v2)
				dupe++;
	if (dupe > 8)
		msg += " Some elements duplicated.";

	//print errors and exit
	if (msg != "") {
		print(`c2t_trainSet error: {msg}`,"red");
		return false;
	}

	//visit model train set and see if ready to change
	if (!visit_url("campground.php?action=workshed",false,true).contains_text('value="Save Train Set Configuration"')) {
		print("c2t_trainSet error: Model train set not ready to be changed.","red");
		return false;
	}

	//build url and do it
	string doit = "choice.php?pwd&whichchoice=1485&option=1";
	for i from 0 to 7
		doit += `&slot[{i}]={x[i]}`;
	visit_url(doit,true,true);
	print(`c2t_trainSet: Model train set set to {s}`,"blue");
	return true;
}

//CLI
void main(string modelTrainSetConfiguration) {
	c2t_trainSet(modelTrainSetConfiguration);
}

