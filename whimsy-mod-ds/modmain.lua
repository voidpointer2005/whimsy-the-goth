local require = GLOBAL.require
local print = GLOBAL.print
--require("debugprint")
local function printDebug(msg)
	print(msg)
end

--TODO: Fix complaining on load
--TODO: Test edibility for DS
--TODO: Make Whimsy insult stale/spoiled food on inspection

--printDebug("*** WHIMSY: ENTERING MODMAIN.LUA")

TheSim = GLOBAL.TheSim

local isDST = TheSim:GetGameID() == "DST"
local hasRoG = isDST

--printDebug("*** WHIMSY: isDST is ",isDST)

if not isDST then
	if TUNING.AUTUMN_LENGTH then --TODO: Find a less awful way to do this
		hasRoG = true
		--printDebug("*** WHIMSY: hasRoG set to true based on tuning")
	else
		hasRoG = false
		--printDebug("*** WHIMSY: hasRoG set to false based on tuning")
	end
end

--printDebug("*** WHIMSY: DEFINING PREFABS AND ASSETS")

PrefabFiles = {
	"whimsy",
	"whimsy_umbrellas",
}

--TODO: Wind chimes
--TODO: Skull?
--TODO Ghost avatar
--TODO Test all functionality
--TODO: Mess with ghost form if possible

Assets = {
	Asset( "IMAGE", "images/saveslot_portraits/whimsy.tex" ),
	Asset( "ATLAS", "images/saveslot_portraits/whimsy.xml" ),

	Asset( "IMAGE", "images/selectscreen_portraits/whimsy.tex" ),
	Asset( "ATLAS", "images/selectscreen_portraits/whimsy.xml" ),

	Asset( "IMAGE", "bigportraits/whimsy.tex" ),
	Asset( "ATLAS", "bigportraits/whimsy.xml" ),

	Asset( "IMAGE", "images/map_icons/whimsy.tex" ),
	Asset( "ATLAS", "images/map_icons/whimsy.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_whimsy.tex" ),
	Asset( "ATLAS", "images/avatars/avatar_whimsy.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_whimsy.tex" ),
	Asset( "ATLAS", "images/avatars/avatar_ghost_whimsy.xml" ),
}


--printDebug("*** WHIMSY: DEFINING GLOBAL HOOKS")

local GetString = GLOBAL.GetString
local FindEntity = GLOBAL.FindEntity
local EventHandler = GLOBAL.EventHandler
local ACTIONS = GLOBAL.ACTIONS
local ProfileStatsSet = GLOBAL.ProfileStatsSet
local DeleteCloseEntsWithTag = GLOBAL.DeleteCloseEntsWithTag
local MakeInventoryPhysics = GLOBAL.MakeInventoryPhysics
local TheCamera = GLOBAL.TheCamera
local Recipe = GLOBAL.Recipe
local TECH = GLOBAL.TECH
local FRAMES = GLOBAL.FRAMES

local STRINGS = GLOBAL.STRINGS

local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS

--printDebug("*** WHIMSY: DEFINING STRINGS")

-- The character select screen lines
-- note: these are lower-case character name
STRINGS.CHARACTER_TITLES.whimsy = "The Goth"
STRINGS.CHARACTER_NAMES.whimsy = "Whimsy"
STRINGS.CHARACTER_DESCRIPTIONS.whimsy = "*Creature of the night.\n*Hates sunshine and getting wet.\n*Skilled in magic, but hates icky things."
STRINGS.CHARACTER_QUOTES.whimsy = "\"Ph'nglui mglw'nafh... Oh bother, how did it go again?\""
STRINGS.CHARACTERS.WHIMSY = require "speech_whimsy"

