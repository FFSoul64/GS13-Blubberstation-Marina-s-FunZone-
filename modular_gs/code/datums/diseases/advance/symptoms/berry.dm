/datum/symptom/berry
	name = "Berrification"
	desc = "The virus causes the host's biology to overflow with a blue substance. Infection ends if the substance is completely removed from their body, besides ordinary cures."
	stealth = -5
	resistance = -4
	stage_speed = 1
	transmittable = 6
	level = 7
	severity = 5
	base_message_chance = 100
	symptom_delay_min = 15
	symptom_delay_max = 45
	threshold_descs = list(
		"Stage Speed" = "Increases the rate of liquid production.",
	)
	var/datum/reagent/infection_reagent = /datum/reagent/blueberry_juice

/datum/symptom/berry/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.affected_mob?.client?.prefs?.read_preference(/datum/preference/toggle/blueberry_inflation))
		A.affected_mob.reagents.add_reagent(infection_reagent, max(1, A.totalStageSpeed()) * 10)
	..()

/datum/symptom/berry/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	if(!(M?.client?.prefs?.read_preference(/datum/preference/toggle/blueberry_inflation)))
		return
	if(M.reagents.get_reagent_amount(infection_reagent) <= 0)
		A.remove_disease()
	switch(A.stage)
		if(1, 2, 3, 4)
			if(prob(base_message_chance))
				to_chat(M, "<span class='warning'>[pick("You feel oddly full...", "Your stomach churns...", "You hear a gurgle...", "You taste berries...")]</span>")
		else
			to_chat(M, "<span class='warning'><i>[pick("A deep slosh comes from inside you...", "Your mind feels light...", "You think blue really suits you...", "Your skin feels so tight...")]</i></span>")
	M.reagents.add_reagent(infection_reagent, (max(A.totalStageSpeed(), 0.2)) * A.stage)

/obj/item/reagent_containers/canconsume(mob/eater, mob/user)
	if(eater?.reagents.get_reagent_amount(/datum/reagent/blueberry_juice) > 0 && (reagents.total_volume + min(amount_per_transfer_from_this, 10)) <= volume)
		reagents.add_reagent(/datum/reagent/blueberry_juice, min(10, amount_per_transfer_from_this))
		eater.reagents.remove_reagent(/datum/reagent/blueberry_juice, min(10, amount_per_transfer_from_this))
		if(eater != user)
			to_chat(user, "<span class='warning'>You juice [eater.name]...</span>")
			to_chat(eater, "<span class='warning'>[user.name] juices you...</span>")
		else
			to_chat(user, "<span class='warning'>You get some juice out of you...</span>")
		/*if(prob(5))
			new /obj/effect/decal/cleanable/juice(M.loc)
			playsound(M.loc, 'sound/effects/splat.ogg',rand(10,50), 1)*/
		return
	. = ..()
/*
/obj/effect/decal/cleanable/juice
	name = "berry juice"
	desc = "It's blue and smells enticingly sweet."
	icon = 'modular_gs/icons/turf/berry_decal.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	blood_state = BLOOD_STATE_JUICE
	bloodiness = BLOOD_AMOUNT_PER_DECAL

/obj/effect/decal/cleanable/juice/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/blueberry_juice = 5)

/obj/effect/decal/cleanable/juice/streak
	random_icon_states = list("streak1", "streak2", "streak3", "streak4", "streak5")

/obj/effect/decal/cleanable/blood/update_icon()
	color = blood_DNA_to_color()
	if(blood_state == BLOOD_STATE_JUICE)
		color = BLOOD_COLOR_JUICE
*/

GLOBAL_LIST_INIT(no_random_cure_symptoms, list(/datum/symptom/berry, /datum/symptom/weight_gain,))

