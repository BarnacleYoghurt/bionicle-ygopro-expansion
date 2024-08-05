BCOR={}
bcor=BCOR
--Rahi
function BCOR.rahi_insect_spsum(baseC,pstg,psop)
    local function filter(c)
        return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0xb06) and c:IsMonster() and c:IsAbleToRemoveAsCost()
    end
    local function cost(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then return Duel.IsExistingMatchingCard(filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
        local g=Duel.SelectMatchingCard(tp,filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
        Duel.Remove(g,POS_FACEUP,REASON_COST)
    end
    local function target(e,tp,eg,ep,ev,re,r,rp,chk)
        local c=e:GetHandler()
        if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
        if pstg then pstg(e,tp,eg,ep,ev,re,r,rp,chk) end -- target function for optional post-summon actions
    end
    local function operation(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
            if psop then psop(e,tp,eg,ep,ev,re,r,rp) end -- operation for optional post-summon actions
        end
    end

    local e=Effect.CreateEffect(baseC)
    e:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e:SetType(EFFECT_TYPE_QUICK_O)
    e:SetRange(LOCATION_HAND)
    e:SetCode(EVENT_FREE_CHAIN)
    e:SetCost(cost)
    e:SetTarget(target)
    e:SetOperation(operation)
    return e
end