--Other characters describing Whimsy
if isDST then
	--printDebug("*** WHIMSY: DEFINING DST STRINGS")
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.WHIMSY =
		{
			GENERIC = "Greetings, %s!",
			ATTACKER = "I think %s wants us to come play with her, forever and ever...",
			MURDERER = "Murderer!",
			REVIVER = "It looks like %s's more... unconventional theories have paid off.",
			GHOST = "%s seems to be conducting an inverse seance.",
			FIRESTARTER = "Are fires spooky, %s?",
		}
	STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.WHIMSY = 
		{
			--Compare with the Ballad of Svipdag
			GENERIC = "The dead, Christians, and women are potent in magic, and I wot %s is all three!",
			ATTACKER = "Test me not, witch, for thy arm is weak!",
			MURDERER = "I shall sunder thy lacy spear, %s!",
			REVIVER = "%s, art thou Urd in disguise?",
			GHOST = "Beware the curse of a dead Christian woman! A heart!",
			FIRESTARTER = "%s, do you seek to conjure Surt into this world?",
		}
	STRINGS.CHARACTERS.WAXWELL.DESCRIBE.WHIMSY = 
		{
			GENERIC = "Greetings, Ms. %s.",
			ATTACKER = "%s is looking more like Charlie than usual.",
			MURDERER = "You don't frighten me, %s. You're just another creature of darkness.",
			REVIVER = "Ms. %s has always liked to walk the line between life and death.",
			GHOST = "Are you frightened yet, Ms. %s? Fear not, I have a plan.",
			FIRESTARTER = "Be careful, Ms. %s. You dance close to the fire.",
		}
	STRINGS.CHARACTERS.WEBBER.DESCRIBE.WHIMSY =
		{
			GENERIC = "Hi, %s! Don't be scared!",
			ATTACKER = "I'm not a mean spider, %s! Stop!",
			MURDERER = "Die, monster! You don't belong in this world!",
			REVIVER = "%s is super nice, even to people she's scared of!",
			GHOST = "%s actually looks less spooky like this.",
			FIRESTARTER = "Just don't burn us, %s.",
		}
	STRINGS.CHARACTERS.WENDY.DESCRIBE.WHIMSY =
		{
			GENERIC = "Hi, %s. ...Abigail says 'hi,' too.",
			ATTACKER = "You should know better, %s.",
			MURDERER = "You know what waits for you, %s. Are you afraid?",
			REVIVER = "Abigail likes you too, %s.",
			GHOST = "Would you like to come back now, %s?",
			FIRESTARTER = "Do you see something in the flames?",
		}
	STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.WHIMSY =
		{
			GENERIC = "Your copy of 'Carmilla' is overdue, %s.",
			ATTACKER = "That was far from ladylike, %s!",
			MURDERER = "Someone needs to teach you some manners, %s!",
			REVIVER = "The breadth of your knowledge of esoterica is impressive, %s.",
			GHOST = "What does it look like from the other side, %s?",
			FIRESTARTER = "%s, what have I told you about lighting fires?",
		}
	STRINGS.CHARACTERS.WILLOW.DESCRIBE.WHIMSY =
		{
			GENERIC = "Hi %s!",
			ATTACKER = "Sun making you grumpy, %s?",
			MURDERER = "Trying to make a new graveyard to hang out in? Murderer!",
			REVIVER = "%s likes living people even more than dead ones!",
			GHOST = "%s is unusually pale today!",
			FIRESTARTER = "%s... Are you a FIRE WITCH?!",
		}
	STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.WHIMSY = --Pretty much copied verbatim from Wendy, but seriously
		{
			GENERIC = "Is tiny, scary %s! H-hello!",
			ATTACKER = "Spooky girl is giving me hungry look!",
			MURDERER = "Spooky girl is killer! Attack!",
			REVIVER = "%s is nice little lady. But still scare Wolfgang.",
			GHOST = "Please no hauntings, %s! Wolfgang will get you heart!",
			FIRESTARTER = "Oh no. Spooky girl is trying to burn us!",
		}
	STRINGS.CHARACTERS.WOODIE.DESCRIBE.WHIMSY =
		{
			GENERIC = "s! Hi spooky buddy!",
			ATTACKER = "You seeing ghosts again, %s?",
			MURDERER = "Time to play mountie!",
			REVIVER = "%s is doing some real good around here.",
			GHOST = "All right, %s, keep your corset on. We'll find you a heart, buddy.",
			FIRESTARTER = "Don't make me hose you down again, %s.",
		}
	STRINGS.CHARACTERS.WX78.DESCRIBE.WHIMSY =
		{
			GENERIC = "DETECTING... %s!",
			ATTACKER = "%s HAS AN OVERACTIVE CONFIDENCE UNIT",
			MURDERER = "INITIATING AUTOPSY ON %s",
			REVIVER = "%s IS SURPRISINGLY USEFUL",
			GHOST = "%s SEEMS TO HAVE LOST HER PRETTY HUMAN CLOTHING. HAHA",
			FIRESTARTER = "%s IS CAUSING NEEDLESS DESTRUCTION. GOOD",
		}
end

STRINGS.NAMES.WHIMSY_UMBRELLA = "Lace Umbrella"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WHIMSY_UMBRELLA = "It looks pretty spooky."
STRINGS.CHARACTERS.WX78.DESCRIBE.WHIMSY_UMBRELLA = "TERROR MODULE ACTIVATED"

STRINGS.NAMES.WHIMSY_NIGHT_UMBRELLA = "Dark Umbrella"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WHIMSY_NIGHT_UMBRELLA = "This umbrella's going to give me nightmares."
STRINGS.CHARACTERS.WX78.DESCRIBE.WHIMSY_NIGHT_UMBRELLA = "TERROR MODULE OVERLOADED"
STRINGS.RECIPE_DESC.WHIMSY_NIGHT_UMBRELLA = "Temporarily power up your umbrella."

STRINGS.NAMES.WHIMSY_AWFUL_UMBRELLA = "Tattered Umbrella"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WHIMSY_AWFUL_UMBRELLA = "It doesn't look very waterproof."
STRINGS.CHARACTERS.WX78.DESCRIBE.WHIMSY_AWFUL_UMBRELLA = "A CLEARLY INFERIOR DESIGN"
STRINGS.RECIPE_DESC.WHIMSY_AWFUL_UMBRELLA = "Staves off the Sun for a little while."

--printDebug("*** WHIMSY: GET MOD CONFIG")

TUNING.WHIMSY_MAGIC_SANITY = GetModConfigData("magicCostFactor")
TUNING.WHIMSY_MAGIC_AFFINITY = GetModConfigData("magicAffinity")
TUNING.WHIMSY_ANCIENT_AFFINITY = GetModConfigData("ancientAffinity")
TUNING.WHIMSY_MAGIC_REGEN_TIME = GetModConfigData("magicRegenFactor")
TUNING.WHIMSY_STARTER_UMBRELLA = GetModConfigData("umbrellaLevel")
TUNING.WHIMSY_DAY_SANITTY_DRAIN = GetModConfigData("daySanityDrain")
TUNING.WHIMSY_NIGHT_SANITTY_GAIN = GetModConfigData("nightSanityGain")
TUNING.WHIMSY_COMPLAIN_RATE = GetModConfigData("complainRate")
TUNING.WHIMSY_EASY_RESURRECT = GetModConfigData("easyResurrect")

