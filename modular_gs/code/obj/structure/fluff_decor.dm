/obj/effect/decal/bigfatsigil	 //96x96 px sprite
	name = "Summoning Sigil"
	desc = "A vast and odd summoning sigil of some sorts."
	icon = 'modular_gs/icons/obj/structure/magic_96x96.dmi'
	icon_state = "fattening-large"
	layer = ABOVE_OPEN_TURF_LAYER
	pixel_x = -32
	pixel_y = -32

/obj/structure/gs13_fluff/brokenhose
	name = "broken feeding hose"
	desc = "A broken feeding hose. Hopefully it served well."
	icon =  'modular_gs/icons/obj/structure/fluffdecor.dmi'
	icon_state = "feeding_tube_broken"
	anchored = TRUE
	density = FALSE

/obj/structure/gs13_fluff/brokenhose/scraps1
	icon_state = "ft_decor_1"

/obj/structure/gs13_fluff/brokenhose/scraps2
	icon_state = "ft_decor_2"

/obj/structure/gs13_fluff/brokenhose/scraps3
	icon_state = "ft_decor_3"

/obj/structure/reagent_dispensers/cooking_oil/cream
	name = "huge vat of cream"
	desc = "A huge metal vat with a tap on the front. Filled with an immense amount of cream. This one seems closed shut."
	icon = 'modular_gs/icons/obj/structure/fluffdecor_64x64.dmi'
	icon_state = "creamvat-closed"
	tank_volume = 10000
	reagent_id = /datum/reagent/consumable/cream
	openable = FALSE
	anchored = TRUE

/obj/structure/reagent_dispensers/cooking_oil/cream/open
	desc = "A huge metal vat with a tap on the front. Filled with an immense amount of cream."
	icon_state = "creamvat"
	openable = TRUE
