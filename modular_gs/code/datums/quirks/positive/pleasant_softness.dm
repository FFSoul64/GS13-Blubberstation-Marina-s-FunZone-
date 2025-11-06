/datum/quirk/pleasant_softness
	name = "Pleasant Softness"
	desc = "Your curves are nice and soft. People just can't get enough of them."
	icon = "fa-mattress-pillow"
	value = 2
	quirk_flags = QUIRK_HIDE_FROM_SCAN | QUIRK_PROCESSES
	erp_quirk = FALSE
	mob_trait = TRAIT_PLEASANTLY_SOFT

/datum/mood_event/fatties_love
	// description = span_nicegreen("Someone around me is so ") + span_boldnicegreen("fat") + span_nicegreen(" and ") + span_boldnicegreen("soft") + span_nicegreen("!!")
	description = span_nicegreen("Someone around me is so fat and soft!")
	mood_change = 8
	timeout = 3 MINUTES

/datum/quirk/pleasant_softness/process(seconds_per_tick)
	if(quirk_holder.stat == DEAD)
		return
	if(!TIMER_COOLDOWN_FINISHED(quirk_holder, PLEASANTLY_SOFT_COOLDOWN)) // 15 second Early return
		return
	if(!quirk_holder)
		return
	if(!iscarbon(quirk_holder))
		return

	var/mob/living/carbon/fatty_holder = quirk_holder

	if (fatty_holder.fatness < FATNESS_LEVEL_FATTER)
		return

	// handles calculating nearby people
	var/list/mob/living/carbon/human/fat_freaks = viewers(world.view / 2, fatty_holder)

	for(var/mob/living/carbon/human/fat_freak in fat_freaks)
		if(fat_freak != fatty_holder) // ignore our player
			if(HAS_TRAIT(fat_freak, TRAIT_FAT_GOOD))
				fat_freak.add_mood_event(TRAIT_PLEASANTLY_SOFT, /datum/mood_event/fatties_love)
				continue
			if(HAS_TRAIT(fat_freak, TRAIT_FAT_BAD))
				continue

			fat_freak.add_mood_event(TRAIT_PLEASANTLY_SOFT, /datum/mood_event/fat_other)

	TIMER_COOLDOWN_START(quirk_holder, PLEASANTLY_SOFT_COOLDOWN, 15 SECONDS)
