--require("debugprint")
local function printDebug(msg)
	print(msg)
end

--printDebug("*** WHIMSY: ENTERING WHIMSY.LUA")

local MakePlayerCharacter = require "prefabs/player_common"

--printDebug("*** WHIMSY.LUA: SETTING GAME MODE VARS")
local isDST = TheSim:GetGameID() == "DST"
local hasRoG = isDST

if not isDST then
	if TUNING.AUTUMN_LENGTH then --TODO: Find a less awful way to do this
		hasRoG = true
	else
		hasRoG = false
	end
end

--printDebug("*** WHIMSY.LUA: LOADING ASSETS")

local assets = {

	Asset( "ANIM", "anim/player_basic.zip" ),
	Asset( "ANIM", "anim/player_idles_shiver.zip" ),
	Asset( "ANIM", "anim/player_actions.zip" ),
	Asset( "ANIM", "anim/player_actions_axe.zip" ),
	Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
	Asset( "ANIM", "anim/player_actions_shovel.zip" ),
	Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
	Asset( "ANIM", "anim/player_actions_eat.zip" ),
	Asset( "ANIM", "anim/player_actions_item.zip" ),
	Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
	Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
	Asset( "ANIM", "anim/player_actions_fishing.zip" ),
	Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
	Asset( "ANIM", "anim/player_bush_hat.zip" ),
	Asset( "ANIM", "anim/player_attacks.zip" ),
	Asset( "ANIM", "anim/player_idles.zip" ),
	Asset( "ANIM", "anim/player_rebirth.zip" ),
	Asset( "ANIM", "anim/player_jump.zip" ),
	Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
	Asset( "ANIM", "anim/player_teleport.zip" ),
	Asset( "ANIM", "anim/wilson_fx.zip" ),
	Asset( "ANIM", "anim/player_one_man_band.zip" ),
	Asset( "ANIM", "anim/shadow_hands.zip" ),
	Asset( "SOUND", "sound/sfx.fsb" ),
	Asset( "SOUND", "sound/willow.fsb" ),
	Asset( "ANIM", "anim/beard.zip" ),

	Asset( "ANIM", "anim/whimsy.zip" ),
	Asset( "ANIM", "anim/ghost_whimsy_build.zip" ),
	
	Asset( "IMAGE", "images/colour_cubes/whimsy_cave_cc.tex" ),
}
local prefabs = {}

local start_inv =
{
}

--Configurable umbrella have-ness
local umbrellaLevel = TUNING.WHIMSY_STARTER_UMBRELLA
if umbrellaLevel ~= "" then
	table.insert(start_inv, umbrellaLevel)
end

local hasPlayerVision = isDST or hasRoG

local wasDay
local isGlowing

--Determine whether it's dark/raining, whether or not we're in DST
local getDarkness
local getDusk
local getDay
local getRaining
local getCave
--complain of excessive heat
local complainHotFire
--Retrieve the world or player object, whether or not we're in DST
local myWorld
local myPlayer

--printDebug("*** WHIMSY.LUA: SETTING UTIL FUNCTIONS")

if isDST then
	--printDebug("*** WHIMSY.LUA: IS DST")
	getDarkness = function()
		return (TheWorld.state and TheWorld.state.isnight) or TheWorld:HasTag("cave")
	end
	getDusk = function()
		return (TheWorld.state and TheWorld.state.isdusk)
	end
	getDay = function()
		return (TheWorld.state and TheWorld.state.isday)
	end
	getRaining = function()
		return TheWorld.state.israining
	end
	getCave = function()
		return TheWorld:HasTag("cave")
	end
	myWorld = function()
		return TheWorld
	end
	myPlayer = function()
		return ThePlayer
	end
	complainHotFire = function(inst)
		inst.whimsyComplainHot:push()
	end
else
	--printDebug("*** WHIMSY.LUA: IS NOT DST")
	getDarkness = function()
		return (GetClock() and GetClock():IsNight()) or (GetWorld() and GetWorld():IsCave())
	end
	getDusk = function()
		return (GetClock() and GetClock():IsDusk())
	end
	getDay = function()
		return (GetClock() and GetClock():IsDay())
	end
	getRaining = function()
		return GetSeasonManager() and GetSeasonManager():IsRaining()
	end
	getCave = function()
		return GetWorld():HasTag("cave")
	end
	myWorld = function()
		return GetWorld()
	end
	myPlayer = function()
		return GetPlayer()
	end
	complainHotFire = function(inst)
		complainHotTalker(inst)
	end
