//c2t shrugall
//c2t

//should remove all removeable effects given enough SGEEA to do so

void main(string s) {
	int y;
	foreach x in my_effects() {
		y = have_effect(x);
		if (y > 0 && y < 2147483647 && !x.attributes.contains_text('noremove') && (x.name.contains_text(s) || s == '*'))
			cli_execute(`shrug {x}`);
	}
	print("Should be finished with shrugging all effects.","blue");
}