///Proc to process the disease and decide on whether to advance, cure or make the symptoms appear. Returns a boolean on whether to continue acting on the symptoms or not.
/datum/disease/advance/stage_act(seconds_per_tick, times_fired)
	var/slowdown = HAS_TRAIT(affected_mob, TRAIT_VIRUS_RESISTANCE) ? 0.5 : 1 // spaceacillin slows stage speed by 50%
	var/recovery_prob = 0
	var/cure_mod
	var/bad_immune = HAS_TRAIT(affected_mob, TRAIT_IMMUNODEFICIENCY) ? 2 : 1

	if(required_organ)
		if(!has_required_infectious_organ(affected_mob, required_organ))
			cure(add_resistance = FALSE)
			return FALSE

	if(has_cure())
		cure_mod = cure_chance / bad_immune
		if(istype(src, /datum/disease/advance))
			cure_mod = max(cure_chance, DISEASE_MINIMUM_CHEMICAL_CURE_CHANCE)
		if(disease_flags & CHRONIC && SPT_PROB(cure_mod, seconds_per_tick))
			update_stage(1)
			to_chat(affected_mob, span_notice("Your chronic illness is alleviated a little, though it can't be cured!"))
			return
		if(disease_flags & CURABLE && SPT_PROB(cure_mod, seconds_per_tick))
			if(disease_flags & INCREMENTAL_CURE)
				if (!update_stage(stage - 1))
					return FALSE
			else
				cure()
				return FALSE

	if(stage == max_stages && stage_peaked != TRUE) //mostly a sanity check in case we manually set a virus to max stages
		stage_peaked = TRUE

	if(SPT_PROB(stage_prob*slowdown*bad_immune, seconds_per_tick))
		update_stage(min(stage + 1, max_stages))

	// if(!(disease_flags & CHRONIC) && disease_flags & CURABLE && bypasses_immunity != TRUE)
	if(!(disease_flags & CHRONIC) && disease_flags & CURABLE && bypasses_immunity != TRUE && bypasses_disease_recovery != TRUE) // BUBBER EDIT CHANGE - DISEASE OUTBREAK UPDATES
		switch(severity)
			if(DISEASE_SEVERITY_POSITIVE) //good viruses don't go anywhere after hitting max stage - you can try to get rid of them by sleeping earlier
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_POSITIVE) //because of the way we later check for recovery_prob, we need to floor this at least equal to the scaling to avoid infinitely getting less likely to cure
				if(((HAS_TRAIT(affected_mob, TRAIT_NOHUNGER)) || ((affected_mob.nutrition > NUTRITION_LEVEL_STARVING) && (affected_mob.satiety >= 0))) && slowdown == 1) //any sort of malnourishment/immunosuppressant opens you to losing a good virus
					return TRUE
			if(DISEASE_SEVERITY_NONTHREAT)
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_NONTHREAT)
			if(DISEASE_SEVERITY_MINOR)
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_MINOR)
			if(DISEASE_SEVERITY_MEDIUM)
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_MEDIUM)
			if(DISEASE_SEVERITY_DANGEROUS)
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_DANGEROUS)
			if(DISEASE_SEVERITY_HARMFUL)
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_HARMFUL)
			if(DISEASE_SEVERITY_BIOHAZARD)
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_BIOHAZARD)
			else
				cycles_to_beat = max(DISEASE_RECOVERY_SCALING, DISEASE_CYCLES_NONTHREAT)
		peaked_cycles += stage/max_stages //every cycle we spend sick counts towards eventually curing the virus, faster at higher stages
		recovery_prob += DISEASE_RECOVERY_CONSTANT + (peaked_cycles / (cycles_to_beat / DISEASE_RECOVERY_SCALING)) //more severe viruses are beaten back more aggressively after the peak
		if(stage_peaked)
			recovery_prob *= DISEASE_PEAKED_RECOVERY_MULTIPLIER
		if(slowdown != 1) //using spaceacillin can help get them over the finish line to kill a virus with decreasing effect over time
			recovery_prob += clamp((((1 - slowdown)*(DISEASE_SLOWDOWN_RECOVERY_BONUS * 2)) * ((DISEASE_SLOWDOWN_RECOVERY_BONUS_DURATION - chemical_offsets) / DISEASE_SLOWDOWN_RECOVERY_BONUS_DURATION)), 0, DISEASE_SLOWDOWN_RECOVERY_BONUS)
			chemical_offsets = min(chemical_offsets + 1, DISEASE_SLOWDOWN_RECOVERY_BONUS_DURATION)
		if(!HAS_TRAIT(affected_mob, TRAIT_NOHUNGER))
			if(affected_mob.satiety < 0 || affected_mob.nutrition < NUTRITION_LEVEL_STARVING) //being malnourished makes it a lot harder to defeat your illness
				recovery_prob -= DISEASE_MALNUTRITION_RECOVERY_PENALTY
			else
				if(affected_mob.satiety >= 0)
					recovery_prob += round((DISEASE_SATIETY_RECOVERY_MULTIPLIER * (affected_mob.satiety/MAX_SATIETY)), 0.1)

		if(affected_mob.mob_mood) // this and most other modifiers below a shameless rip from sleeping healing buffs, but feeling good helps make it go away quicker
			switch(affected_mob.mob_mood.sanity_level)
				if(SANITY_LEVEL_GREAT)
					recovery_prob += 0.4
				if(SANITY_LEVEL_NEUTRAL)
					recovery_prob += 0.2
				if(SANITY_LEVEL_DISTURBED)
					recovery_prob += 0
				if(SANITY_LEVEL_UNSTABLE)
					recovery_prob += 0
				if(SANITY_LEVEL_CRAZY)
					recovery_prob += -0.2
				if(SANITY_LEVEL_INSANE)
					recovery_prob += -0.4

		if((HAS_TRAIT(affected_mob, TRAIT_NOHUNGER) || !(affected_mob.satiety < 0 || affected_mob.nutrition < NUTRITION_LEVEL_STARVING)) && HAS_TRAIT(affected_mob, TRAIT_KNOCKEDOUT)) //resting starved won't help, but resting helps
			var/turf/rest_turf = get_turf(affected_mob)
			var/is_sleeping_in_darkness = rest_turf.get_lumcount() <= LIGHTING_TILE_IS_DARK

			if(affected_mob.is_blind_from(EYES_COVERED) || is_sleeping_in_darkness)
				recovery_prob += DISEASE_GOOD_SLEEPING_RECOVERY_BONUS

			// sleeping in silence is always better
			if(HAS_TRAIT(affected_mob, TRAIT_DEAF))
				recovery_prob += DISEASE_GOOD_SLEEPING_RECOVERY_BONUS

			// check for beds
			if((locate(/obj/structure/bed) in affected_mob.loc))
				recovery_prob += DISEASE_GOOD_SLEEPING_RECOVERY_BONUS
			else if((locate(/obj/structure/table) in affected_mob.loc))
				recovery_prob += (DISEASE_GOOD_SLEEPING_RECOVERY_BONUS / 2)

			// don't forget the bedsheet
			if(locate(/obj/item/bedsheet) in affected_mob.loc)
				recovery_prob += DISEASE_GOOD_SLEEPING_RECOVERY_BONUS

			// you forgot the pillow
			if(locate(/obj/item/pillow) in affected_mob.loc)
				recovery_prob += DISEASE_GOOD_SLEEPING_RECOVERY_BONUS

			recovery_prob *= DISEASE_SLEEPING_RECOVERY_MULTIPLIER //any form of sleeping magnifies all effects a little bit

		recovery_prob = clamp(recovery_prob / bad_immune, 0, 100)

		var/skip_recovery = FALSE
		for(var/datum/symptom/disease_symptom in symptoms)
			if(is_type_in_list(disease_symptom, GLOB.no_random_cure_symptoms))
				skip_recovery = TRUE

		if(recovery_prob && !skip_recovery)
			if(SPT_PROB(recovery_prob, seconds_per_tick))
				if(stage == 1 && prob(cure_chance * DISEASE_FINAL_CURE_CHANCE_MULTIPLIER)) //if we reduce FROM stage == 1, cure the virus - after defeating its cure_chance in a final battle
					if(!HAS_TRAIT(affected_mob, TRAIT_NOHUNGER) && (affected_mob.satiety < 0 || affected_mob.nutrition < NUTRITION_LEVEL_STARVING))
						if(stage_peaked == FALSE) //if you didn't ride out the virus from its peak, if you're malnourished when it cures, you don't get resistance
							cure(add_resistance = FALSE)
							return FALSE
						else if(prob(50)) //if you rode it out from the peak, challenge cure_chance on if you get resistance or not
							cure(add_resistance = TRUE)
							return FALSE
					else
						cure(add_resistance = TRUE) //stay fed and cure it at any point, you're immune
						return FALSE
				update_stage(max(stage - 1, 1))

		if(HAS_TRAIT(affected_mob, TRAIT_KNOCKEDOUT) || slowdown != 1) //sleeping and using spaceacillin lets us nosell applicable virus symptoms firing with decreasing effectiveness over time
			if(prob(100 - min((100 * (symptom_offsets / DISEASE_SYMPTOM_OFFSET_DURATION)), 100 - cure_chance * DISEASE_FINAL_CURE_CHANCE_MULTIPLIER))) //viruses with higher cure_chance will ultimately be more possible to offset symptoms on
				symptom_offsets = min(symptom_offsets + 1, DISEASE_SYMPTOM_OFFSET_DURATION)
				return FALSE

	return !carrier
