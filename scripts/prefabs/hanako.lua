local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

local prefabs = {
	'hanako_knife',
}

-- Your character's stats
TUNING.HANAKO_HEALTH = 150
TUNING.HANAKO_HUNGER = 150
TUNING.HANAKO_SANITY = 120

-- Custom starting inventory
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.HANAKO = {
	"hanako_knife",
}


local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.HANAKO
end
local prefabs = FlattenTree(start_inv, true)

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when not a ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "hanako_speed_mod", 1)
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "hanako_speed_mod")
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "hanako.tex" )
end


local function CustomSanityFn(inst, dt)
	
	local HungerPorcentagem = inst.components.hunger:GetPercent() * 100
	if HungerPorcentagem > 70  then
		return 0
	elseif HungerPorcentagem < 71 and HungerPorcentagem > 33 then
		return -0.1
	elseif HungerPorcentagem < 34 then
		return -0.3
	end
	return 0
end

local function ChangeDamage(inst)
	local sanityPorcentagem = inst.components.sanity:GetRealPercent() * 100
	if sanityPorcentagem > 70  then
		inst.components.combat.damagemultiplier = 1.6
	elseif sanityPorcentagem < 71 and sanityPorcentagem > 33 then
		inst.components.combat.damagemultiplier = 1.3
	elseif sanityPorcentagem < 34 then
		inst.components.combat.damagemultiplier = 1
	end
end

local function OnKillerOther(inst, data)
	--inst.components.hunger:DoDelta(-10)
	local victim = data.victim
	if victim:HasTag("monster") or victim:HasTag("hostile")then
		inst.components.sanity:DoDelta(4)
		inst.components.health:DoDelta(3)
	else
		if victim:HasTag("rabbit") or 
		victim:HasTag("bee") or 
		victim:HasTag("butterfly") or 
		victim:HasTag("bird") or 
		victim:HasTag("critter")then --butterfly bird critter hostile
			inst.components.sanity:DoDelta(-7)
			inst.components.health:DoDelta(-2)
		else
			inst.components.sanity:DoDelta(-6)
		end 
	end

end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- Set starting inventory
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	
	-- choose which sounds this character will play
	inst.soundsname = "willow"
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.HANAKO_HEALTH)
	inst.components.hunger:SetMax(TUNING.HANAKO_HUNGER)
	inst.components.sanity:SetMax(TUNING.HANAKO_SANITY)
	
	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 0.9  * TUNING.WILSON_HUNGER_RATE

	inst._changeDamage = inst:DoPeriodicTask(1, ChangeDamage)

	inst.components.sanity.custom_rate_fn = CustomSanityFn -- diminuir sanidade
	inst.components.sanity:AddSanityAuraImmunity("ghost")
    inst.components.sanity:SetPlayerGhostImmunity(true)

	inst:ListenForEvent("killed", OnKillerOther)
	
	inst:AddTag("hanako")

	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("hanako", prefabs, assets, common_postinit, master_postinit, prefabs)
