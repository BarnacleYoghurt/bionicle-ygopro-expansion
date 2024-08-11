--Lava Rat, Blazing Rahi
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LVCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.condition1)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetCondition(s.condition2)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
function s.filter1(c)
    return c:IsFaceup() and c:IsRace(RACE_BEAST|RACE_WINGEDBEAST) and c:IsSetCard(0xb06)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,c)
        g:ForEach(Card.UpdateLevel,-1)
    end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
    local a,d=Duel.GetBattleMonster(tp)
    return a and d and a:IsSetCard(0xb06) and a:IsFaceup()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local _,d=Duel.GetBattleMonster(tp)
    if chk==0 then return d end
    e:SetLabelObject(d)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:IsRelateToBattle() and tc:IsControler(1-tp) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
