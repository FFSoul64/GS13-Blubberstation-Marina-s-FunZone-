/obj/machinery/cryopod/tele //lore-friendly cryo thing
	name = "Long-range Central Command teleporter"
	desc = "A special teleporter for sending employees back to Central Command for reassignments, adjustments or simply to end their shift."
	icon = 'modular_gs/icons/obj/machines/cryogenics.dmi'
	icon_state = "telepod-open"
	base_icon_state = "telepod-open"
	open_icon_state = "telepod-open"
	time_till_despawn = 10 SECONDS
	on_store_message = "has teleported back to Central Command."
	on_store_name = "Teleporter Oversight"

/obj/machinery/cryopod/tele/open_machine(drop = TRUE, density_to_set = FALSE)
	..()
	icon_state = "telepod-open"

/obj/machinery/cryopod/tele/close_machine(atom/movable/target, density_to_set = TRUE)
	..()
	icon_state = "telepod"

/obj/machinery/cryopod/tele/mouse_drop_receive(mob/living/target, mob/living/user, params)
	if (iscarbon(target))
		var/mob/living/carbon/person = target
		person.save_persistent_fat()
	
	return ..()

/obj/machinery/cryopod
	/// Do we want to inform comms when someone cryos?
	var/alert_comms = TRUE
	var/on_store_message = "has entered the centcomm teleportation pod."
	var/on_store_name = "Telepod Oversight"
