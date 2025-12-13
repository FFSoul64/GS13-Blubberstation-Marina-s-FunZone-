/area/fatlab
	name = "Mysterious Facility"
	icon_state = "centcom"
	requires_power = FALSE
	default_gravity = STANDARD_GRAVITY
	flags_1 = NONE

/area/crew_quarters/fitness/sauna
	name = "Saunas"
	icon_state = "dk_yellow"


/area/ruin/space/has_grav/fastfood_main
	name = "GATO Restaurant - Main Area"
	default_gravity = STANDARD_GRAVITY

/area/ruin/space/has_grav/fastfood_employee
	name = "Restaurant Employee Area"
	default_gravity = STANDARD_GRAVITY

/area/ruin/space/has_grav/feedersden
	name = "Unknown Outpost"
	default_gravity = STANDARD_GRAVITY


//lavaland xenoarch areas - seperate multi-Z level
/area/xenoarch/lavaland
	icon = 'modular_gs/icons/turf/areas.dmi'
	icon_state = "xenogen"
	default_gravity = STANDARD_GRAVITY

/area/xenoarch/lavaland/outside
	icon_state = "yellow"
	default_gravity = STANDARD_GRAVITY
	outdoors = TRUE
	flags_1 = NONE
	area_flags = VALID_TERRITORY | UNIQUE_AREA | FLORA_ALLOWED
	sound_environment = SOUND_AREA_LAVALAND
	ambient_buzz = 'sound/ambience/lavaland/magma.ogg'
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambience_index = AMBIENCE_MINING
	area_flags = VALID_TERRITORY | UNIQUE_AREA


/area/xenoarch/lavaland/arch
	name = "Xenoarchaeology"
	icon_state = "xenoarch"

/area/xenoarch/lavaland/bot
	name = "Xenoarchaeology Botany"
	icon_state = "xenobot"

/area/xenoarch/lavaland/eng
	name = "Xenoarchaeology Engineering"
	icon_state = "xenoeng"

/area/xenoarch/lavaland/gen
	name = "Xenoarchaeology Living Quarters"
	icon_state = "xenogen"

/area/xenoarch/lavaland/sec
	name = "Xenoarchaeology Security"
	icon_state = "xenosec"

/area/xenoarch/lavaland/med
	name = "Xenoarchaeology Medical"
	icon_state = "xenomed"

/area/xenoarch/lavaland/bathroom
	name = "Xenoarchaeology Bathroom"
	icon_state = "xenomed"

/area/xenoarch/lavaland/construction
	name = "Xenoarchaeology Construction"
	icon_state = "xenoeng"

/area/xenoarch/lavaland/foyer
	name = "Xenoarchaeology Foyer"
	icon_state = "xenoarch"

/area/xenoarch/lavaland/gym
	name = "Xenoarchaeology Gym"
	icon_state = "xenosec"

/area/xenoarch/lavaland/library
	name = "Xenoarchaeology Library"
	icon_state = "xenobot"

/area/xenoarch/lavaland/maint_east
	name = "Xenoarchaeology East Maintenance"
	icon_state = "yellow"

/area/xenoarch/lavaland/maint_west
	name = "Xenoarchaeology West Maintenance"
	icon_state = "yellow"

/area/xenoarch/lavaland/public
	name = "Xenoarchaeology Public Area"
	icon_state = "xenobot"

/area/xenoarch/lavaland/calorite_temple
	name = "Calorite Temple"
	icon_state = "caloritetemple"
	power_light = TRUE

/area/xenoarch/lavaland/outside/caloriteresearch_powered
	name = "Research Facility Ruins"
	icon_state = "caloriteresearch"
	power_light = TRUE

/area/xenoarch/lavaland/outside/caloriteresearch_unpowered
	name = "Research Facility Ruins"
	icon_state = "caloriteresearch"
	power_light = FALSE

/area/xenoarch/lavaland/outside/donut_factory
	name = "GATO Donut Factory"
	icon_state = "donutfactory"

/area/xenoarch/lavaland/outside/candy_outpost
	name = "Candyland Survey Post"
	icon_state = "candyoutpost"

/area/xenoarch/lavaland/outside/candyland
	name = "Candyland"
	icon_state = "candyland"
	power_light = TRUE

//xenoarch areas end


/area/ruin/powered/gluttony
	icon_state = "dk_yellow"

/area/ruin/powered/beach
	icon_state = "dk_yellow"


/area/ruin/unpowered/syndicate_lava_base/engineering
	name = "Syndicate Lavaland Engineering"

/area/ruin/unpowered/syndicate_lava_base/medbay
	name = "Syndicate Lavaland Medbay"

/area/ruin/unpowered/syndicate_lava_base/arrivals
	name = "Syndicate Lavaland Arrivals"

/area/ruin/unpowered/syndicate_lava_base/bar
	name = "Syndicate Lavaland Bar"

/area/ruin/unpowered/syndicate_lava_base/main
	name = "Syndicate Lavaland Primary Hallway"

/area/ruin/unpowered/syndicate_lava_base/cargo
	name = "Syndicate Lavaland Cargo Bay"

/area/ruin/unpowered/syndicate_lava_base/chemistry
	name = "Syndicate Lavaland Chemistry"

/area/ruin/unpowered/syndicate_lava_base/virology
	name = "Syndicate Lavaland Virology"

/area/ruin/unpowered/syndicate_lava_base/testlab
	name = "Syndicate Lavaland Experimentation Lab"

/area/ruin/unpowered/syndicate_lava_base/dormitories
	name = "Syndicate Lavaland Dormitories"

/area/ruin/unpowered/syndicate_lava_base/telecomms
	name = "Syndicate Lavaland Telecommunications"

/area/ruin/unpowered/syndicate_lava_base/circuits
	name = "Syndicate Lavaland Circuit Lab"

/area/ruin/unpowered/syndicate_lava_base/nanites
	name = "Syndicate Lavaland Nanite Lab"

/area/ruin/unpowered/syndicate_lava_base/outdoors //Putting this area down should prevent fauna from spawning nearby
	name = "Syndicate Lavaland Approach"
	icon_state = "red"

/area/station/commons/dorms/lower
	name = "\improper Lower Level Dormitories"
