//c2t
//c2t capeMe


//wrapper for the CLI command "retrocape" to have arguments that have meaning
//mostly because I'm never going to remember which combo of things do what
void main(string arg) {
	switch (to_lower_case(arg)) {
		//===MUSCLE CAPES===
		//+3 to all resists
		case "ele":
		case "elemental":
		case "elemental resistance":
		case "ele res":
		case "res ele":
		case "res":
		case "resistance":
			cli_execute("retrocape vampire hold");
			break;
		//extra mus stats at end of combat
		case "mus":
		case "mus stat":
		case "mus stats":
		case "muscle":
		case "muscle stat":
		case "muscle stats":
			cli_execute("retrocape vampire thrill");
			break;
		//grants skill to lifesteal
		case "life steal":
		case "lifesteal":
			cli_execute("retrocape vampire kiss");
			break;
		//grants skill to instantly kill undead if wielding sword
		case "undead":
			cli_execute("retrocape vampire kill");
			break;

		//===MYSTICALITY CAPES===
		//stuns enemies at start of combat
		case "stun":
			cli_execute("retrocape heck hold");
			break;
		//extra mys stats at end of combat
		case "mys":
		case "mys stat":
		case "mys stats":
		case "mysticality":
		case "mysticality stat":
		case "mysticality stats":
			cli_execute("retrocape heck thrill");
			break;
		//grants skill that is a yellow ray that gives 100 turns of "everything looks yellow"
		case "yellow ray":
		case "yellowray":
		case "yr":
			cli_execute("retrocape heck kiss");
			break;
		//spells deal spooky damage in addition to what they already do
		case "lantern":
			cli_execute("retrocape heck kill");
			break;

		//===MOXIE CAPES===
		//grants skill to delevel enemies 10%, or 20% on constructs
		case "delevel":
			cli_execute("retrocape robot hold");
			break;
		//extra mox stats at end of combat
		case "mox":
		case "mox stat":
		case "mox stats":
		case "moxie":
		case "moxie stat":
		case "moxie stats":
			cli_execute("retrocape robot thrill");
			break;
		//grants a sleaze damage skill
		case "sleaze":
			cli_execute("retrocape robot kiss");
			break;
		//grants skill that auto-crits if wielding a gun
		case "crit gun":
			cli_execute("retrocape robot kill");
			break;

		//help?
		case "help":
			print("valid arguments: mus | res | lifesteal | undead | mys | stun | yr | lantern | mox | delevel | sleaze | crit gun");
			break;

		default:
			print(`"{arg}" is an invalid argument for c2t_capeme. Try "c2t_capeme help" for valid arguments.`,"red");
	}
}

