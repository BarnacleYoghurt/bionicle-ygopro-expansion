Duel.LoadScript("util-bmol.lua")
--Lerahk, Poison Rahkshi
local s,id=GetID()
function s.initial_effect(c)
    --Fusion Material
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,10100436,s.filter0)
    --ATK
    local e1a=Effect.CreateEffect(c)
    e1a:SetType(EFFECT_TYPE_SINGLE)
    e1a:SetCode(EFFECT_MATERIAL_CHECK)
    e1a:SetValue(s.value1)
    c:RegisterEffect(e1a)
    local e1b=Effect.CreateEffect(c)
    e1b:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1b:SetCondition(s.condition1)
    e1b:SetOperation(s.operation1)
    e1b:SetLabelObject(e1a)
    c:RegisterEffect(e1b)
end

