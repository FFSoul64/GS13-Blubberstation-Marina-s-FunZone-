//	Protean MODsuit fatness hider

/obj/item/clothing/suit/mod/proc/fat_hide(var/mob/living/carbon/human/receiver)
	if(!ishuman(receiver) || !receiver.back || !istype(receiver.back, /obj/item/mod/control/pre_equipped/protean))
		return FALSE

	var/obj/item/mod/control/controller = receiver.back
	if(!controller.core || !istype(controller.core, /obj/item/mod/core/protean))
		return FALSE

	var/obj/item/mod/core/protean/p_core = controller.core
	if(!p_core.linked_species || !p_core.linked_species.owner)
		return FALSE

	var/mob/living/carbon/human/protean = p_core.linked_species.owner
	if(protean && receiver != protean && protean?.fatness)
		return protean.fatness

	return FALSE

/obj/item/clothing/suit/mod/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/u = user
		u.hider_add(src)
		
/obj/item/clothing/suit/mod/dropped(mob/living/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/u = user
		u.hider_remove(src)
