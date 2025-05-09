--Nuva Emergence
local s,id=GetID()
function s.initial_effect(c)
    --Fusion Summon
    local e1=Fusion.CreateSummonEff{handler=c,fusfilter=aux.FilterBoolFunction(Card.IsSetCard,0x3b02),matfilter=Fusion.InHandMat(Card.IsAbleToDeck),
                                    extrafil=s.extrafil,extraop=s.extraop,extratg=s.extratg}
    e1:SetCountLimit(1,id)
    c:RegisterEffect(e1)
    --Add Spell/Trap
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_MAIN_END)
    e2:SetCondition(function(e) return aux.exccon(e) and Duel.IsMainPhase() end)
    e2:SetCost(Cost.SelfBanish)
    e2:SetTarget(s.target2)
    e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,1})
    c:RegisterEffect(e2)
end
s.listed_names={id}
s.listed_series={0xb02,0x3b02,0xb0c}
function s.checkmat(tp,sg,fc)
    local dl=math.min(Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0),1)
    return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=dl
end
function s.extrafil(e,tp,mg)
    local eg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Fusion.IsMonsterFilter(Card.IsAbleToDeck)),tp,LOCATION_GRAVE,0,nil)
        +  Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup,Card.IsAbleToDeck),tp,LOCATION_REMOVED,0,nil)
        +  Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_DECK,0,nil)
    return eg,s.checkmat
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
    Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_DECK)
end
function s.extraop(e,tc,tp,sg)
    local rg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
    if #rg>0 then
        Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
        sg:Sub(rg)
    end
    Fusion.ShuffleMaterial(e,tc,tp,sg)
end
function s.filter2(c)
    return c:IsSetCard(0xb0c) and c:IsSpellTrap() and not c:IsCode(id) and c:IsAbleToHand()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
        local og=Duel.GetOperatedGroup()
        if og:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>0 then
            Duel.ConfirmCards(1-tp,g)
            Duel.BreakEffect()
            Duel.ShuffleHand(tp)
            Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
        end
    end
end