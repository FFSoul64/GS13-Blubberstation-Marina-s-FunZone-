// Allow everyone to process all nutrition chems
// Reagents still give nutrition if they have any if the mob has no hunger
// Force adjust_nutrition to happen even if they are NOHUNGER mobs

/datum/reagent/consumable/nutriment
	process_flags = REAGENT_ORGANIC | REAGENT_SYNTHETIC | REAGENT_PROTEAN

/datum/reagent/consumable/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	if(!ishuman(affected_mob))
		return

	var/mob/living/carbon/human/affected_human = affected_mob
	if(HAS_TRAIT(affected_mob, TRAIT_NOHUNGER))
		affected_human.adjust_nutrition(get_nutriment_factor(affected_mob) * REM * seconds_per_tick, TRUE)

// Allow synths and proteans to process lipolicide
/datum/reagent/toxin/lipolicide
	process_flags = REAGENT_ORGANIC | REAGENT_SYNTHETIC | REAGENT_PROTEAN
	
