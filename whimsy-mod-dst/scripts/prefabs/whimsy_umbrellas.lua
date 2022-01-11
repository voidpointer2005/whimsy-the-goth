--require("debugprint")
local function printDebug(msg)
	--print(msg)
end

--printDebug("*** WHIMSY: ENTERING WHIMSY_UMBRELLAS.LUA")

local isDST = TheSim:GetGameID() == "DST"
local hasRoG = isDST

if not isDST then
	if TUNING.AUTUMN_LENGTH then --TODO: Find a less awful way to do this
		hasRoG = true
	else
		hasRoG = false
	end
end

--TODO: Turn normal brella into it if missing?
--TODO: They all look the same for some reason. Fix this.

--printDebug("*** WHIMSY_UMBRELLAS.LUA: DEFINING ASSETS")
local assets=
{
    Asset("ANIM", "anim/umbrella.zip"),
    Asset("ANIM", "anim/swap_umbrella.zip"),
	Asset("ANIM", "anim/whimsy_umbrella/whimsy_umbrella.zip"),
	Asset("ANIM", "anim/whimsy_umbrella/swap_whimsy_umbrella.zip"),
	Asset("ATLAS", "images/inventoryimages/whimsy_umbrella.xml"),
	Asset("ANIM", "anim/whimsy_awful_umbrella/whimsy_awful_umbrella.zip"),
	Asset("ANIM", "anim/whimsy_awful_umbrella/swap_whimsy_awful_umbrella.zip"),
	Asset("ATLAS", "images/inventoryimages/whimsy_awful_umbrella.xml"),
	Asset("ANIM", "anim/whimsy_night_umbrella/whimsy_night_umbrella.zip"),
	Asset("ANIM", "anim/whimsy_night_umbrella/swap_whimsy_night_umbrella.zip"),
	Asset("ATLAS", "images/inventoryimages/whimsy_night_umbrella.xml"),
}

--printDebug("*** WHIMSY_UMBRELLAS.LUA: DEFINING LOCALS")
local UpdateSound
local onequip
local onunequip

local hasWaterproofer = isDST or hasRoG
local hasInsulator = hasWaterproofer

local dapperfnWhimsy = function(inst,owner)
	--printDebug("*** WHIMSY_UMBRELLAS.LUA: in dapperfn")
	if owner.prefab == "whimsy" then
		return owner.whimsyDapperness or 0
	else
		return owner.otherDapperness or 0
	end
	--printDebug("*** WHIMSY_UMBRELLAS.LUA: finished dapperfn")
end

if isDST then
	--printDebug("*** WHIMSY_UMBRELLAS.LUA: DEFINING DST LOCALS")
	--UpdateSound = nil
	
	onequip = function (inst, owner)
		--printDebug("*** WHIMSY_UMBRELLAS.LUA: in onequip DST")
		owner.AnimState:OverrideSymbol("swap_object", "swap_whimsy_umbrella", "swap_umbrella")
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
		
		owner.DynamicShadow:SetSize(2.2, 1.4)
		--printDebug("*** WHIMSY_UMBRELLAS.LUA: finished onequip")
	end
	
	onunequip = function (inst, owner)
		--printDebug("*** WHIMSY_UMBRELLAS.LUA: in onunequip DST")
		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")

		owner.DynamicShadow:SetSize(1.3, 0.6)
		--printDebug("*** WHIMSY_UMBRELLAS.LUA: finished onunequip")
	end
else
	UpdateSound = function (inst)
		--printDebug("*** WHIMSY_UMBRELLAS.LUA: in UpdateSound")
		local soundShouldPlay = GetSeasonManager():IsRaining() and inst.components.equippable:IsEquipped()
		if soundShouldPlay ~= inst.SoundEmitter:PlayingSound("umbrellarainsound") then
			if soundShouldPlay then
				inst.SoundEmitter:PlaySound("dontstarve/rain/rain_on_umbrella", "umbrellarainsound") 
			else
				inst.SoundEmitter:KillSound("umbrellarainsound")
			end
		end
		--printDebug("*** WHIMSY_UMBRELLAS.LUA: finished UpdateSound")
	end
	
	onequip = function (inst, owner)
		--printDebug("*** WHIMSY_UMBRELLAS.LUA: in onequip DS")
		owner.AnimState:OverrideSymbol("swap_object", "swap_umbrella", "swap_umbrella")
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
		UpdateSound(inst)
		--printDebug("*** WHIMSY_UMBRELLAS.LUA: finished onequip")
	end

	onunequip = function (inst, owner) 
		--printDebug("*** WHIMSY_UMBRELLAS.LUA: in onunequip DS")
		owner.AnimState:Hide("ARM_carry") 
		owner.AnimState:Show("ARM_normal") 
		UpdateSound(inst)
		--printDebug("*** WHIMSY_UMBRELLAS.LUA: finished onunequip")
	end
end

local function onfinished(inst)
	--printDebug("*** WHIMSY_UMBRELLAS.LUA: in onfinished")
	inst:Remove()
	--printDebug("*** WHIMSY_UMBRELLAS.LUA: finished onfinished")
