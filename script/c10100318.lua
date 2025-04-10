if not bpev then
  Duel.LoadScript("util-bpev.lua")
end
--Nuva Symbol of Burning Courage
local s,id=GetID()
function s.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --Search EP or Tahu
  local e1=bpev.nuva_symbol_search(c,10100001,aux.Stringid(id,2))
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCountLimit(1,id)
  c:RegisterEffect(e1)
  --Block effects
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetRange(LOCATION_SZONE)
  e2:SetTargetRange(0,1)
  e2:SetCode(EFFECT_CANNOT_ACTIVATE)
  e2:SetCondition(s.condition2)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --Leave field
  local e3=bpev.nuva_symbol_punish(c,s.operation3)
  e3:SetDescription(aux.Stringid(id,1))
  c:RegisterEffect(e3)
end
s.listed_names={10100001}
s.listed_series={0xb02,0x3b02,0xb0b}
function s.condition2(e)
  local c=Duel.GetBattleMonster(e:GetHandlerPlayer())
  return c and c:IsFaceup() and c:IsSetCard(0x3b02)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(id,3))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SKIP_BP)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
  e1:SetTargetRange(1,0)
  if Duel.GetTurnPlayer()==tp then
    e1:SetLabel(Duel.GetTurnCount())
    e1:SetCondition(s.condition3_1)
    e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
  else
    e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
  end
  Duel.RegisterEffect(e1,tp)
end
function s.condition3_1(e)
  return Duel.GetTurnCount()~=e:GetLabel()
end