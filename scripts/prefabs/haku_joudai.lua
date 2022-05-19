local assets =
{
    Asset("ANIM", "anim/spear.zip"),
    Asset("ANIM", "anim/swap_spear.zip"),
}



local function onAttackHaku(inst,data)
    local r = math.random(1,100)
    local baseDamage = 10 
    if r >= 60 then
        inst.components.sanity:DoDelta(1)
    end
    if r >= 80 then
        inst.components.health:DoDelta(1)
    end
    if r >= 90 then
        baseDamage = 20
    end

    if data.target ~= nil and data.target.components ~= nil and data.target.components.health ~= nil then
        local enemy = data.target
        local damage = inst.components.combat.damagemultiplier or 1
        enemy.components.health:DoDelta(-(damage * baseDamage))
    end
end


local function disableDmg(inst)
    inst.activateDmg = false
    if inst.components.inventoryitem.owner then
        local playerbuff = inst.components.inventoryitem.owner
        if playerbuff.components ~= nil and playerbuff.components.health then

            playerbuff:RemoveEventCallback("onhitother", onAttackHaku)
            playerbuff.components.health:DoDelta(20)
            
            if inst.HakuTimer ~= nil then
                inst.HakuTimer:Cancel()
                inst.HakuTimer = nil
            end

        end
    end
end
local function enambleDmg(inst)
    inst.activateDmg = true
    if inst.components.inventoryitem.owner then
        local playerbuff = inst.components.inventoryitem.owner
        if playerbuff.components ~= nil and playerbuff.components.health then
            playerbuff:ListenForEvent("onhitother", onAttackHaku)

            if inst.HakuTimer == nil then
                inst.HakuTimer = inst:DoPeriodicTask(5, function(inst)
                   inst.components.finiteuses:Use()
                end)
            end
        end
    end
end



local function getstatus(inst, viewer)
    if viewer ~= nil then
        if inst.activateDmg then 
            disableDmg(inst)
        else
            enambleDmg(inst)
        end
    end
end






local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("spear")
    inst.AnimState:SetBuild("swap_spear")
    inst.AnimState:PlayAnimation("idle")


    --weapon (from weapon component) added to pristine state for optimization

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(300)
    inst.components.finiteuses:SetUses(300)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("inventoryitem")
    --inst.components.inventoryitem.imagename = "wand"
    --inst.components.inventoryitem.atlasname = "images/inventoryimages/wand.xml"

    MakeHauntableLaunch(inst)
    
    inst.activateDmg = false

    inst:ListenForEvent("ondropped",disableDmg)
    inst:ListenForEvent("onactiveitem",disableDmg)
    inst:ListenForEvent("onputininventory",disableDmg)
    inst:ListenForEvent("onputininventory",disableDmg)
    inst:ListenForEvent("itemlose",disableDmg)

    return inst
end


return Prefab("haku_joudai", fn, assets)
