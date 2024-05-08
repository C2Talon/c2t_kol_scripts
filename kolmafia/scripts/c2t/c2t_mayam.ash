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