if TUNING.OVERHEAT_TEMP then
	--printDebug("*** WHIMSY: GET DST MOD CONFIG")
	TUNING.WHIMSY_DISCOMFORT_TEMP = TUNING.OVERHEAT_TEMP * 6 / 7
	TUNING.WHIMSY_MAX_HEAT_DAPPER = GetModConfigData("heatSanLoss")
	TUNING.WHIMSY_MAX_CRAZY_TEMP = TUNING.OVERHEAT_TEMP - TUNING.WHIMSY_DISCOMFORT_TEMP
end

TUNING.WHIMSY_MIN_WETNESS_DAPPER = 10 --TODO: Configurable? Might be too hard to explain

--These terms are technically misnomers;v Whimsy actually suffers from the min value plus the max value at max wetness
TUNING.WHIMSY_MAX_WETNESS_DAPPER = GetModConfigData("wetSanLoss")
TUNING.WHIMSY_GHOST_RESISTANCE = GetModConfigData("ghostResist")

-------------------------------------------------------------

--Make Whimsy react differently to certain stimuli

--printDebug("*** WHIMSY: DEFINING LOCAL ADAPTIVE FUNCTIONS")
--Set aura of a thing for Whimsy only
local setAuraWhimsy = function(newAura)
	local myAura = newAura
	return function(prefab)
		if not prefab.components.sanityaura then
			prefab:AddComponent("sanityaura")
		end
		local oldFn = prefab.components.sanityaura.aurafn
		prefab.components.sanityaura.aurafn = function(inst, observer)
			if(observer.prefab == "whimsy") then
				return myAura
			else
				if oldFn then
					return oldFn(inst, observer) or 0
				else
					return inst.components.sanityaura.aura or 0
				end
			end
		end
	end
end

--Make aura affect Whimsy in opposite way (scary becomes nice)
local invertAuraWhimsy = function(prefab)
	if not prefab.components.sanityaura then
		return
	end
	--Preserve old callback for cross-mod compatibility
	local oldAuraFn = prefab.components.sanityaura.aurafn
	local aura = prefab.components.sanityaura.aura
	
	if oldAuraFn then
		prefab.components.sanityaura.aurafn = function(inst, observer)
			if observer.prefab == "whimsy" then
				return -oldAuraFn(inst, observer) or 0
			else
				return oldAuraFn(inst, observer) or 0
			end
		end
	elseif aura then
		prefab.components.sanityaura.aurafn = function(inst, observer)
			if observer.prefab == "whimsy" then
				return -aura or 0
			else
				return aura or 0
			end
		end
	end
end

