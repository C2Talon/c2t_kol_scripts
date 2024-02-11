//fix_homemade_robot
//by c2t

//sets homemade robot property to max if mafia disagrees with its level by 99
//anything less or more could be an unknown-to-mafia passive buff affecting it, so checking for anything less than max would be much more unreliable


//get fam level from api
int c2t_apiFamLevel() {
	string page = visit_url("api.php?what=status&for=c2t_fixHomemadeRobot+by+c2t",false,true);
	matcher mat = create_matcher('"famlevel":(\\d+)',page);
	if (mat.find())
		return mat.group(1).to_int();
	return 0;
}

//fix homemade robot property
void c2t_fixHomemadeRobot() {
	familiar robot = $familiar[homemade robot];
	familiar fam = my_familiar();
	item equip = equipped_item($slot[familiar]);
	string prop = "homemadeRobotUpgrades";

	if (!have_familiar(robot)
		|| get_property(prop).to_int() != 0)
	{
		return;
	}
	use_familiar(robot);
	if (c2t_apiFamLevel() == familiar_weight(my_familiar()) + weight_adjustment() + 99)
		set_property(prop,9);
	use_familiar(fam);
	equip($slot[familiar],equip);
}

void main() c2t_fixHomemadeRobot();

