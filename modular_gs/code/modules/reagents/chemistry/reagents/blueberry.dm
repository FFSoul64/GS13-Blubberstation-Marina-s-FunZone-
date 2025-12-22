//BLUEBERRY CHEM - USED TO ONLY CHANGES PLAYER'S COLOR AND NOTHING MORE. BUT NOW IT MAKES YOU BIG

/// Volume used for all blueberry noises
#define BLUEBERRY_INFLATION_VOLUME 45

#define BURST_IMMEDIATELY "Burst immediately"
#define DELAY_BURST "Delay bursting"
#define DELAY_BURST_MODIFIER 0.1

#define BLUEBERRY_SPILL_BELLY "<span class='warning'>You feel a wetness spread on your belly as juice leaks out of your belly button!</span>"
#define BLUEBERRY_SPILL_PENIS "<span class='warning'>You feel your cock tingle as it leaks out juice!</span>"
#define BLUEBERRY_SPILL_VAGINA "<span class='warning'>You feel your pussy tingle as it leaks out juice!</span>"
#define BLUEBERRY_SPILL_BREASTS "<span class='warning'>You feel your breasts tighten, as juice leaks out of your nipples!</span>"

#define BLUEBERRY_SPLASH_BELLY "<span class='warning'>You feel pressure and wetness spread on your belly as juice splutters out of your belly button!</span>"
#define BLUEBERRY_SPLASH_PENIS "<span class='warning'>You feel your cock twitch as waves of juice surge out!</span>"
#define BLUEBERRY_SPLASH_VAGINA "<span class='warning'>You feel your pussy twitch as waves of juice surge out!</span>"
#define BLUEBERRY_SPLASH_BREASTS "<span class='warning'>The pressure in your breasts becomes too much, as you feel juice start to spray out of your nipples!</span>"
#define BLUEBERRY_SPLASH_AMOUNT_PERCENTAGE 2
#define BLUEBERRY_SPLASH_AMOUNT_MAX 100

GLOBAL_LIST_INIT(blueberry_growing, list(
	'modular_gs/sound/voice/gurgle1.ogg', 'modular_gs/sound/voice/gurgle2.ogg', 'modular_gs/sound/voice/gurgle3.ogg'
))
GLOBAL_LIST_INIT(blueberry_growing_nearing_limit, list(
	'modular_gs/sound/effects/inflation/creaking/Creak1.ogg', 'modular_gs/sound/effects/inflation/creaking/Creak2.ogg', 'modular_gs/sound/effects/inflation/creaking/Creak3.ogg', 'modular_gs/sound/effects/inflation/creaking/Creak4.ogg'
))
GLOBAL_LIST_INIT(blueberry_burst, list(
	'modular_gs/sound/effects/inflation/pop/blueberry-inflation-pop.ogg'
))

GLOBAL_LIST_INIT(blueberry_growing_flavour, list(
	"<span class='danger'>Oof... Your belly groans as you feel the juice slosh inside you!</span>",
	"<span class='danger'>You feel like a juice filled balloon!</span>"
	))

GLOBAL_LIST_INIT(blueberry_nearing_limit__flavour, list(
	"<span class='danger'>The pressure is getting unbearable! Your body softly creaks under as it's struggling to contain all the juice inside you!</span>",
	"<span class='danger'>Your body creaks and stretches, as your tight body tries to find more space for the juice!</span>"
	))