end

--TODO: Build this statically at load
local getWetness = function(inst)
	if inst.components.moisture then
		return inst.components.moisture:GetMoisturePercent()
	end
	return 0
end

local nastyFoods = {
		batwing = 1,
		blubber = 1,
		cactus_meat = 1,
		cookedmandrake = 4,
		cookedmonstermeat = 1,
		coral_brain = 2,
		dead_swordfish = 1,
		deerclops_eyeball = 3,
		doydoyegg = 1,
		dragoonheart = 1,
		drumstick = 1,
		eel = 1,
		egg = 1,
		fish = 1,
		fish_med = 1,
		fish_raw = 1,
		fish_raw_small = 1,
		froglegs = 1,
		glommerfuel = 1,
		halloweencandy_6 = 2,
		humanmeat = 9999, --if you make my Whimsy dine on human flesh, you pretty much deserve what you get.
		humanmeat_cooked = 9999,
		humanmeat_dried = 9999,
		jellyfish_dead = 2,
		limpets = 1,
		lobster_dead = 1,
		mandrake = 5,
		mandrakesoup = 4,
		meat = 1,
		minotaurhorn = 1,
		monsterlasagna = 1,
		monstermeat = 1,
		monstertartare = 1,
		monstermeat_dried = 1,
		mussel = 1,
		mysterymeat = 4,
		phlegm = 5,
		plantmeat = 2,
		plantmeat_cooked = 1,
		rottenegg = 2,
		shark_fin = 1,
		smallmeat = 1,
		spoiled_fish = 4,
		spoiled_food = 4,
		tallbirdegg = 1,
		tallbirdegg_cracked = 4,
		tigereye = 3,
		tropical_fish = 1,
		trunk_summer = 1,
		trunk_winter = 1,
		wetgoop = 3,
	}

local getNastyLevel = function(food)
	--printDebug("entering getNastyLevel")
	local nastyLevel = nastyFoods[food.prefab] or 0
	--printDebug("prefab")
	--printDebug(food.prefab)
	--printDebug("innate nastyLevel")
	--printDebug(nastyFoods[food.prefab])
	--printDebug("current nastyLevel")
	--printDebug(nastyLevel)
	if food.components.perishable then
		if food.components.perishable:IsSpoiled() then
			nastyLevel = nastyLevel + 2
		elseif food.components.perishable:IsStale() then
			nastyLevel = nastyLevel + 1
		end
	end
	--printDebug("final")
	--printDebug(nastyLevel)
	return nastyLevel
end

local complainHotTalker = function(inst)
	inst.components.talker:Say(STRINGS.CHARACTERS.WHIMSY.ANNOUNCE_TOO_HOT)
end

--Does the single player client have an umbrella? Don't call this client-side in DST.
local getHasUmbrella = function(inst)
	for k,v in pairs (inst.components.inventory.equipslots) do
		if v then
			local pre = v.prefab
			if pre == "umbrella" or pre == "whimsy_umbrella" or pre == "whimsy_night_umbrella" or pre == "eyebrellahat" then
				return true
			end
		end
	end
	return false
end

--Whimsy announces when it's dawn. She doesn't like it much.
local announceDawnDusk = function(inst)
	local hasUmbrella
	
	--printDebug("*** WHIMSY.LUA: YEAH!!")
	
	if (isDST and inst.whimsyBrightness:value()) or (not isDST and getDay()) then
		if isDST then
			hasUmbrella = (inst.whimsyGlowType:value() == 1) --Can't check this before setting it, so be careful!
		else
			hasUmbrella = getHasUmbrella(inst)
		end
		
		if hasUmbrella then
			inst.components.talker:Say(STRINGS.CHARACTERS.WHIMSY.ANNOUNCE_DAWN)
		else
			inst.components.talker:Say(STRINGS.CHARACTERS.WHIMSY.ANNOUNCE_DAWN_NO_UMBRELLA)
		end
	else
		inst.components.talker:Say(STRINGS.CHARACTERS.WHIMSY.ANNOUNCE_DUSK)
	end
	
	--printDebug("*** WHIMSY.LUA: Announced dawn!")
