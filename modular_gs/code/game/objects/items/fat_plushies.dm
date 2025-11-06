#define PLUSHIE_FOOD_VALUE 1
#define PLUSHIE_VORE_VALUE 4
#define PLUSHIE_DIGESTION_TIME_VORE 5 MINUTES
#define PLUSHIE_DIGESTION_TIME_FOOD 2.5 MINUTES

/obj/item/toy/plush
	/// What is the default icon state? This is automatically set on init.
	var/default_icon_state
	/// Do we have fat while something is inside?
	var/vore_icon_state

	/// Is our plushie a mean plushie that eats other plushies?
	var/pred_plush = FALSE
	/// Can our plushie be eaten by pred plushes?
	var/prey_plushie = FALSE

	/// Can our plushie eat food?
	var/can_eat_food = FALSE

	/// How much has this one eaten?
	var/fatness = 0
	/// Fatness to get to max size.
	var/fatness_to_max = 24
	/// What is the max scale we can get our plushie?
	var/max_plushie_scale = 3
	/// What is the value of the last digested item?
	var/last_item_value = 0
	/// How many plushies have we devoured?
	var/devoured_plushies = 0
	/// Are we currently digesting something?
	var/currently_digesting = FALSE

/obj/item/toy/plush/proc/devour_item(obj/item/item_to_devour, mob/living/user)
	if(!istype(item_to_devour, /obj/item/food) && !istype(item_to_devour, /obj/item/toy/plush) && !istype(item_to_devour, /obj/item/stack/sheet/cotton))
		return FALSE

	var/digestion_value = PLUSHIE_FOOD_VALUE
	var/digestion_time = PLUSHIE_DIGESTION_TIME_FOOD
	var/obj/item/toy/plush/devoured_plush = item_to_devour

	if(istype(devoured_plush))
		if(!devoured_plush?.prey_plushie) // Can we devour them?
			to_chat(user, span_warning("[devoured_plush] can't be vored!")) // Silly, but this is plush vore we are talking about. Silly is encouraged.
			return FALSE // We cannot devour them!

		digestion_value = PLUSHIE_VORE_VALUE
		digestion_time = PLUSHIE_DIGESTION_TIME_VORE
		devoured_plushies += 1

	to_chat(user, span_notice("[src] devours the [item_to_devour]!"))

	last_item_value = digestion_value
	qdel(item_to_devour) // It's gone, you monster.
	if(vore_icon_state)
		icon_state = vore_icon_state

	addtimer(CALLBACK(src, PROC_REF(finish_digestion)), digestion_time)

	return TRUE

/obj/item/toy/plush/proc/finish_digestion()
	if(!last_item_value)
		return FALSE

	icon_state = default_icon_state
	fatness += last_item_value
	visible_message(span_notice("[src] seems to get fatter..."))
	last_item_value = 0

	update_scale()
	return TRUE

/obj/item/toy/plush/proc/update_scale()
	var/scaling = 1
	// Math stuff for nerds.
	scaling += (fatness * ((max_plushie_scale - 1) / fatness_to_max))
	scaling = min(scaling, max_plushie_scale) // We don't want them to get larger

	var/matrix/M = matrix()
	transform = M.Scale(scaling)
	return TRUE
