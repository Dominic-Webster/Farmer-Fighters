extends RefCounted
class_name AlmanacData

const ITEM_ENTRIES := [
	#Common
	{
		"id": "4_leaf_clover",
		"name": "4 Leaf Clover",
		"desc": "+3 Luck",
		"texture": preload("res://Items/Common/4_Leaf_Clover/4_Leaf_Clover.png"),
		"category": "common"
	},
	{
		"id": "acorn",
		"name": "Acorn",
		"desc": "+0.5 Damage",
		"texture": preload("res://Items/Common/Acorn/acorn.png"),
		"category": "common"
	},
	{
		"id": "apple",
		"name": "Apple",
		"desc": "+125 Movement Speed",
		"texture": preload("res://Items/Common/Apple/Apple.png"),
		"category": "common"
	},
	{
		"id": "banana",
		"name": "Banana",
		"desc": "Bullets become Boomerangs\nBoomerang Effect Unlocked",
		"texture": preload("res://Items/Common/Banana/Banana.png"),
		"category": "common"
	},
	{
		"id": "basil",
		"name": "Basil",
		"desc": "+200 Bullet Speed",
		"texture": preload("res://Items/Common/Basil/basil.png"),
		"category": "common"
	},
	{
		"id": "broccoli",
		"name": "Broccoli",
		"desc": "+0.5 Damage",
		"texture": preload("res://Items/Common/Broccoli/Broccoli.png"),
		"category": "common"
	},
	{
		"id": "cabbage",
		"name": "Cabbage",
		"desc": "Bullets become Cabbages\n+1 Damage\n0.02 Accuracy Buff\nFire Rate Debuff",
		"texture": preload("res://Bullets/Cabbage_Bullet/Cabbage.png"),
		"category": "common"
	},
	{
		"id": "carrot",
		"name": "Carrot",
		"desc": "Hearts become Carrots",
		"texture": preload("res://Items/Common/Carrot/Carrot.png"),
		"category": "common"
	},
	{
		"id": "cauliflower",
		"name": "Cauliflower",
		"desc": "+1 Damage",
		"texture": preload("res://Items/Unlocks/Cauliflower/cauliflower.png"),
		"category": "common"
	},
	{
		"id": "eggplant",
		"name": "Eggplant",
		"desc": "More Bullets\n0.05 Fire Rate Buff",
		"texture": preload("res://Items/Common/Eggplant/Eggplant.png"),
		"category": "common"
	},
	{
		"id": "fertilizer",
		"name": "Fertilizer",
		"desc": "+200 Bullet Speed",
		"texture": preload("res://Items/Common/Fertilizer/fertilizer.png"),
		"category": "common"
	},
	{
		"id": "grapes_of_wrath",
		"name": "Grapes Of Wrath",
		"desc": "Bullets become Grapes\n0.35 Fire Rate Buff\n-0.5 Damage\n0.05 Accuracy Debuff",
		"texture": preload("res://Items/Common/Grapes_Of_Wrath/grapes_of_wrath.png"),
		"category": "common"
	},
	{
		"id": "green_bean",
		"name": "Green Bean",
		"desc": "Unlock Dash\n+0.01 Dash Duration",
		"texture": preload("res://Items/Common/Green_Bean/green_bean.png"),
		"category": "common"
	},
	{
		"id": "habanaro",
		"name": "Habanero",
		"desc": "0.075 Fire Rate Buff",
		"texture": preload("res://Items/Common/Habanero/Habanero.png"),
		"category": "common"
	},
	{
		"id": "honeynut_squash",
		"name": "Honeynut Squash",
		"desc": "Unlock Dual-Shot\n0.3 Fire Rate Debuff",
		"texture": preload("res://Items/Common/Honeynut_Squash/Honeynut_Squash.png"),
		"category": "common"
	},
	{
		"id": "lettuce",
		"name": "Lettuce",
		"desc": "x1.5 Damage Mult",
		"texture": preload("res://Items/Common/Lettuce/lettuce.png"),
		"category": "common"
	},
	{
		"id": "mint",
		"name": "Mint",
		"desc": "0.075 Fire Rate Buff",
		"texture": preload("res://Items/Common/Mint/mint.png"),
		"category": "common"
	},
	{
		"id": "orange",
		"name": "Orange",
		"desc": "+75 Movement Speed\n+1 Luck",
		"texture": preload("res://Items/Common/Orange/orange.png"),
		"category": "common"
	},
	{
		"id": "peach",
		"name": "Peach",
		"desc": "Bullets become Peaches\n+0.25 Damage\n+2 Damage Mult\n0.02 Accuracy Buff\nFire Rate/Bullet Speed Debuff",
		"texture": preload("res://Items/Common/Peach/peach.png"),
		"category": "common"
	},
	{
		"id": "pear",
		"name": "Pear",
		"desc": "+1 Damage Mult\n-0.5 Damage",
		"texture": preload("res://Items/Unlocks/Pear/Pear.png"),
		"category": "common"
	},
	{
		"id": "plum",
		"name": "Plum",
		"desc": "+1 Luck\n+0.35 Damage Mult\n-0.25 Damage",
		"texture": preload("res://Items/Common/Plum/Plum.png"),
		"category": "common"
	},
	{
		"id": "portobello",
		"name": "Portobello",
		"desc": "Wavy Bullets\n+0.5 Damage Mult",
		"texture": preload("res://Items/Common/Portobello/portobello.png"),
		"category": "common"
	},
	{
		"id": "potato",
		"name": "Potato",
		"desc": "EXPLOSIVE POTATOES",
		"texture": preload("res://Items/Common/Potato/potato.png"),
		"category": "common"
	},
	{
		"id": "pumpkin",
		"name": "Pumpkin",
		"desc": "Bullets become Pumpkins\nFire Rate Buff\nBullet Speed Debuff\nMovement Speed Debuff",
		"texture": preload("res://Items/Unlocks/Pumpkin/Pumpkin.png"),
		"category": "common"
	},
	{
		"id": "radish",
		"name": "Radish",
		"desc": "Unlock Dash\n+100 Dash Speed",
		"texture": preload("res://Items/Common/Radish/radish.png"),
		"category": "common"
	},
	{
		"id": "rhubarb",
		"name": "Rhubarb",
		"desc": "+0.5 Damage Mult",
		"texture": preload("res://Items/Common/Rhubarb/rhubarb.png"),
		"category": "common"
	},
	{
		"id": "salsa",
		"name": "Salsa",
		"desc": "+75 Movement Speed\n+0.25 Damage\n+0.25 Damage Mult\n0.05 Fire Rate Buff",
		"texture": preload("res://Items/Common/Salsa/salsa.png"),
		"category": "common"
	},
	{
		"id": "shovel",
		"name": "Shovel",
		"desc": "Unlock Shovel: 4 Damage",
		"texture": preload("res://Items/Common/Shovel/Shovel.png"),
		"category": "common"
	},
	{
		"id": "spinach",
		"name": "Spinach",
		"desc": "+100 Movement Speed\n+0.5 Damage\n+0.1 Damage Mult\n+150 Bullet Speed",
		"texture": preload("res://Items/Common/Spinach/spinach.png"),
		"category": "common"
	},
	{
		"id": "strawberry",
		"name": "Strawberry",
		"desc": "Piercing Bullets\n0.005 Accuracy Buff",
		"texture": preload("res://Items/Common/Strawberry/strawberry.png"),
		"category": "common"
	},
	{
		"id": "tomatillo",
		"name": "Tomatillo",
		"desc": "Extra Bullet",
		"texture": preload("res://Items/Unlocks/Tomatillo/tomatillo.png"),
		"category": "common"
	},
	{
		"id": "turnip",
		"name": "Turnip",
		"desc": "Unlock Dash\n-0.05 Dash Cooldown",
		"texture": preload("res://Items/Common/Turnip/Turnip.png"),
		"category": "common"
	},
	{
		"id": "tobacco_leaf",
		"name": "Tobacco Leaf",
		"desc": "Bullets Poison Enemies",
		"texture": preload("res://Items/Common/Tobacco_Leaf/Tobacco_Leaf.png"),
		"category": "common"
	},
	{
		"id": "water",
		"name": "Water",
		"desc": "+1 Heart",
		"texture": preload("res://Items/Common/Water/other_water.png"),
		"category": "common"
	},
	{
		"id": "watermelon",
		"name": "Watermelon",
		"desc": "Bullets Bounce",
		"texture": preload("res://Items/Common/Watermelon/watermelon.png"),
		"category": "common"
	},
	#Uncommon
	{
		"id": "asparagus",
		"name": "Asparagus",
		"desc": "Bullets become Stream\nFire Rate Buff",
		"texture": preload("res://Items/Uncommon/Asparagus/Asparagus.png"),
		"category": "uncommon"
	},
	{
		"id": "celery",
		"name": "Celery",
		"desc": "+0.75 Damage\n0.05 Fire Rate Buff",
		"texture": preload("res://Items/Uncommon/Celery/celery.png"),
		"category": "uncommon"
	},
	{
		"id": "cilantro",
		"name": "Cilantro",
		"desc": "Explosive Bullets\n0.15 Fire Rate Debuff",
		"texture": preload("res://Items/Uncommon/Cilantro/cilantro.png"),
		"category": "uncommon"
	},
	{
		"id": "corn",
		"name": "Corn",
		"desc": "Bullets become Corn\n+2.5 Damage Mult\n0.04 Accuracy Buff\n0.4 Fire Rate Debuff",
		"texture": preload("res://Items/Uncommon/Corn/Corn.png"),
		"category": "uncommon"
	},
	{
		"id": "cow",
		"name": "Cow",
		"desc": "Unlock Cow Companion",
		"texture": preload("res://Items/Uncommon/Cow_Item/cow_icon.png"),
		"category": "uncommon"
	},
	{
		"id": "cucumber",
		"name": "Cucumber",
		"desc": "Unlock Homing Bullets\n-0.25 Damage Mult\n0.2 Fire Rate Debuff",
		"texture": preload("res://Items/Uncommon/Cucumber/cucumber.png"),
		"category": "uncommon"
	},
	{
		"id": "da_pickle",
		"name": "DA PICKLE",
		"desc": "+ Stats",
		"texture": preload("res://Items/Unlocks/Da_Pickle/pickle.png"),
		"category": "uncommon"
	},
	{
		"id": "fish_emulsion",
		"name": "Fish Emulsion",
		"desc": "Active (6): Heal One Heart",
		"texture": preload("res://Items/Uncommon/Fish_Emulsion/fish_emulsion_single.png"),
		"category": "uncommon"
	},
	{
		"id": "garlic",
		"name": "Garlic",
		"desc": "Bullets Slow Enemies",
		"texture": preload("res://Items/Uncommon/Garlic/garlic.png"),
		"category": "uncommon"
	},
	{
		"id": "haybale",
		"name": "Haybale",
		"desc": "x1.25 Damage Mult",
		"texture": preload("res://Items/Uncommon/Haybale/haybale.png"),
		"category": "uncommon"
	},
	{
		"id": "lemon",
		"name": "Lemon",
		"desc": "+150 Movement Speed\nSize Decrease",
		"texture": preload("res://Items/Uncommon/Lemon/lemon.png"),
		"category": "uncommon"
	},
	{
		"id": "lime",
		"name": "Lime",
		"desc": "+0.5 Damage\nSize Increase\nx0.9 Movement Speed",
		"texture": preload("res://Items/Uncommon/Lime/lime.png"),
		"category": "uncommon"
	},
	{
		"id": "mirror",
		"name": "Mirror",
		"desc": "Strength at a price...",
		"texture": preload("res://Items/Uncommon/Mirror/mirror.png"),
		"category": "uncommon"
	},
	{
		"id": "morrell",
		"name": "Morrell",
		"desc": "Unlock Spiral Bullets",
		"texture": preload("res://Items/Uncommon/Morrell/morrel.png"),
		"category": "uncommon"
	},
	{
		"id": "onion",
		"name": "Onion",
		"desc": "Unlock Piercing Bullets\n0.005 Accuracy Buff",
		"texture": preload("res://Items/Uncommon/Onion/onion.png"),
		"category": "uncommon"
	},
	{
		"id": "oregano",
		"name": "Oregano",
		"desc": "Gain 2 Avocado Hearts",
		"texture": preload("res://Items/Uncommon/Oregano/oregano.png"),
		"category": "uncommon"
	},
	{
		"id": "plantain",
		"name": "Plantain",
		"desc": "Bulllets Boomerang",
		"texture": preload("res://Items/Uncommon/Plantain/Plantain.png"),
		"category": "uncommon"
	},
	{
		"id": "raspberry",
		"name": "Raspberry",
		"desc": "+800 Bullet Speed\n0.2 Fire Rate Buff\n-0.25 Damage\n x0.5 Damage Mult",
		"texture": preload("res://Items/Uncommon/Raspberry/raspberry.png"),
		"category": "uncommon"
	},
	{
		"id": "scythe",
		"name": "Scythe",
		"desc": "Unlock Dash\n+2 Dash Damage",
		"texture": preload("res://Items/Uncommon/Scythe/scythe.png"),
		"category": "uncommon"
	},
	{
		"id": "trowel",
		"name": "Trowel",
		"desc": "Unlock Trowels: 5 Damage",
		"texture": preload("res://Items/Unlocks/Trowel/Trowel.png"),
		"category": "uncommon"
	},
	{
		"id": "zucchini",
		"name": "Zucchini",
		"desc": "Unlock Tri-Shot\n0.2 Fire Rate Debuff",
		"texture": preload("res://Items/Uncommon/Zucchini/zuchinni.png"),
		"category": "uncommon"
	},
	{
		"id": "wheat",
		"name": "Wheat",
		"desc": "Active (5): Deal x3 Damage to all Enemies",
		"texture": preload("res://Items/Unlocks/Wheat/wheat.png"),
		"category": "uncommon"
	},
	#Rare
	{
		"id": "blackberry",
		"name": "Blackberry",
		"desc": "Orbitting Swarms of Bullets",
		"texture": preload("res://Items/Rare/Blackberry/Blackberry.png"),
		"category": "rare"
	},
	{
		"id": "cherry",
		"name": "Cherry",
		"desc": "Enemies shoot Player Bullets on death",
		"texture": preload("res://Items/Unlocks/Cherry/Cherry_Item.png"),
		"category": "rare"
	},
	{
		"id": "chicken",
		"name": "Chicken",
		"desc": "Unlock Chicken Companion",
		"texture": preload("res://Items/Rare/Chicken_Item/Chicken_icon.png"),
		"category": "rare"
	},
	{
		"id": "good_soil",
		"name": "Good_Soil",
		"desc": "+2 Hearts",
		"texture": preload("res://Items/Unlocks/Good_Soil/Good_Soil.png"),
		"category": "rare"
	},
	{
		"id": "gourd",
		"name": "Gourd",
		"desc": "+5 Damage\nMovement Speed Debuff",
		"texture": preload("res://Items/Rare/Gourd/Gourd.png"),
		"category": "rare"
	},
	{
		"id": "pineapple",
		"name": "Pineapple",
		"desc": "+2 Damage\nx1.5 Damage Mult",
		"texture": preload("res://Items/Unlocks/Pineapple/pineapple.png"),
		"category": "rare"
	},
	{
		"id": "straw_hat",
		"name": "Straw Hat",
		"desc": "Unlock Shield",
		"texture": preload("res://Items/Unlocks/Straw_Hat/straw_hat.png"),
		"category": "rare"
	},
]


static func get_item_ids() -> Array[String]:
	var item_ids: Array[String] = []
	for entry in ITEM_ENTRIES:
		item_ids.append(str(entry.get("id", "")))
	return item_ids