end

--printDebug("*** WHIMSY.LUA: SETTING NASTY FOODS")



--TODO: Give all this an optimization pass (whole project)

--Player vision related stuff, for DST/RoG night vision (much nicer than DS version)
local defaultCubes
local OnSeasonTickChangeCubes
local setCubes

if hasPlayerVision then
	--printDebug("*** WHIMSY.LUA: SETTING PLAYER CUBES")
	defaultCubes =
	{
		day = "images/colour_cubes/day05_cc.tex",
		dusk = "images/colour_cubes/dusk03_cc.tex",
		night = "images/colour_cubes/purple_moon_cc.tex",
		--cave = "images/colour_cubes/whimsy_cave_cc.tex", --this crashes the server
		cave = "images/colour_cubes/caves_default.tex", --TODO improve this
	}
	
	OnSeasonTickChangeCubes = function (src, data)
		if data.season == "autumn" then
			defaultCubes.day = "images/colour_cubes/day05_cc.tex"
			defaultCubes.dusk = "images/colour_cubes/dusk03_cc.tex"
		elseif data.season == "winter" then
			defaultCubes.day = "images/colour_cubes/snow_cc.tex"
			defaultCubes.dusk = "images/colour_cubes/snowdusk_cc.tex"
		elseif data.season == "spring" then
			defaultCubes.day = "images/colour_cubes/spring_day_cc.tex"
			defaultCubes.dusk = "images/colour_cubes/spring_dusk_cc.tex"
		elseif data.season == "summer" then
			defaultCubes.day = "images/colour_cubes/summer_day_cc.tex"
			defaultCubes.dusk = "images/colour_cubes/summer_dusk_cc.tex"
		end
	end
	
	setCubes = function (inst)
		if inst.prefab ~= "whimsy" or not inst.components.playervision then
			return
		end
		
		local hasUmbrella
		
		if isDST then
			hasUmbrella = (inst.whimsyGlowType:value() == 1) --Can't check this before setting it, so be careful!
		else
			hasUmbrella = getHasUmbrella(inst)
		end
		
		local cubes
		
		--printDebug("*** WHIMSY.LUA: pong")
		if inst.components.playervision:HasGhostVision() then
			--printDebug("*** WHIMSY.LUA: GHOST COLOR CUBE")
			cubes = 
			{
				day = "images/colour_cubes/ghost_cc.tex",
				dusk = "images/colour_cubes/ghost_cc.tex",
				night = "images/colour_cubes/ghost_cc.tex",
				cave = "images/colour_cubes/ghost_cc.tex",
				calm = "images/colour_cubes/ghost_cc.tex",
				warn = "images/colour_cubes/ghost_cc.tex",
				wild = "images/colour_cubes/ghost_cc.tex",
				dawn = "images/colour_cubes/ghost_cc.tex"
			}
		elseif inst.components.playervision:HasNightmareVision() then
			local phasecube
			local phase = myWorld().state.nightmarephase
			if phase == "calm" then
				phasecube = "images/colour_cubes/ruins_dark_cc.tex"
				--printDebug("*** WHIMSY.LUA: CALM COLOR CUBE")
			elseif phase == "warn" then
				phasecube = "images/colour_cubes/ruins_dim_cc.tex"
				--printDebug("*** WHIMSY.LUA: WARN COLOR CUBE")
			elseif phase == "wild" then
				phasecube = "images/colour_cubes/ruins_light_cc.tex"
				--printDebug("*** WHIMSY.LUA: WILD COLOR CUBE")
			elseif phase == "dawn" then
				phasecube = "images/colour_cubes/ruins_dim_cc.tex"
				--printDebug("*** WHIMSY.LUA: DAWN COLOR CUBE")
			else
				phasecube = "images/colour_cubes/ruins_dark_cc.tex"
				--printDebug("*** WHIMSY.LUA: SHOULD NOT HAPPEN COLOR CUBE")
			end
			cubes = 
			{
				day = phasecube,
				dusk = phasecube,
				night = phasecube,
				cave = phasecube,
				calm = phasecube,
				warn = phasecube,
				wild = phasecube,
				dawn = phasecube
			}
		elseif getCave() then
			--printDebug("*** WHIMSY.LUA: CAVE COLOR CUBE")
			cubes = 
			{
				day = defaultCubes.cave,
				dusk = defaultCubes.cave,
				night = defaultCubes.cave,
				cave = defaultCubes.cave,
				calm = "images/colour_cubes/ruins_dark_cc.tex",
				warn = "images/colour_cubes/ruins_dim_cc.tex",
				wild = "images/colour_cubes/ruins_light_cc.tex",
				dawn = "images/colour_cubes/ruins_dim_cc.tex"
			}
		else
			--printDebug("*** WHIMSY.LUA: SURFACE COLOR CUBE")
			cubes = 
			{
				day = defaultCubes.day,
				dusk = defaultCubes.dusk,
				night = defaultCubes.night,
				cave = defaultCubes.cave,
				calm = "images/colour_cubes/ruins_dark_cc.tex",
				warn = "images/colour_cubes/ruins_dim_cc.tex",
				wild = "images/colour_cubes/ruins_light_cc.tex",
				dawn = "images/colour_cubes/ruins_dim_cc.tex"
			}
			if not hasUmbrella then
				cubes.day = "images/colour_cubes/mole_vision_off_cc.tex"
			end
		end
		
		inst.components.playervision:SetCustomCCTable(cubes)
	end
