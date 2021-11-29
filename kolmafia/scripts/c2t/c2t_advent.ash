//c2t advent
//c2t

void main() {
	int month = format_date_time("yyyyMMdd",today_to_string(),"M").to_int();
	int day = format_date_time("yyyyMMdd",today_to_string(),"d").to_int();
	if (month == 12 || (month == 1 && day < 19)) {
		print("Opening all available advent calendar stuff","blue");
		buffer buf = visit_url("campground.php?action=advent");
		for i from 1 to 25 {
			if (buf.contains_text("preaction=openadvent&whichadvent="+i));
				visit_url("campground.php?preaction=openadvent&whichadvent="+i);
		}
		print("Also, checking factory:","blue");
		visit_url("place.php?whichplace=crimbo20&action=c20_factory");
	}
}