end
--
local function common_fn(name, atlas, waterproofness, damage, insulation)
	--printDebug("*** WHIMSY_UMBRELLAS.LUA: in common_fn")
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	
	if isDST then
		inst.entity:AddNetwork()
	else
		inst.entity:AddSoundEmitter()
		
		inst:AddComponent("dapperness")
		inst.components.dapperness.mitigates_rain = true
		
		inst:ListenForEvent("rainstop", function() UpdateSound(inst) end, GetWorld()) 
		inst:ListenForEvent("rainstart", function() UpdateSound(inst) end, GetWorld())
	end
	
	MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("umbrella")
    inst.AnimState:SetBuild(name)
	inst.AnimState:PlayAnimation("idle")
	
    inst:AddTag("umbrella")
	
	--waterproofer (from waterproofer component) added to pristine state for optimization
	if hasWaterproofer then
		inst:AddTag("waterproofer")
	end
	
	if isDST then
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
	end
	
	inst:AddComponent("weapon")
	inst:AddTag("sharp")
	inst.components.weapon:SetDamage(damage)
	
	if hasWaterproofer then
		inst:AddComponent("waterproofer")
	end
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = atlas
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip( onequip )
	inst.components.equippable:SetOnUnequip( onunequip )
	
	if isDST then
		inst.components.equippable.dapperfn = dapperfnWhimsy
	else
		inst.components.dapperness.dapperfn = dapperfnWhimsy
	end
	
	if hasInsulator then
		inst:AddComponent("insulator")
		inst.components.insulator:SetSummer()
		inst.components.insulator:SetInsulation(insulation)
	end
	if isDST then
		MakeHauntableLaunch(inst)
	end
--	--printDebug("*** WHIMSY_UMBRELLAS.LUA: finished commonfn")
    return inst
end

local function onfinished_night(inst)
	local inv = inst.components.inventoryitem.owner.components.inventory
	local slot = inst.components.inventoryitem:GetSlotNum()
	inst:Remove()
	inv:GiveItem( SpawnPrefab("whimsy_umbrella"), slot, nil, true )
end

local function onattack_night(inst, owner, target)
    if owner.components.health and owner.components.health:GetPercent() < 1 and not target:HasTag("wall") then
        owner.components.health:DoDelta(TUNING.BATBAT_DRAIN,false)
		if owner.prefab ~= "whimsy" then
			owner.components.sanity:DoDelta(-TUNING.BATBAT_DRAIN * 0.5)
		end
    end
end

local function whimsy_awful_umbrella(Sim)
	local inst = common_fn("whimsy_awful_umbrella", "images/inventoryimages/whimsy_awful_umbrella.xml", 
		TUNING.WATERPROOFNESS_SMALL, TUNING.UMBRELLA_DAMAGE * 0.8, TUNING.INSULATION_SMALL)
	--this is a terrible item
	
	if isDST then
		if not TheWorld.ismastersim then
			return inst
		end
	end
	
	inst.whimsyDapperness = 0;
	inst.otherDapperness = 0;
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_TWO_DAY)
	inst.components.perishable:StartPerishing()
    
    return inst
end

local function whimsy_umbrella(Sim)
	--Completely immune to rain, but GOD HELP YOU if you lose it.
	local inst = common_fn("whimsy_umbrella", "images/inventoryimages/whimsy_umbrella.xml", 
		TUNING.WATERPROOFNESS_ABSOLUTE, TUNING.UMBRELLA_DAMAGE * 1.5, TUNING.INSULATION_MED)
	
	if isDST then
		inst:AddComponent("specialumbrella")
		if not TheWorld.ismastersim then
			return inst
		end
	else
		inst:AddTag("irreplaceable")
	end
	
	--Other people don't like Whimsy's super spooky umbrella
	inst.whimsyDapperness = 0;
	inst.otherDapperness = TUNING.CRAZINESS_SMALL;
	
    return inst
end

local function whimsy_night_umbrella(Sim)
	local inst = common_fn("whimsy_night_umbrella", "images/inventoryimages/whimsy_night_umbrella.xml", 
		TUNING.WATERPROOFNESS_ABSOLUTE, TUNING.NIGHTSWORD_DAMAGE, TUNING.INSULATION_MED_LARGE)

	if isDST then
		inst:AddComponent("specialumbrella")
		if not TheWorld.ismastersim then
			return inst
		end
	else
		inst:AddTag("irreplaceable")
	end
	
	inst.components.weapon:SetOnAttack(onattack_night);
	
	--Other people don't like Whimsy's super spooky umbrella
	inst.whimsyDapperness = TUNING.DAPPERNESS_SMALL;
	inst.otherDapperness = TUNING.CRAZINESS_MED;
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.NIGHTSWORD_USES)
	inst.components.finiteuses:SetUses(TUNING.NIGHTSWORD_USES)
	inst.components.finiteuses:SetOnFinished(onfinished_night)
    
    return inst
end



return 	Prefab( "common/inventory/whimsy_umbrella", whimsy_umbrella, assets),
		Prefab( "common/inventory/whimsy_night_umbrella", whimsy_night_umbrella, assets),
		Prefab( "common/inventory/whimsy_awful_umbrella", whimsy_awful_umbrella, assets)

--printDebug("*** WHIMSY: EXITING WHIMSY_UMBRELLAS.LUA")