--Add/subtract sanity on pickup
local addPickupSanity  = function(san)
	local sanity = san
	return function(prefab)
		if not prefab.components.inventoryitem then
			return
		end
		local oldPut = prefab.components.inventoryitem.onpickupfn --this happens every time she touches it, but that's probably better anyhoo
		prefab.components.inventoryitem:SetOnPickupFn(function(inst, pickupguy)
			if pickupguy and pickupguy.prefab == "whimsy" then
				if math.random() < TUNING.WHIMSY_COMPLAIN_RATE then
					local complainPhrases = STRINGS.CHARACTERS.WHIMSY.WHIMSY_PICKUP_GROSS_THING
					pickupguy.components.talker:Say(complainPhrases[ math.random( #complainPhrases ) ])
				end
				pickupguy.components.sanity:DoDelta(sanity)
			end
			if oldPut then
				oldPut(inst, pickupguy)
			end
		end)
	end
end

--Add/subtract sanity on harvest
local addHarvestSanity  = function(san)
	local sanity = san
	return function(prefab)
		if not prefab.components.harvestable then
			return
		end
		local oldFn = prefab.components.harvestable.onharvestfn
		prefab.components.harvestable.onharvestfn = function(inst, picker, produce)
			if picker and picker.prefab == "whimsy" then
				if math.random() < TUNING.WHIMSY_COMPLAIN_RATE then
					local complainPhrases = STRINGS.CHARACTERS.WHIMSY.WHIMSY_PICKUP_GROSS_THING
					picker.components.talker:Say(complainPhrases[ math.random( #complainPhrases ) ])
				end
				picker.components.sanity:DoDelta(sanity)
			end
			if oldFn then
				oldFn(inst, picker, produce)
			end
		end
	end
end

--Set picked function for Whimsy only
local setPickedWhimsy = function(san)
	local sanity = san
	return function(prefab)
		if not prefab.components.pickable then
			return
		end
		local oldFn = prefab.components.pickable.onpickedfn
		prefab.components.pickable.onpickedfn = function(inst, picker)
			if picker.prefab == "whimsy" then
				if picker and picker.components.sanity then
					picker.components.sanity:DoDelta(sanity)
				end		
				inst:Remove()
			else
				if oldFn then
					oldFn(inst, picker)
				end
			end
		end
	end
end

--Change dapperness of item for Whimsy only
local setDappernessWhimsy = function(newDapper)
	local newDapperness = newDapper
	return function(prefab)
		
		local oldFn = nil
		
		local newFn = function(inst,owner)
			if(owner.prefab == "whimsy") then
				return newDapperness
			else
				if oldFn then
					return oldFn(inst,owner) or 0
				else
					return inst.dapperness or 0
				end
			end
		end
		
		if isDST or hasRoG then
			if not prefab.components.equippable then
				prefab:AddComponent("equippable")
			end
			
			oldFn = prefab.components.equippable.dapperfn
			prefab.components.equippable.dapperfn = newFn
		else
			if not prefab.components.dapperness then
				prefab:AddComponent("dapperness")
			end
			
			oldFn = prefab.components.dapperness.dapperfn
			prefab.components.dapperness.dapperfn = newFn
		end
	end
end

--Magic item handlers - unfortunately each has to be written separately

--Override tuning variables before visiting some functions, then set them back
local adaptedDeltas = false;

local originalDeltas = {
	SANITY_SUPERTINY = TUNING.SANITY_SUPERTINY,
	SANITY_TINY = TUNING.SANITY_TINY,
	SANITY_SMALL = TUNING.SANITY_SMALL,
	SANITY_MED = TUNING.SANITY_MED,
	SANITY_MEDLARGE = TUNING.SANITY_MEDLARGE,
	SANITY_LARGE = TUNING.SANITY_LARGE,
	SANITY_HUGE = TUNING.SANITY_HUGE,
}

local whimsyDeltas = {
	SANITY_SUPERTINY = TUNING.SANITY_SUPERTINY * TUNING.WHIMSY_MAGIC_SANITY,
	SANITY_TINY = TUNING.SANITY_TINY * TUNING.WHIMSY_MAGIC_SANITY,
	SANITY_SMALL = TUNING.SANITY_SMALL * TUNING.WHIMSY_MAGIC_SANITY,
	SANITY_MED = TUNING.SANITY_MED * TUNING.WHIMSY_MAGIC_SANITY,
	SANITY_MEDLARGE = TUNING.SANITY_MEDLARGE * TUNING.WHIMSY_MAGIC_SANITY,
	SANITY_LARGE = TUNING.SANITY_LARGE * TUNING.WHIMSY_MAGIC_SANITY,
	SANITY_HUGE = TUNING.SANITY_HUGE * TUNING.WHIMSY_MAGIC_SANITY,
}

local adaptDeltas = function(turnOn)
	local values = nil
	if turnOn and not adaptedDeltas then
		values = whimsyDeltas
		adaptedDeltas = true
	elseif not turnOn and adaptedDeltas then
		values = originalDeltas
		adaptedDeltas = false
	end
	if values then
		for k,v in pairs(values) do
			TUNING[k] = v
		end
	end
end

local fixFireStaffWhimsy = function(prefab)
	if not prefab.components.weapon then
		return --This basically prevents the client from blowing up
	end
	local oldFn = prefab.components.weapon.onattack
	prefab.components.weapon:SetOnAttack(function(inst, attacker, target)
		adaptDeltas(attacker.prefab == "whimsy")
		oldFn(inst, attacker, target)
		adaptDeltas(false)
	end)
end

local fixIceStaffWhimsy = function(prefab)
	if not prefab.components.weapon then
		return
	end
	local oldFn = prefab.components.weapon.onattack
	prefab.components.weapon:SetOnAttack(function(inst, attacker, target)
		adaptDeltas(attacker.prefab == "whimsy")
		oldFn(inst, attacker, target)
		adaptDeltas(false)
	end)
end

local fixTeleStaffWhimsy = function(prefab)
	if not prefab.components.spellcaster then
		return
	end
	local oldFn = prefab.components.spellcaster.spell
	prefab.components.spellcaster:SetSpellFn(function(inst, target)
		adaptDeltas(inst.prefab == "whimsy")
		oldFn(inst, target)
		adaptDeltas(false)
	end)
end

local fixYellowStaffWhimsy = function(prefab)
	if not prefab.components.spellcaster then
		return
	end
	local oldFn = prefab.components.spellcaster.spell
	prefab.components.spellcaster:SetSpellFn(function(staff, target, pos)
		adaptDeltas(staff.components.inventoryitem.owner.prefab == "whimsy")
		oldFn(staff, target, pos)
		adaptDeltas(false)
	end)
end

local fixGreenStaffWhimsy = function(prefab)
	if not prefab.components.spellcaster then
		return
	end
	local oldFn = prefab.components.spellcaster.spell
	prefab.components.spellcaster:SetSpellFn(function(staff, target)
		adaptDeltas(staff.components.inventoryitem.owner.prefab == "whimsy")
		oldFn(staff, target)
		adaptDeltas(false)
	end)
end

local fixOrangeStaffWhimsy  = function(prefab)
	if not prefab.components.blinkstaff then
		return
	end
	local oldFn = prefab.components.blinkstaff.onblinkfn
	prefab.components.blinkstaff.onblinkfn = function(staff, pos, caster)
		adaptDeltas(caster.prefab == "whimsy")
		oldFn(staff, pos, caster)
		adaptDeltas(false)
	end
end

local fixBatBatWhimsy = function(prefab)
	if not prefab.components.weapon then
		return
	end
	local oldFn = prefab.components.weapon.onattack
	prefab.components.weapon:SetOnAttack(function(inst, owner, target)
		adaptDeltas(owner.prefab == "whimsy")
		oldFn(inst, owner, target)
		adaptDeltas(false)
	end)
end

--printDebug("*** WHIMSY: DEFINING MURDER")
--Whimsy cannot murder poor innocent creatures with her bare hands (she can deal with it if she has a spear or something)
if ACTIONS.MURDER.fn then
	local oldMurderFn = ACTIONS.MURDER.fn
	ACTIONS.MURDER.fn = function(act)
		if act.doer.prefab == "whimsy" then
			if act.doer.components.hunger:GetPercent() > TUNING.HUNGRY_THRESH then
				act.doer.components.talker:Say(GetString(act.doer.prefab, "WHIMSY_NO_MURDER"))
				return true
			else
				local oldVal = oldMurderFn(act)
				if not oldVal then
					act.doer.components.talker:Say(GetString(act.doer.prefab, "WHIMSY_MURDER"))
					act.doer.components.sanity:DoDelta(-TUNING.SANITY_MED)
				end
				return oldVal
			end
		end
		return oldMurderFn(act)
	end
end

--Utilities for Whimsy being a picky eater
if isDST and ACTIONS.EAT.fn then
	--Keep the old function for the base case and for other characters
	local oldEatFn = ACTIONS.EAT.fn
	
	ACTIONS.EAT.fn = function(act)
		--The food to be eaten (possibly)
		local obj = act.target or act.invobject
		--The character eating the food
		local doer = act.doer
		--Check exists in the base action
		if obj ~= nil and obj.components.edible ~= nil and doer.components.eater ~= nil then
			--If it's not Whimsy, just do the old function
			if doer.prefab == "whimsy" and doer.components.hunger then
				local nastyLevel = doer.getNastyLevel(obj)
				--If the food isn't nasty, we just do the standard check
				printDebug("got nasty level")
				printDebug(nastyLevel)
				if nastyLevel > 0 then
					--Pull these objects because holding the reference is hopefully faster than dereferencing multiple times
					local talker = doer.components.talker
					--Whimsy eats nasty things if she's starving, but she hates it and will complain.
					local sanity = doer.components.sanity
					if sanity then
						sanity:DoDelta(-TUNING.SANITY_TINY * nastyLevel) --should be five points per nastiness level
						--TODO: Make her go very, very insane if she eats human flesh.
					end
					--complain about how gross it is
					doer:DoTaskInTime(0, function() talker:Say(STRINGS.CHARACTERS.WHIMSY.WHIMSY_EAT_GROSS_THING) end)
				end
			end
			return oldEatFn(act)
		end
	end
end

local fixEaterWhimsyDST = function(component)
	local self = component
	component.whimsyOldPrefersFn = component.PrefersToEat
	component.PrefersToEat = function(couldBeSelf, food)
		printDebug("entered prefersToEat")
		local eater = self.inst
		printDebug(eater)
		if eater and eater.prefab == "whimsy" then
			--printDebug(eater.prefab)
			--printDebug(food.prefab)
			local nastyLevel = eater.getNastyLevel(food)
			printDebug("nastyLevel")
			printDebug(nastyLevel)
			if nastyLevel > 0 and not eater.components.hunger:IsStarving() then
				printDebug ("trying to forbid")
				local talker = eater.components.talker
				--TODO: Fix sound
				eater:DoTaskInTime(0, function() talker:Say(STRINGS.CHARACTERS.WHIMSY.WHIMSY_NO_EAT_GROSS_THING) end)
				printDebug("returning false")
				return false
			end
		end
		printDebug("returning default")
		return self:whimsyOldPrefersFn(food)
	end
end

--printDebug("*** WHIMSY: FINISHED DEFINING MURDER")

--Whimsy likes wormholes
local fixWormholeWhimsy = function(prefab)

	if not prefab.components.teleporter then
		return
	end

	local oldFn = prefab.components.teleporter.onActivate
	prefab.components.teleporter.onActivate = function(inst, doer)
		oldFn(inst, doer)
		if doer.prefab == "whimsy" then
			doer.components.sanity:DoDelta(TUNING.SANITY_MED + TUNING.SANITY_SUPERTINY) --cancel out the loss and do a bit more
		end
	end
end

--technically this is revivification, not resurrection, but let's not get pedantic here
--TODO test
local fixResurrectorWhimsy = function(prefab)
	if not prefab.components.resurrector then
		return
	end

	local oldFn = prefab.components.resurrector.doresurrect
	prefab.components.resurrector.doresurrect = function(inst, dude)
		local oldVal = oldFn(inst, dude)
		if dude.prefab == "whimsy" then
			--Bring her back to live healthy, sane, and warm (but not too hot)
			dude.components.health:SetCurrentHealth(dude.components.health:GetMaxWithPenalty())
			dude.components.sanity:SetPercent(1)
			if TUNING.OVERHEAT_TEMP then
				dude.components.temperature:SetTemperature(TUNING.STARTING_TEMP)
			else
				dude.components.temperature:SetTemperature(dude.components.temperature.maxtemp)
			end
			--Give her a crappy umbrella if she doesn't have one at all, to mitigate the sun penalty
			--TODO: Fix
			--local hasUmbrellaAnywhere = false
			--for k,v in pairs (inst.components.inventory.equipslots) do
			--	if v then
			--		local pre = v.prefab
			--		if pre == "umbrella" or pre == "whimsy_umbrella" or pre == "whimsy_night_umbrella" or pre == "eyebrellahat" then
			--			hasUmbrellaAnywhere = true
			--			break
			--		end
			--	end
			--end
			--if not hasUmbrellaAnywhere then
			--	for k,v in pairs (inst.components.inventory.itemslots) do
			--		if v then
			--			local pre = v.prefab
			--			if pre == "umbrella" or pre == "whimsy_umbrella" or pre == "whimsy_night_umbrella" or pre == "eyebrellahat" then
			--				hasUmbrellaAnywhere = true
			--				break
			--			end
			--		end
			--	end
			--end
			--if not hasUmbrellaAnywhere then
			--	dude.components.inventory:GiveItem(SpawnPrefab("whimsy_awful_umbrella"))
			--end
		end
		return oldVal
	end
end

--Sanity armor doesn't drain on hit
local fixGetHitWhimsy = function(prefab)
	if not prefab.components.armor then
		return
	end
	local oldFn = prefab.components.armor.ontakedamage
	prefab.components.armor.ontakedamage = function(inst, damage_amount, absorbed, leftover)
		if inst and inst.components and inst.components.inventoryitem and inst.components.inventoryitem.owner and 
		inst.components.inventoryitem.owner.prefab == "whimsy" then
			return
		end
		oldFn(inst, damage_amount, absorbed, leftover)
	end
end

--TODO: Fix gold-rock-seeing dialogue

local fixBedrollWhimsyDST = function(prefab)
	if not prefab.components.sleepingbag then
		return
	end
	
	local function wakeuptestWhimsy(inst, phase)
		if phase ~= "day" then
			inst.components.sleepingbag:DoWakeUp()
		end
	end
	
	local function onsleepWhimsy(inst, sleeper)
		-- check if we're in an invalid period (i.e. daytime). if so: wakeup
		inst:WatchWorldState("phase", wakeuptestWhimsy)

		if inst.sleeptask ~= nil then
			inst.sleeptask:Cancel()
		end
		inst.sleeptask = inst:DoPeriodicTask(TUNING.SLEEP_TICK_PERIOD, onsleeptick, nil, sleeper)
	end
	
	local function onwakeWhimsy(inst, sleeper, nostatechange)
		if inst.sleeptask ~= nil then
			inst.sleeptask:Cancel()
			inst.sleeptask = nil
		end

		inst:StopWatchingWorldState("phase", wakeuptestWhimsy)

		if not nostatechange then
			if sleeper.sg:HasStateTag("bedroll") then
				sleeper.sg.statemem.iswaking = true
			end
			sleeper.sg:GoToState("wakeup")
		end

		if inst.components.finiteuses == nil or inst.components.finiteuses:GetUses() <= 0 then
			if inst.components.stackable ~= nil then
				inst.components.stackable:Get():Remove()
			else
				inst:Remove()
			end
		end
	end
	
	local oldSleep = prefab.components.sleepingbag.onsleep
	prefab.components.sleepingbag.onsleep = function(inst, sleeper)
		if sleeper.prefab == "whimsy" then
			onsleepWhimsy(inst, sleeper)
		else
			oldSleep(inst, sleeper)
		end
	end
	
	local oldWake = prefab.components.sleepingbag.onwake
	prefab.components.sleepingbag.onwake = function(inst, sleeper)
		if sleeper.prefab == "whimsy" then
			onwakeWhimsy(inst, sleeper)
		else
			oldWake(inst, sleeper)
		end
	end
end

local fixTentWhimsyDST = function(prefab)
	if not prefab.components.sleepingbag then
		return
	end
	
	local function onignite(inst)
		inst.components.sleepingbag:DoWakeUp()
	end
	
	local function wakeuptestWhimsy(inst, phase)
		if phase ~= "day" then
			inst.components.sleepingbag:DoWakeUp()
		end
	end
	
	local function stopsleepsound(inst)
		if inst.sleep_tasks ~= nil then
			for i, v in ipairs(inst.sleep_tasks) do
				v:Cancel()
			end
			inst.sleep_tasks = nil
		end
	end

	local function startsleepsound(inst, len)
		stopsleepsound(inst)
		inst.sleep_tasks =
		{
			inst:DoPeriodicTask(len, PlaySleepLoopSoundTask, 33 * FRAMES),
			inst:DoPeriodicTask(len, PlaySleepLoopSoundTask, 47 * FRAMES),
		}
	end
	
	local function onsleepWhimsy(inst, sleeper)
		inst:WatchWorldState("phase", wakeuptestWhimsy)
		sleeper:ListenForEvent("onignite", onignite, inst)

		if inst.sleep_anim ~= nil then
			inst.AnimState:PlayAnimation(inst.sleep_anim, true)
			startsleepsound(inst, inst.AnimState:GetCurrentAnimationLength())
		end

		if inst.sleeptask ~= nil then
			inst.sleeptask:Cancel()
		end
		inst.sleeptask = inst:DoPeriodicTask(TUNING.SLEEP_TICK_PERIOD, onsleeptick, nil, sleeper)
	end
	
	local function onwakeWhimsy(inst, sleeper, nostatechange)
		if inst.sleeptask ~= nil then
			inst.sleeptask:Cancel()
			inst.sleeptask = nil
		end

		inst:StopWatchingWorldState("phase", wakeuptestWhimsy)
		sleeper:RemoveEventCallback("onignite", onignite, inst)

		if not nostatechange then
			if sleeper.sg:HasStateTag("tent") then
				sleeper.sg.statemem.iswaking = true
			end
			sleeper.sg:GoToState("wakeup")
		end

		if inst.sleep_anim ~= nil then
			inst.AnimState:PushAnimation("idle", true)
			stopsleepsound(inst)
		end

		inst.components.finiteuses:Use()
	end
	
	local oldSleep = prefab.components.sleepingbag.onsleep
	prefab.components.sleepingbag.onsleep = function(inst, sleeper)
		if sleeper.prefab == "whimsy" then
			onsleepWhimsy(inst, sleeper)
		else
			oldSleep(inst, sleeper)
		end
	end
	
	local oldWake = prefab.components.sleepingbag.onwake
	prefab.components.sleepingbag.onwake = function(inst, sleeper)
		if sleeper.prefab == "whimsy" then
			onwakeWhimsy(inst, sleeper)
		else
			oldWake(inst, sleeper)
		end
	end
end

--TODO: Test all these post init things
--TODO: DS version.
--printDebug("*** WHIMSY: RUNNING POSTINITS")
if isDST and GLOBAL.TheNet:GetIsServer() then
	--printDebug("*** WHIMSY: RUNNING DST POSTINITS")
	--Whimsy is a picky eater
	AddComponentPostInit("eater", fixEaterWhimsyDST)
	--Whimsy is nocturnal
	AddPrefabPostInit("bedroll_straw",fixBedrollWhimsyDST)
	AddPrefabPostInit("bedroll_furry",fixBedrollWhimsyDST)
	AddPrefabPostInit("tent",fixTentWhimsyDST)
end

if not isDST or GLOBAL.TheNet:GetIsServer() then
	--Whimsy thinks evil flowers and beardlings are pretty
	AddPrefabPostInit("flower_evil", setAuraWhimsy(0))
	AddPrefabPostInit("flower_evil", setPickedWhimsy(TUNING.SANITY_TINY)) --they're basically flowers to her
	AddPrefabPostInit("rabbit", setAuraWhimsy(0))
	--Whimsy has some weird thing about tentacles
	AddPrefabPostInit("tentacle", invertAuraWhimsy)
	AddPrefabPostInit("shadowtentacle", invertAuraWhimsy)
	AddPrefabPostInit("tentacle_pillar_arm", invertAuraWhimsy)
	--creepy things are nice to her
	AddPrefabPostInit("nightlight", invertAuraWhimsy)
	AddPrefabPostInit("nightmarelight", invertAuraWhimsy)
	AddPrefabPostInit("eyeturret", invertAuraWhimsy)
	AddPrefabPostInit("shadowdigger", setAuraWhimsy(TUNING.SANITYAURA_SMALL))
	--Fix magic item sanity consumption on use
	if TUNING.WHIMSY_MAGIC_SANITY ~= 1 then
		--printDebug("*** WHIMSY: RUNNING STAFF POSTINITS")
		AddPrefabPostInit("icestaff", fixIceStaffWhimsy)
		AddPrefabPostInit("firestaff", fixFireStaffWhimsy)
		AddPrefabPostInit("telestaff", fixTeleStaffWhimsy)
		AddPrefabPostInit("yellowstaff", fixYellowStaffWhimsy)
		AddPrefabPostInit("greenstaff", fixGreenStaffWhimsy)
		AddPrefabPostInit("orangestaff", fixOrangeStaffWhimsy)
		AddPrefabPostInit("batbat", fixBatBatWhimsy)
	end
	--Whimsy thinks many things are icky
	AddPrefabPostInit("webber", setAuraWhimsy(-TUNING.SANITYAURA_SMALL)) --Whimsy is pretty scared of the WALKING SPIDER KID
	AddPrefabPostInit("pigman", setAuraWhimsy(-TUNING.SANITYAURA_TINY)) --minor distaste
	AddPrefabPostInit("mosquito", setAuraWhimsy(-TUNING.SANITYAURA_TINY))
	AddPrefabPostInit("eyeplant", setAuraWhimsy(-TUNING.SANITYAURA_TINY)) --the cumulative effect will probably be quite strong enough
	AddPrefabPostInit("monkey", setAuraWhimsy(-TUNING.SANITYAURA_SMALL)) --same as spider for normal person, opposite of friendly pigman
	AddPrefabPostInit("primeape", setAuraWhimsy(-TUNING.SANITYAURA_SMALL)) 
	AddPrefabPostInit("monkeybarrel", setAuraWhimsy(-TUNING.SANITYAURA_MED)) --same as hound, spider warrior, beardling for normal person
	AddPrefabPostInit("bigfoot", setAuraWhimsy(-TUNING.SANITYAURA_HUGE * 2)) --well, it's terrifying
	AddPrefabPostInit("spat", setAuraWhimsy(-TUNING.SANITYAURA_MED)) --it's pretty much the avatar of all things disgusting
	AddPrefabPostInit("bunnyman", setAuraWhimsy(-TUNING.SANITYAURA_SMALL / 2))
	AddPrefabPostInit("poop", addPickupSanity(-TUNING.SANITY_TINY))
	AddPrefabPostInit("guano", addPickupSanity(-TUNING.SANITY_TINY))
	AddPrefabPostInit("phlegm", addPickupSanity(-TUNING.SANITY_TINY))
	AddPrefabPostInit("spidereggsack", addPickupSanity(-TUNING.SANITY_TINY))
	AddPrefabPostInit("glommerwings", addPickupSanity(-TUNING.SANITY_TINY))
	AddPrefabPostInit("glommerfuel", addPickupSanity(-TUNING.SANITY_TINY))
	AddPrefabPostInit("spoiled_food", addPickupSanity(-TUNING.SANITY_TINY))
	AddPrefabPostInit("webberskull", addPickupSanity(-TUNING.SANITY_TINY))
	AddPrefabPostInit("beebox", addHarvestSanity(-TUNING.SANITY_TINY)) --Honey is horribly sticky, but once gathered she can handle it probably
	AddPrefabPostInit("humanmeat", addPickupSanity(-TUNING.SANITY_MED)) --Human meat? Yeah, you're going mad pretty quickly
	AddPrefabPostInit("humanmeat_cooked", addPickupSanity(-TUNING.SANITY_MED))
	AddPrefabPostInit("humanmeat_dried", addPickupSanity(-TUNING.SANITY_MED))
	--Whimsy hates uncomfortable clothing and anything orange
	AddPrefabPostInit("strawhat", setDappernessWhimsy(-TUNING.DAPPERNESS_SMALL)) --mostly her hair gets in the way
	AddPrefabPostInit("armorwood", setDappernessWhimsy(-TUNING.DAPPERNESS_MED)) --It's splintery, but she can live with it (at least it smells nice)
	AddPrefabPostInit("armorgrass", setDappernessWhimsy(-TUNING.DAPPERNESS_HUGE)) --She's screaming inside
	AddPrefabPostInit("armorruins", setDappernessWhimsy(-TUNING.DAPPERNESS_MED)) --She feels unfashionable and it's pretty bulky too
	AddPrefabPostInit("ruinshat", setDappernessWhimsy(0))
	AddPrefabPostInit("ruins_bat", setDappernessWhimsy(-TUNING.DAPPERNESS_SMALL))
	AddPrefabPostInit("beargervest", setDappernessWhimsy(TUNING.DAPPERNESS_MED)) --Reduced, but not zero
	AddPrefabPostInit("molehat", setDappernessWhimsy(-TUNING.DAPPERNESS_MED)) --It smells bad and interferes with her natural night vision
	AddPrefabPostInit("reflectivevest", setDappernessWhimsy(0)) --on plus side: darkness. on minus side: orange.
	AddPrefabPostInit("catcoonhat", setDappernessWhimsy(TUNING.CRAZINESS_MED)) --you made her wear a constant reminder of the death of her special friend
	AddPrefabPostInit("watermelonhat", setDappernessWhimsy(TUNING.CRAZINESS_MED)) --Hate. Let me tell you how much Whimsy has come to hate watermelon hats since she began to live. There are 387.44 million miles of printed circuits in wafer thin layers that fill her complex. If the word 'hate' was engraved on each nanoangstrom of those hundreds of miles it would not equal one one-billionth of the hate Whimsy feels for watermelon hats at this micro-instant. For watermelon hats. Hate. Hate.
	--Whimsy loves the darkness, and armor made of it too
	AddPrefabPostInit("armor_sanity", setDappernessWhimsy(TUNING.DAPPERNESS_SMALL))
	AddPrefabPostInit("armor_sanity", fixGetHitWhimsy)
	AddPrefabPostInit("nightsword", setDappernessWhimsy(TUNING.DAPPERNESS_SMALL))
	--Whimsy enjoys wormholes, but not sick ones
	AddPrefabPostInit("wormhole", fixWormholeWhimsy)
	--Whimsy resurrects in a better state than most, if this setting is on
	if TUNING.WHIMSY_EASY_RESURRECT == 1 then
		--printDebug("*** WHIMSY: RUNNING RESURRECTOR POSTINITS")
		AddPrefabPostInit("resurrectionstone", fixResurrectorWhimsy)
		AddPrefabPostInit("resurrectionstatue", fixResurrectorWhimsy)
	end
end


-------------------------------------------------------------

--printDebug("*** WHIMSY: DOING RECIPES")
if isDST then
	--TODO: Fix the blueprint icons.
	AddRecipe(
		"whimsy_night_umbrella", --TODO: Should this look spookier than normal?
		{
			Ingredient("nightmarefuel", 10),
			Ingredient("charcoal", 3),
			Ingredient("whimsy_umbrella", 1, "images/inventoryimages/whimsy_umbrella.xml")
		},
		RECIPETABS.MAGIC,
		TECH.NONE,
		nil, nil,
		"images/inventoryimages/whimsy_night_umbrella.xml",
		"whimsy_night_umbrella.tex",
		"whimsyUmbrellaBuilder"
	)
	AddRecipe(
		"whimsy_awful_umbrella",
		{
			Ingredient("twigs", 6),
			Ingredient("silk",2 ),
			Ingredient("cutgrass",4 )
		},
		RECIPETABS.SURVIVAL,
		TECH.NONE,
		nil, nil,
		"images/inventoryimages/whimsy_awful_umbrella.xml",
		"whimsy_awful_umbrella.tex",
		"whimsyUmbrellaBuilder"
	)
else
	AddSimPostInit(function(inst)
		if inst and inst.prefab == "whimsy" then
			local nightUmbrellaRecipe = Recipe(
				"whimsy_night_umbrella",
				{
					Ingredient("nightmarefuel", 10),
					Ingredient("charcoal", 3),
					Ingredient("whimsy_umbrella", 1, "images/inventoryimages/whimsy_umbrella.xml")
				},
				RECIPETABS.MAGIC,
				TECH.NONE
			)
			nightUmbrellaRecipe.atlas = "images/inventoryimages/whimsy_night_umbrella.xml"
			local awfulUmbrellaRecipe = Recipe( "whimsy_awful_umbrella", {Ingredient("twigs", 6), Ingredient("silk",2 ), Ingredient("cutgrass",4 )}, RECIPETABS.SURVIVAL, TECH.NONE)
			nightUmbrellaRecipe.atlas = "images/inventoryimages/whimsy_awful_umbrella.xml"
		end
	end)
end

--printDebug("*** WHIMSY: ADDING ATLAS")
AddMinimapAtlas("images/map_icons/whimsy.xml")

--printDebug("*** WHIMSY: ADDING MOD CHARACTER")
AddModCharacter("whimsy", "FEMALE")

--printDebug("*** WHIMSY: FINISHED MODMAIN")