/obj/structure/scale/ui_data(mob/user)
	var/list/data = list()
	data["currently_weighing"] = currently_weighing
	data["most_recent_carbon"] = most_recent_carbon

	var/able_to_weigh = (currently_weighing && istype(most_recent_carbon))
	data["able_to_weigh"] = able_to_weigh
	if(able_to_weigh)
		weight_datum.weigh(most_recent_carbon)

	data["total_weight"] = weight_datum.total_weight
	data["total_weight_pounds"] = weight_datum.total_weight_pounds
	data["total_fatness"] = weight_datum.fatness_total
	data["total_fatness_pounds"] = weight_datum.fatness_total_pounds
	data["total_muscle"] = weight_datum.muscle_total
	data["total_muscle_pounds"] = weight_datum.muscle_total_pounds

	data["wg_rate"] = "[weight_datum.weight_gain_rate * 100]%"
	data["wl_rate"] = "[weight_datum.weight_loss_rate * 100]%"
	data["mg_rate"] = "[weight_datum.muscle_gain_rate * 100]%"
	data["ml_rate"] = "[weight_datum.muscle_loss_rate * 100]%"

	data["weight_data"] = list()
	// Time for list bullshit :3
	var/list/weight_data = weight_datum.generate_list()
	for(var/category as anything in weight_data) // Go through all the different generated categories
		var/list/parsed_data_points = list()
		var/list/unparsed_data_points = weight_data[category]
		var/muscle_category = FALSE

		if(findtext(category, "Muscle"))
			muscle_category = TRUE


		for(var/data_point as anything in unparsed_data_points) // Parse a data point and add it to parsed_data_points
			var/data_point_as_list = list(
				"name" = data_point,
				"pounds" = unparsed_data_points[data_point][1],
				"value" = unparsed_data_points[data_point][2],
			)
			parsed_data_points += list(data_point_as_list)

		var/category_data = list(
			"name" = category,
			"data_points" = parsed_data_points,
			"muscle_category" = muscle_category,
		)
		data["weight_data"] += list(category_data)

	return data

/obj/structure/scale/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ScalePanel", src)
		ui.open()