end

--Set color cubes for DST/RoG
local function whimsyCommonPeriodic(inst, dt)
	if (not inst) or (inst.prefab ~= "whimsy") then
		return
	end
	if inst.components.playervision then
		setCubes(inst)
	end
end

--printDebug("*** WHIMSY.LUA: DEFINING WHIMSY PERIODIC")
--Repair magic items, lose sanity in rain and during the day, gain it during the night
local function whimsyMasterPeriodic(inst, dt)
	local world = myWorld()

	if (not inst) or (inst.prefab ~= "whimsy") or not world then
		return
	end
	
	--Item repair
	if TUNING.WHIMSY_MAGIC_REGEN_TIME ~= 0 then
		for k,v in pairs (inst.components.inventory.equipslots) do
			if v and v.prefab then
				local itemName = v.prefab
				if (string.find(itemName, "staff") or string.find(itemName, "amulet") 
					or string.find(itemName, "panflute") or string.find(itemName, "armorslurper"))
				then
					if v.components.finiteuses then
						local finite = v.components.finiteuses
						local delta = finite.total * dt / TUNING.WHIMSY_MAGIC_REGEN_TIME
						if finite.current + delta > finite.total then
							finite:SetPercent(1)
						else
							finite:Use(-delta)
						end
					end
					if v.components.fueled then
						local fueled = v.components.fueled
						local delta = fueled.maxfuel * dt / TUNING.WHIMSY_MAGIC_REGEN_TIME
						if fueled.currentfuel + delta > fueled.maxfuel then
							fueled.currentfuel = fueled.maxfuel
						else
							fueled.currentfuel = fueled.currentfuel + delta
						end
					end
				end
			end
		end
		for k,v in pairs (inst.components.inventory.itemslots) do
			if v and v.prefab then
				local itemName = v.prefab
				if (string.find(itemName, "staff") or string.find(itemName, "amulet") 
					or string.find(itemName, "panflute") or string.find(itemName, "armorslurper"))
				then
					if v.components.finiteuses then
						local finite = v.components.finiteuses
						local delta = finite.total * dt / TUNING.WHIMSY_MAGIC_REGEN_TIME
						if finite.current + delta > finite.total then
							finite:SetPercent(1)
						else
							finite:Use(-delta)
						end
					end
					if v.components.fueled then
						local fueled = v.components.fueled
						local delta = fueled.maxfuel * dt / TUNING.WHIMSY_MAGIC_REGEN_TIME
						if fueled.currentfuel + delta > fueled.maxfuel then
							fueled.currentfuel = fueled.maxfuel
						else
							fueled.currentfuel = fueled.currentfuel + delta
						end
					end
				end
			end
		end
	end
	
	--Sanity value multiplier, expressed in multiples of TUNING.DAPPERNESS_MED
	local sanityMult = 0
	
	--Check to see if Whimsy has an umbrella or dark items equipped
	local hasUmbrella = false
	local umbrellaFactor = 1
	local darknessFactor = 1
	local isRaining = getRaining()
	for k,v in pairs (inst.components.inventory.equipslots) do
		if v then
			--We don't base this on water resistance because many items that resist water don't really give shade
			--plus, way too many of them keep your hands free
			local pre = v.prefab
			if pre == "umbrella" or pre == "whimsy_umbrella" or pre == "whimsy_night_umbrella" or pre == "eyebrellahat" then
				hasUmbrella = true
			elseif pre == "whimsy_awful_umbrella" then
				umbrellaFactor = umbrellaFactor - 0.9 --it kinda sucks
				darknessFactor = darknessFactor - 0.9
			elseif pre == "grass_umbrella" then
				umbrellaFactor = umbrellaFactor - 0.5
				darknessFactor = darknessFactor - 0.5
			elseif pre == "nightsword" then --being surrounded by ultimate darkness gives you a degree of sun resistance
				darknessFactor = darknessFactor - 0.25
			elseif pre == "armor_sanity" then
				darknessFactor = darknessFactor - 0.5
			end
		end
	end
	
	--The rain mitigates the effects of sunlight
	if isRaining then
		darknessFactor = darknessFactor - 0.5
	end
	
	--Whimsy can't be less rained-on or sunlight-exposed than zero exposure
	if darknessFactor < 0 then
		darknessFactor = 0
	end
	if umbrellaFactor < 0 then
		umbrellaFactor = 0
	end
	
	local isDark = getDarkness()
	local isDusk = getDusk()
	local isDay = getDay()
	local wetness = getWetness(inst)
	
	--Increase sanity at night, decrease during the day unless you have an umbrella
	if isDark then
		--Whimsy loves the night and gains sanity during it
		sanityMult = sanityMult + TUNING.WHIMSY_NIGHT_SANITTY_GAIN
	elseif isDusk then
		--The dusk isn't as nice but is still beneficial
		sanityMult = sanityMult + (TUNING.WHIMSY_NIGHT_SANITTY_GAIN / 5)
	elseif isDay and (not inst.components.health:IsInvincible()) then
		--Penalize Whimsy for not protecting herself from the sunlight
		if not hasUmbrella then
			sanityMult = sanityMult - (TUNING.WHIMSY_DAY_SANITTY_DRAIN * darknessFactor)
		end
		--Neutralize the sanity gain during the day for Whimsy. This could have been an override on sanity.lua probably, but I can't work out how.
		if TUNING.SANITY_DAY_GAIN then
			sanityMult = sanityMult - (TUNING.SANITY_DAY_GAIN)
		end
	end

	--Whimsy loves the rain but hates getting rained ON. Doesn't matter how hard it's raining.
    if isRaining then
		if hasUmbrella then
			if wetness == 0 then --Whimsy doesn't enjoy the rain if she's wet
				sanityMult = sanityMult + 5
			end
		elseif not inst.components.health:IsInvincible() then
			sanityMult = sanityMult - (10 * umbrellaFactor)
		end
	end
	
	--Whimsy hates being hot (as in temperature, not sex appeal). This only functions in game modes where people can overheat.
	if TUNING.OVERHEAT_TEMP then
		--How much hotter is Whimsy than her crazy threshold? WHIMSY_MAX_CRAZY_TEMP expresses the maximum *gap*
		--So, like, if she starts going crazy at 30 C, and OVERHEAT TEMP is 35 C, WHIMSY_MAX_CRAZY_TEMP is 5 C.
		--Thus, we should get a value of 1 or higher when Whimsy is overheating, which is the MAXIUMUM CRAZY.
		local excessTemp = (inst.components.temperature:GetCurrent() - TUNING.WHIMSY_DISCOMFORT_TEMP) / TUNING.WHIMSY_MAX_CRAZY_TEMP
		if excessTemp > 0 then
			if excessTemp >= 1 then
				sanityMult = sanityMult - TUNING.WHIMSY_MAX_HEAT_DAPPER
			else
				sanityMult = sanityMult - (TUNING.WHIMSY_MAX_HEAT_DAPPER * excessTemp)
			end
			if not inst.isTooHot then
				complainHotFire(inst) --either directly calls the talker function or fires the net event, depending on DST status
				inst.isTooHot = true;
			end;
		else
			inst.isTooHot = false;
		end
	end
	
	--Whimsy hates being wet EVEN MORE than average people.
	if wetness ~= 0 then
		sanityMult = sanityMult - (TUNING.WHIMSY_MAX_WETNESS_DAPPER * wetness + TUNING.WHIMSY_MIN_WETNESS_DAPPER)
	end
	
	--set dapperness based on above modifiers
	inst.components.sanity.dapperness = TUNING.DAPPERNESS_MED * sanityMult
	
	if isDST then
		if isDay ~= wasDay then
			inst.whimsyBrightness:set(isDay)
		end
		wasDay = isDay
		
		--We could make this event-driven, but it would require modifying the other umbrellas via post inits,
		--which introduces possible cross-mod issues
		if hasUmbrella then
			inst.whimsyGlowType:set(1)
		else
			inst.whimsyGlowType:set(0)
		end
	elseif inst.components.playervision then
		if isDay ~= wasDay then
			announceDawnDusk(inst)
		end
		wasDay = isDay
		isGlowing = isDark
	else
		--Make her glow in the dark for Don't Starve, which has no playervision module
		if isDay ~= wasDay then
			announceDawnDusk(inst)
		end
		wasDay = isDay
		if isDark and not isGlowing then
			isGlowing = true
			inst.Light:Enable(true)
		elseif not isDark and isGlowing then
			isGlowing = false
			inst:DoTaskInTime(1, 
				function()
					inst.Light:Enable(false)
				end)
			end
	end