GLOBAL_LIST_INIT(blueberry_about_to_blow_flavour, list(
	"<span class='danger'>Oh god... too big...</span>",
	"<span class='danger'>It's too much! I'm gonna pop!</span>",
	"<span class='danger'>I can't...</span>"
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

/datum/reagent/blueberry_juice/on_mob_life(mob/living/carbon/M, seconds_per_tick)
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
		handle_bursting(M, seconds_per_tick)
	..()

/datum/reagent/blueberry_juice/on_mob_add(mob/living/L, amount)
	if(iscarbon(L))
		var/mob/living/carbon/affected_mob = L
		if(!affected_mob?.client || !(affected_mob?.client?.prefs?.read_preference(/datum/preference/toggle/blueberry_inflation)))
			affected_mob.reagents.remove_reagent(/datum/reagent/blueberry_juice, volume)
			return
		affected_mob.hider_add(src)

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
	C.blueberry_inflate_loop.stop()

/datum/reagent/blueberry_juice/proc/fat_hide()
	return (124 * (volume * volume))/1000	//123'840 600% size, about 56'000 400% size, calc was: (3 * (volume * volume))/50

/datum/reagent/blueberry_juice/proc/handle_bursting(mob/living/carbon/M, seconds_per_tick)
	switch((M.reagents.get_reagent_amount(/datum/reagent/blueberry_juice)/M?.client?.prefs?.read_preference(/datum/preference/numeric/helplessness/blueberry_max_before_burst)))
		if(0 to 0.7)
			if (SPT_PROB(5, seconds_per_tick))
				playsound(M.loc, pick(GLOB.blueberry_growing), BLUEBERRY_INFLATION_VOLUME, 1, 1, 1.2, ignore_walls = FALSE)
				M.visible_message("<span class='warning'>[M]'s belly let's out an audible groan as the juice sloshes inside them!</span>", pick(GLOB.blueberry_growing_flavour))
			if (SPT_PROB(1, seconds_per_tick))
				splatter_juice(M)
		if(0.7 to 0.9)
			if (SPT_PROB(10, seconds_per_tick))
				M.visible_message("<span class='warning'>[M]'s body softly creaks under the strain of being filled with juice!</span>", pick(GLOB.blueberry_nearing_limit__flavour))
				playsound(M.loc, pick(GLOB.blueberry_growing_nearing_limit), BLUEBERRY_INFLATION_VOLUME, 1, 1, 1.2, ignore_walls = FALSE)
			if (SPT_PROB(5, seconds_per_tick))
				splatter_juice(M)
		if(0.9 to INFINITY)
			if (SPT_PROB(15, seconds_per_tick))
				M.visible_message("<span class='warning'>[M]'s body softly creaks under the strain of being filled with juice!</span>", pick(GLOB.blueberry_about_to_blow_flavour))
				playsound(M.loc, pick(GLOB.blueberry_growing_nearing_limit), BLUEBERRY_INFLATION_VOLUME, 1, 1, 1.2, ignore_walls = TRUE)
			if (SPT_PROB(35, seconds_per_tick))
				splatter_juice(M)
			if (SPT_PROB(5, seconds_per_tick))
				splatter_juice(M, TRUE)

	if((M.reagents.get_reagent_amount(/datum/reagent/blueberry_juice)/M?.client?.prefs?.read_preference(/datum/preference/numeric/helplessness/blueberry_max_before_burst)) > (1 + M.burst_delay_modifier))
		M.handle_burst()


/datum/reagent/blueberry_juice/proc/splatter_juice(mob/living/carbon/M, var/puddle = FALSE)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H= M

	var/list/possible_descriptions = list()
	if(puddle)
		H.add_juice_splatter_floor(get_turf(H), TRUE)
		possible_descriptions.Add(BLUEBERRY_SPLASH_BELLY)
		if(H.has_vagina())
			possible_descriptions.Add(BLUEBERRY_SPLASH_VAGINA)
		if(H.has_penis())
			possible_descriptions.Add(BLUEBERRY_SPLASH_PENIS)
		if(H.has_breasts())
			possible_descriptions.Add(BLUEBERRY_SPLASH_BREASTS)
		H.try_lewd_autoemote("moan")
	else
		H.add_juice_splatter_floor(get_turf(H), FALSE)
		possible_descriptions.Add(BLUEBERRY_SPILL_BELLY)
		if(H.has_vagina())
			possible_descriptions.Add(BLUEBERRY_SPILL_VAGINA)
		if(H.has_penis())
			possible_descriptions.Add(BLUEBERRY_SPILL_PENIS)
		if(H.has_breasts())
			possible_descriptions.Add(BLUEBERRY_SPILL_BREASTS)
		H.try_lewd_autoemote("blush")

	to_chat(H, pick(possible_descriptions))


/datum/looping_sound/blueberry_inflation
	mid_sounds = list('modular_gs/sound/effects/inflation/berryloop.ogg')
	mid_length = 8 SECONDS
	volume = BLUEBERRY_INFLATION_VOLUME

// Add BB Inflation related stuff to carbon
/mob/living/carbon
	var/datum/looping_sound/blueberry_inflation/blueberry_inflate_loop
	var/burst_delay_modifier = DELAY_BURST_MODIFIER
	var/burst_triggered = FALSE


/mob/living/carbon/Initialize(mapload)
	. = ..()
	blueberry_inflate_loop = new(src, FALSE)

/mob/living/carbon/Destroy()
	QDEL_NULL(blueberry_inflate_loop)
	return ..()

/mob/living/carbon/proc/handle_burst()
	if (burst_triggered) // Don't open a thousand windows
		return
	burst_triggered = TRUE
	var/list/buttons = list(BURST_IMMEDIATELY, DELAY_BURST)
	var/burst_choice = tgui_alert(src, "Choose how you want to burst", "You feel ready to pop!", buttons)
	if(!burst_choice || burst_choice == BURST_IMMEDIATELY)
		burst()
	if(!burst_choice || burst_choice == DELAY_BURST)
		burst_delay_modifier = burst_delay_modifier * 2 // We double the buffer for each delay choice
		burst_triggered = FALSE

/mob/living/carbon/proc/burst(safe = FALSE)
	var/safe_popping = client?.prefs?.read_preference(/datum/preference/toggle/reform_after_bursting)
	playsound(loc, pick(GLOB.blueberry_burst), BLUEBERRY_INFLATION_VOLUME, 1, 1, 1.2, ignore_walls = TRUE)
	if (do_after(src, 7 SECONDS, src)) // This is an annoyinh hardcoded value. But this is synced to the explosion in the sound effect. Perhaps a key/value pair for each explosion sound?
		var/liquid_to_spill = reagents.get_reagent_amount(/datum/reagent/blueberry_juice)
		var/turf/the_turf = get_turf(src)
		the_turf.add_liquid(/datum/reagent/blueberry_juice, liquid_to_spill, FALSE, 312)
		reagents.remove_reagent(/datum/reagent/blueberry_juice, liquid_to_spill)
		var/datum/effect_system/fluid_spread/smoke/blueberry/smoke = new
		smoke.set_up(2, holder = src, location = src)
		smoke.start()
		qdel(smoke) //And deleted again. Sad really.
		burst_triggered = FALSE

		if(!safe_popping)
			gib(DROP_ALL_REMAINS)

/// Used to add a cum decal to the floor while transferring viruses and DNA to it
/mob/living/carbon/proc/add_juice_splatter_floor(turf/the_turf, var/puddle = FALSE)
	if(!the_turf)
		the_turf = get_turf(src)
	if(!puddle)
		var/selected_type = pick(/obj/effect/decal/cleanable/juice, /obj/effect/decal/cleanable/juice/streak)
		var/atom/stain = new selected_type(the_turf, get_static_viruses())
		stain.add_mob_blood(src) //I'm not adding a new forensics category for cumstains
	else
		var/liquid_to_spill = min((reagents.get_reagent_amount(/datum/reagent/blueberry_juice) / 100 * BLUEBERRY_SPLASH_AMOUNT_PERCENTAGE), BLUEBERRY_SPLASH_AMOUNT_MAX) // Sploosh out BLUEBERRY_SPLASH_AMOUNT_PERCENTAGE percent of total juice, or 100 units, whichever is smallest.
		the_turf.add_liquid(/datum/reagent/blueberry_juice, liquid_to_spill, FALSE, 312)
		reagents.remove_reagent(/datum/reagent/blueberry_juice, liquid_to_spill)

/obj/effect/decal/cleanable/juice
	name = "berry juice"
	desc = "It's blue and smells enticingly sweet."
	icon = 'modular_gs/icons/turf/berry_decal.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	beauty = -50

/obj/effect/decal/cleanable/juice/streak
	random_icon_states = list("streak1", "streak2", "streak3", "streak4", "streak5")



/////////////////////////////////////////////
// Blueberry smoke
/////////////////////////////////////////////
// Used as an effect when a berry goes pop. Spreads the disease to whoever breathed it in.
/obj/effect/particle_effect/fluid/smoke/blueberry
	name = "blueberry smoke"
	color = COLOR_BLUE_LIGHT
	lifetime = 5 SECONDS

/// A factory which produces green smoke that makes you cough.
/datum/effect_system/fluid_spread/smoke/blueberry
	effect_type = /obj/effect/particle_effect/fluid/smoke/blueberry

// /obj/item/food/meat/steak/troll
// 	name = "Troll steak"
// 	desc = "In its sliced state it remains dormant, but once the troll meat comes in contact with stomach acids, it begins a perpetual cycle of constant regrowth and digestion. You probably shouldn't eat this."
// 	var/hunger_threshold = NUTRITION_LEVEL_FULL
// 	var/nutrition_amount = 20 // somewhere around 5 pounds
// 	var/fullness_to_add = 10
// 	var/message = "<span class='notice'>You feel fuller...</span>" // GS13

