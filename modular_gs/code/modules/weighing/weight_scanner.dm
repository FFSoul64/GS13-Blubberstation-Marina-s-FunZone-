/obj/item/portable_weight_scanner
	name = "weight analyzer"
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "health"
	inhand_icon_state = "healthanalyzer"
	worn_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "A hand-held body scanner capable of distinguishing the exact composition of someone's body mass."
	var/currently_weighing = FALSE
	var/mob/living/carbon/most_recent_carbon
	var/datum/component/weigh_out/weight_datum

/*

/obj/item/portable_weight_scanner/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!iscarbon(interacting_with))
		return NONE

	var/mob/living/carbon/interacted_mob = interacting_with

	. = ITEM_INTERACT_SUCCESS

	user.visible_message(span_notice("[user] analyzes [interacted_mob]'s weight."))
	balloon_alert(user, "analyzing weight")
	playsound(user.loc, 'sound/items/healthanalyzer.ogg', 50)
	most_recent_carbon = interacted_mob
	weight_datum.weigh(interacted_mob)


/obj/item/portable_weight_scanner/Initialize(mapload)
	. = ..()
	weight_datum = new (src)

*/