end

--printDebug("*** WHIMSY.LUA: DEFINING COMMON POSTINIT")
local common_postinit = function(inst)
	inst.MiniMapEntity:SetIcon( "whimsy.png" )
	
	inst:AddTag("whimsyUmbrellaBuilder")
	
	inst.getNastyLevel = getNastyLevel
	
	--Whimsy can see in the dark
	wasDay = not isDST and getDay() --Whimsy will complain if she loads into a sunny environment, I hope
	if isDST then
		inst.components.playervision:ForceNightVision(true)
		inst:ListenForEvent("seasontick", OnSeasonTickChangeCubes)
		local seasonObject = {}
		seasonObject.season = myWorld().state.season
		OnSeasonTickChangeCubes(nil, seasonObject)
	elseif inst.components.playervision then
		--Don't Starve Together has a very nice functionality for this
		inst.components.playervision:ForceNightVision(true)
		inst:ListenForEvent("seasontick", OnSeasonTickChangeCubes)
		local seasonObject = {}
		seasonObject.season = myWorld().state.season
		OnSeasonTickChangeCubes(nil, seasonObject)
		inst:ListenForEvent("nightmarephasechanged", function() setCubes(inst) end)
		inst:DoTaskInTime(0, function() setCubes(inst) end)
	else
		--Don't Starve is wonkier
		inst.entity:AddLight()
		inst.Light:Enable(false)
		inst.Light:SetRadius(7)
		inst.Light:SetFalloff(0.3)
		inst.Light:SetIntensity(0.9)
		inst.Light:SetColour(1,0,0)
	end
	
	if isDST then
		inst.whimsyComplainHot = net_event(inst.GUID, "whimsyComplainHotEvent")
		inst.whimsyGlowType = net_float(inst.GUID, "whimsyGlowType", "whimsyGlowTypeDirty")
		inst.whimsyGlowType:set_local(0)
		inst.whimsyGlowType:set_local(1)
		inst.whimsyBrightness = net_bool(inst.GUID, "whimsyBrightness", "whimsyBrightnessDirty")
		inst:ListenForEvent("whimsyGlowTypeDirty", setCubes)
		inst:ListenForEvent("whimsyBrightnessDirty", function() announceDawnDusk(inst) end) --dumb and hacky, but "onphasechanged" didn't work
		inst:ListenForEvent("whimsyComplainHotEvent", function() complainHotTalker(inst) end)
	else
		inst:AddTag("insomniac") --Temporary measure; prevents her from sleeping at night
	end
	
	local refreshTime = 1/10
		inst:DoPeriodicTask(refreshTime, function() whimsyCommonPeriodic(inst, refreshTime) end)
