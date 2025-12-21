//BLUEBERRY CHEM - USED TO ONLY CHANGES PLAYER'S COLOR AND NOTHING MORE. BUT NOW IT MAKES YOU BIG

/// Volume used for all vore noises
#define BLUEBERRY_INFLATION_VOLUME 45
GLOBAL_LIST_INIT(blueberry_growing, list(
	'modular_gs/sound/voice/gurgle1.ogg', 'modular_gs/sound/voice/gurgle2.ogg', 'modular_gs/sound/voice/gurgle3.ogg'
))
GLOBAL_LIST_INIT(blueberry_growing_nearing_limit, list(
	'modular_gs/sound/effects/inflation/creaking/Creak1.ogg', 'modular_gs/sound/effects/inflation/creaking/Creak2.ogg', 'modular_gs/sound/effects/inflation/creaking/Creak3.ogg', 'modular_gs/sound/effects/inflation/creaking/Creak4.ogg'
))
GLOBAL_LIST_INIT(blueberry_growing_about_to_blow, list(
	'modular_gs/sound/effects/inflation/tearing/Tear1.ogg'
))

/datum/reagent/blueberry_juice
	name = "Blueberry Juice"
	description = "Totally infectious."
	//reagent_state = LIQUID
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	color = "#0004ff"
	var/mob_color = "#0004ff"
	//var/list/random_color_list = list("#0058db","#5d00c7","#0004ff","#0057e7")
	taste_description = "blueberry pie"
	var/no_mob_color = FALSE
	// put this back in later value = 10	//it sells. Make that berry factory
	purge_multiplier = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	/// Our sound loop for the inflating sound effect
	var/datum/looping_sound/blueberry_inflation/inflate_loop
	var/loopstarted = FALSE

/datum/reagent/blueberry_juice/on_mob_life(mob/living/carbon/M)
	if(M?.client)
		if(!(M?.client?.prefs?.read_preference(/datum/preference/toggle/blueberry_inflation)))
			M.reagents.remove_reagent(/datum/reagent/blueberry_juice, volume)
			return
		if(!no_mob_color)
			M.add_atom_colour(color, WASHABLE_COLOUR_PRIORITY)
		//M.adjust_fatness(1, FATTENING_TYPE_CHEM)
	if(volume >= 999)
		M.add_quirk(/datum/quirk/permaberry)

	// Add bursting mechanics
	if(M?.client?.prefs?.read_preference(/datum/preference/numeric/helplessness/blueberry_max_before_burst) > 0)
		handle_bursting(M)
	..()

/datum/reagent/blueberry_juice/on_mob_add(mob/living/L, amount)
	if(iscarbon(L))
		var/mob/living/carbon/affected_mob = L
		if(!affected_mob?.client || !(affected_mob?.client?.prefs?.read_preference(/datum/preference/toggle/blueberry_inflation)))
			affected_mob.reagents.remove_reagent(/datum/reagent/blueberry_juice, volume)
			return
		affected_mob.hider_add(src)

		// Start blueberry loop
		if(loopstarted == FALSE)
			loopstarted = TRUE
			affected_mob.blueberry_inflate_loop.start()

		// Play generic gurgle sound every time juice gets added
		playsound(L.loc, pick(GLOB.blueberry_growing), BLUEBERRY_INFLATION_VOLUME, 1, 1, 1.2, ignore_walls = FALSE)

	else
		L.reagents.remove_reagent(/datum/reagent/blueberry_juice, volume)
	..()

/datum/reagent/blueberry_juice/on_mob_delete(mob/living/L)
	if(!iscarbon(L))
		return
	var/mob/living/carbon/C = L
	C.hider_remove(src)
	loopstarted = FALSE
	C.blueberry_inflate_loop.stop()

/datum/reagent/blueberry_juice/proc/fat_hide()
	return (124 * (volume * volume))/1000	//123'840 600% size, about 56'000 400% size, calc was: (3 * (volume * volume))/50

/datum/reagent/blueberry_juice/proc/handle_bursting(mob/living/carbon/M)
	// Change belly sprite and size based on current fullness
	switch(M.reagents.get_reagent_amount(/datum/reagent/blueberry_juice)/M?.client?.prefs?.read_preference(/datum/preference/numeric/helplessness/blueberry_max_before_burst))
		if(0 to 0.7)
			if (prob(5))
				playsound(M.loc, pick(GLOB.blueberry_growing), BLUEBERRY_INFLATION_VOLUME, 1, 1, 1.2, ignore_walls = FALSE)
		if(0.7 to 0.9)
			if (prob(10))
				playsound(M.loc, pick(GLOB.blueberry_growing_nearing_limit), BLUEBERRY_INFLATION_VOLUME, 1, 1, 1.2, ignore_walls = FALSE)
		if(0.9 to INFINITY)
			if (prob(40))
				playsound(M.loc, pick(GLOB.blueberry_growing_nearing_limit), BLUEBERRY_INFLATION_VOLUME, 1, 1, 1.2, ignore_walls = FALSE)

/datum/looping_sound/blueberry_inflation
	mid_sounds = list('modular_gs/sound/effects/inflation/berryloop.ogg')
	mid_length = 8 SECONDS
	volume = 15

// /obj/item/food/meat/steak/troll
// 	name = "Troll steak"
// 	desc = "In its sliced state it remains dormant, but once the troll meat comes in contact with stomach acids, it begins a perpetual cycle of constant regrowth and digestion. You probably shouldn't eat this."
// 	var/hunger_threshold = NUTRITION_LEVEL_FULL
// 	var/nutrition_amount = 20 // somewhere around 5 pounds
// 	var/fullness_to_add = 10
// 	var/message = "<span class='notice'>You feel fuller...</span>" // GS13

