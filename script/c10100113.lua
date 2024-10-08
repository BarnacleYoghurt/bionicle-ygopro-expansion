--Tarakava-Nui, Lizard King Rahi
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xb06),1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--PUNCH THINGS SO HARD THEY GO BACK TO THE DECK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	--ATK loss
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(s.condition2)
	e2:SetValue(-1000)
	c:RegisterEffect(e2)
	--Protection
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetCondition(function (e) return e:GetHandler():IsContinuousSpell() end)
	e3:SetTarget(s.target3)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local max=math.floor(e:GetHandler():GetAttack()/1000)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and max>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,math.min(2,max),nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e)
	if #g>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=#g*1000
		if c:IsAttackAbove(atk) and c:UpdateAttack(-atk)==-atk then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
function s.condition2(e)
	return Duel.IsTurnPlayer(e:GetHandlerPlayer()) and Duel.IsMainPhase()
end
function s.target3(e,c)
	return c:IsFaceup() and c:IsSetCard(0xb06)
end