end

--printDebug("*** WHIMSY.LUA: DEFINING MASTER POSTINIT")
local master_postinit = function(inst)

	inst.prefab = "whimsy"
	
	--This is for the bedroll usage.
	--TODO: This is SUPER OVERKILL. Try to make this work with the standard stategraph, or at least auto incorporate its elements.
	--TODO: Try to get this working in DS.
	if isDST then
		inst:SetStateGraph("SGwhimsy")
	end
	
	--doesn't mind the night
	inst.components.sanity.night_drain_mult = 0
	
	--TODO: Save/load functionality?
	isGlowing = false
	wasDay = false
	inst.isTooHot = false
	
	--mitigate ghost penalty
	if TUNING.SANITY_GHOST_PLAYER_DRAIN then
		inst.components.sanity.custom_rate_fn = function (inst)
			return -1 * TUNING.WHIMSY_GHOST_RESISTANCE * TUNING.SANITY_GHOST_PLAYER_DRAIN * inst.components.sanity.ghost_drain_mult
		end
	end
	
	--corsets and scarves and poofy skirts are surprisingly warm
	inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED
	
	--this serves her very badly in the summer (if summer exists). Her umbrella mitigates this but does not eliminate it. The night umbrella does.
	if not TUNING.INSULATION_MED_LARGE then
		TUNING.INSULATION_MED_LARGE = TUNING.INSULATION_MED * 1.5
	end
	inst.components.temperature.inherentsummerinsulation = -TUNING.INSULATION_MED_LARGE
	
	--speech sound and map icon
	inst.soundsname = "willow"

	--Stats
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(120)
	
	--Whimsy isn't the best fighter
	inst.components.combat.damagemultiplier = .75
	--Running in heels is hard
	inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 0.9)
	inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 0.9)
	
	inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 1.0)
	
	--Whimsy has a weak stomach and delicate palate
    inst.components.eater.stale_hunger = 0.25
    inst.components.eater.stale_health = 0.25
    inst.components.eater.spoiled_hunger = 0.125
    inst.components.eater.spoiled_health = 0
	
	--Configurable magic affinity
	inst.components.builder.magic_bonus = TUNING.WHIMSY_MAGIC_AFFINITY
	inst.components.builder.ancient_bonus = TUNING.WHIMSY_ANCIENT_AFFINITY
	
	--Whimsy hates eating raw foods and some other gross things. Some (set in nastyFoods, above) she won't eat unless she's starving (below 1/3 food).
	--Some reduce her sanity more than usual when she eats them while starving.
	if not isDST then
		local canEatDS = function(inst, food)
			--Evaluate nastiness
			if food ~= nil then
				local nastyLevel = inst.getNastyLevel(food)
				if nastyLevel > 0 and inst.components.hunger:GetPercent() > TUNING.HUNGRY_THRESH then
					return false
				end
			end
			return true
		end
		
		local onEatDS = function(inst, food)
			local nastyLevel = inst.getNastyLevel(food)
			if nastyLevel > 0 then
				inst.components.talker:Say(STRINGS.CHARACTERS.WHIMSY.WHIMSY_EAT_GROSS_THING)
				inst.components.sanity:DoDelta(-TUNING.SANITY_TINY * nastyLevel)
			end
		end
		
		inst.components.eater:SetCanEatTestFn(canEatDS)
		inst.components.eater:SetOnEatFn(onEatDS)
	end
	
	if isDST then
		inst:DoTaskInTime(0, function()inst.whimsyBrightness:set(getHasUmbrella(inst)) end)
		inst:DoTaskInTime(0, 
			function()
				if getHasUmbrella(inst) then
					inst.whimsyGlowType:set(1)
				else
					inst.whimsyGlowType:set(0)
				end
			end)
	end
	
	--Periodic check for many things
	local refreshTime = 1/10
	inst:DoPeriodicTask(refreshTime, function() whimsyMasterPeriodic(inst, refreshTime) end)
end

--printDebug("*** WHIMSY.LUA: DEFINING DS FUNCTION")
local whimsyFnDS = function (inst)
	master_postinit(inst)
	common_postinit(inst)
end

if isDST then
	--printDebug("*** WHIMSY.LUA: RETURNING DST VERSION")
	return MakePlayerCharacter("whimsy", prefabs, assets, common_postinit, master_postinit, start_inv)
else
	--printDebug("*** WHIMSY.LUA: RETURNING DS VERSION")
	return MakePlayerCharacter("whimsy", prefabs, assets, whimsyFnDS, start_inv)
end

--printDebug("*** WHIMSY: EXITING WHIMSY.LUA")