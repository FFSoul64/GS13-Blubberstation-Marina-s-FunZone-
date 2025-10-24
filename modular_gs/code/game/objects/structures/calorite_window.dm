/datum/armor/structure_window_calorite
	melee = 10
	fire = 80
	acid = 100

/obj/structure/window/calorite
	name = "calorite window"
	desc = "A window made out of a calorite-silicate alloy."
	icon_state = "calorite_window"
	armor_type = /datum/armor/structure_window_calorite
	max_integrity = 30
	glass_type = /obj/item/stack/sheet/calorite_glass
	rad_insulation = RAD_MEDIUM_INSULATION
	glass_material_datum = /datum/material/alloy/calorite_glass

/obj/structure/window/calorite/fulltile
	name = "full tile calorite window"
	desc = "A full tile window made out of a calorite-silicate alloy."
	icon = 'modular_gs/icons/obj/structure/window_calorite.dmi'
