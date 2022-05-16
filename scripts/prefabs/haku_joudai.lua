local assets =
{
    Asset("ANIM", "anim/spear.zip"),
    Asset("ANIM", "anim/swap_spear.zip"),
}

local function disableDmg(inst)
    inst._activateDmg = false
end
local function enambleDmg(inst)
    inst._activateDmg = true
    
end

local function ChangeDamage(inst)
    if inst._player ~= nil then -- tirar o player quando tirar do inventario 
        local viewer = inst._player
        if inst._activateDmg then
            if viewer.components.health ~= nil then
                viewer.components.health:DoDelta(-3)
                viewer:DoTaskInTime(4.8,function() viewer.components.health:DoDelta(3) end)
                -- disableDmg(inst)
                -- aadicionaar no viewer um listener que vai daar += .3 da dano e vai criaaar um aauto destroyer pra ele e essa funça ose repete a cada 5 segundos consumindo durabilidaade
            end
        end
    end
end

local function getstatus(inst, viewer)
    if viewer ~= nil then
        inst._player = viewer

        if inst._activateDmg then
            disableDmg(inst)
        else
            enambleDmg(inst)
            ChangeDamage(inst) --teste
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
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("inventoryitem")
    --inst.components.inventoryitem.imagename = "wand"
    --inst.components.inventoryitem.atlasname = "images/inventoryimages/wand.xml"

    MakeHauntableLaunch(inst)
    
    inst._activateDmg = false
    inst._player = nil
    inst._changeDamage = inst:DoPeriodicTask(5, ChangeDamage)

    inst:ListenForEvent("ondropped",disableDmg)
    inst:ListenForEvent("onactiveitem",disableDmg)
    inst:ListenForEvent("onputininventory",disableDmg)
    inst:ListenForEvent("onputininventory",disableDmg)

    return inst
end


return Prefab("haku_joudai", fn, assets)
