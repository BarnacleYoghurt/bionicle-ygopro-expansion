Duel.LoadScript("util-bmol.lua")
--Matoran Shipwright Marka
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon self
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Special Summon from Deck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(s.condition2)
    e2:SetCost(s.cost2)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
    aux.GlobalCheck(s,function()
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SUMMON_SUCCESS)
        ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        ge1:SetOperation(aux.sumreg)
        ge1:SetLabel({id,1})
        Duel.RegisterEffect(ge1,0)
        local ge2=ge1:Clone()
        ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge2:SetLabel(id)
        Duel.RegisterEffect(ge2,0)
    end)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsControler,1,nil,1-tp)
       and not Duel.IsExistingMatchingCard(aux.NOT(Card.IsAttribute),tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_WATER)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function s.filter2a(c)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable()
end
function s.filter2b(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(SET_MATORAN)
       and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(id)>0
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2a,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,s.filter2a,1,1,REASON_COST|REASON_DISCARD)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
           and Duel.IsExistingMatchingCard(s.filter2b,tp,LOCATION_DECK,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter2b,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
        aux.DelayedOperation(g,PHASE_END,id,e,tp,
            function(ag) Duel.SendtoHand(ag,nil,REASON_EFFECT) end,
			nil,0,0,aux.Stringid(id,2)
		)
    end
end