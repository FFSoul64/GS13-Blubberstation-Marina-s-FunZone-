// I HATE YOU SKYRAT
#define MINIMUM_CLOTHING_STOCK 5

/obj/machinery/vending
	/// Additions to the `products` list  of the vending machine, modularly. Will become null after Initialize, to free up memory.
	var/list/gs_products
	/// Additions to the `product_categories` list of the vending machine, modularly. Will become null after Initialize, to free up memory.
	var/list/gs_product_categories
	/// Additions to the `premium` list  of the vending machine, modularly. Will become null after Initialize, to free up memory.
	var/list/gs_premium
	/// Additions to the `contraband` list  of the vending machine, modularly. Will become null after Initialize, to free up memory.
	var/list/gs_contraband

/obj/machinery/vending/Initialize(mapload)
	if(gs_products)
		// We need this, because duplicates screw up the spritesheet!
		for(var/item_to_add in gs_products)
			products[item_to_add] = gs_products[item_to_add]

	if(gs_product_categories)
		for(var/category in gs_product_categories)
			var/already_exists = FALSE
			for(var/existing_category in product_categories)
				if(existing_category["name"] == category["name"])
					existing_category["products"] += category["products"]
					already_exists = TRUE
					break

			if(!already_exists)
				product_categories += category

	if(gs_premium)
		// We need this, because duplicates screw up the spritesheet!
		for(var/item_to_add in gs_premium)
			premium[item_to_add] = gs_premium[item_to_add]

	if(gs_contraband)
		// We need this, because duplicates screw up the spritesheet!
		for(var/item_to_add in gs_contraband)
			contraband[item_to_add] = gs_contraband[item_to_add]

	// Time to make clothes amounts consistent!
	for (var/obj/item/clothing/item in products)
		if(products[item] < MINIMUM_CLOTHING_STOCK && allow_increase(item))
			products[item] = MINIMUM_CLOTHING_STOCK

	for (var/category in product_categories)
		for(var/obj/item/clothing/item in category["products"])
			if(category["products"][item] < MINIMUM_CLOTHING_STOCK && allow_increase(item))
				category["products"][item] = MINIMUM_CLOTHING_STOCK

	for (var/obj/item/clothing/item in premium)
		if(premium[item] < MINIMUM_CLOTHING_STOCK && allow_increase(item))
			premium[item] = MINIMUM_CLOTHING_STOCK

	gs_products = null
	gs_product_categories = null
	gs_premium = null
	gs_contraband = null
	return ..()

#undef MINIMUM_CLOTHING_STOCK
