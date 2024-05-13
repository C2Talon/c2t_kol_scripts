//c2t mayam
//c2t

since r27930;//mayam resonance


//--declarations--

//mayam functions: each returns true if the mayam calendar gave something

//input as symbols in map form
boolean c2t_mayam(string[4] symbols);
boolean c2t_mayam(boolean[string] symbols);

//input as symbols as a single string, each seperated by a space
boolean c2t_mayam(string symbols);

//input as each symbol as seperate string
boolean c2t_mayam(string s1,string s2,string s3,string s4);

//get specific bonus effect or item
boolean c2t_mayam(effect eff);
boolean c2t_mayam(item ite);

//submit random available symbols
boolean c2t_mayam();

//--implementations--

boolean _c2t_mayam(string s) {
	if (item_amount($item[mayam calendar]) == 0)
		return false;
	string pref = "_mayamSymbolsUsed";
	string start = get_property(pref);
	cli_execute(`try;mayam {s}`);
	return start != get_property(pref);
}
boolean c2t_mayam(string[4] symbols) {
	return _c2t_mayam(`rings {symbols[0]} {symbols[1]} {symbols[2]} {symbols[3]}`);
}
boolean c2t_mayam(boolean[string] symbols) {
	string[4] out;
	int i = 0;
	foreach x in symbols
		out[i++] = x;
	return c2t_mayam(out);
}
boolean c2t_mayam(string symbols) {
	string[4] out = split_string(symbols," ");
	return c2t_mayam(out);
}
boolean c2t_mayam(string s1,string s2,string s3,string s4) {
	string[4] out = {s1,s2,s3,s4};
	return c2t_mayam(out);
}
boolean c2t_mayam(effect eff) {
	return _c2t_mayam(`resonance {eff}`);
}
boolean c2t_mayam(item ite) {
	return _c2t_mayam(`resonance {ite}`);
}
boolean c2t_mayam() {
	string[int] used = get_property("_mayamSymbolsUsed").split_string(",");
	string[4] out;

	//get out early if uses exhausted
	if (used.count() >= 12)
		return false;

	int[string] prefToRing = {
		"yam4":3,
		"clock":3,
		"explosion":3,
		"yam3":2,
		"eyepatch":2,
		"cheese":2,
		"wall":2,
		"yam2":1,
		"lightning":1,
		"bottle":1,
		"wood":1,
		"meat":1,
		"yam1":0,
		"sword":0,
		"vessel":0,
		"fur":0,
		"chair":0,
		"eye":0,
		};
	boolean[4,string] available = {
		{"yam":true,"sword":true,"vessel":true,"fur":true,"chair":true,"eye":true},
		{"yam":true,"lightning":true,"bottle":true,"wood":true,"meat":true},
		{"yam":true,"eyepatch":true,"cheese":true,"wall":true},
		{"yam":true,"clock":true,"explosion":true},
		};
	//remove unavailable symbols
	foreach i,x in used {
		string temp = x.starts_with("yam") ? "yam" : x;
		remove available[prefToRing[x],temp];
	}
	//pick random available symbols
	for i from 0 to 3 {
		int size = available[i].count();
		if (size == 0)
			return false;
		int pick = size == 1 ? 0 : random(size);
		int j = -1;
		foreach key,value in available[i] if (++j == pick) {
			out[i] = key;
			break;
		}
	}
	return c2t_mayam(out);
}

