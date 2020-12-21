--DDD超死偉王ホワイテスト・ヘル・アーマゲドン
function c72402069.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf),aux.NonTuner(Card.IsSetCard,0x10af),1)
	--destroy and damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72402069,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c72402069.descon)
	e1:SetTarget(c72402069.destg)
	e1:SetOperation(c72402069.desop)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72402069,1))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c72402069.distg)
	e3:SetOperation(c72402069.disop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(72402069,3))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c72402069.pencon)
	e6:SetTarget(c72402069.pentg)
	e6:SetOperation(c72402069.penop)
	c:RegisterEffect(e6)
end
function c72402069.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end
function c72402069.desfilter1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x10af)
		and Duel.IsExistingMatchingCard(c72402069.desfilter2,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c72402069.desfilter2(c,atk)
	return c:IsFaceup() and c:IsDefenseBelow(atk)
end
function c72402069.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c72402069.desfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c72402069.desfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c72402069.desfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local g=Duel.GetMatchingGroup(c72402069.desfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
end
function c72402069.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c72402069.desfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		if g:GetCount()==0 then return end
		local oc=Duel.Destroy(g,REASON_EFFECT)
		if oc>0 then Duel.Damage(1-tp,oc*1000,REASON_EFFECT) end
	end
end
function c72402069.pfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,c)
end
function c72402069.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsContains(e:GetHandler())
		and Duel.IsExistingMatchingCard(c72402069.pfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,pc)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g-1,0,0)
end
function c72402069.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(alias,2))
	local pg=Duel.SelectMatchingCard(1-tp,c72402069.pfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	local pc=pg:GetFirst()
	if not pc then return end
	Duel.HintSelection(pg)
	local c=e:GetHandler()
	local flag=(id+c:GetFieldID()+e:GetFieldID())*2
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,pc)
	g:ForEach(function(tc)
		tc:RegisterFlagEffect(flag,RESET_EVENT+RESETS_STANDARD,0,1)
		--negate
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetLabel(flag)
		e1:SetCondition(c72402069.discon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetLabelObject(e1)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		--reset
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(45014450,2))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		e3:SetLabel(flag)
		e3:SetLabelObject(e2)
		e3:SetRange(LOCATION_MZONE)
		e3:SetOperation(c72402069.resetop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e4:SetLabelObject(e3)
		Duel.RegisterEffect(e4,tp)
		e3:SetLabelObject(e4)
	end)
end
function c72402069.discon(e)
	if e:GetHandler():GetFlagEffect(e:GetLabel())>0 then return true
	else e:Reset() return false end
end
function c72402069.resetFilter(c,flag)
	return c:GetFlagEffect(flag)>0
end
function c72402069.resetop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c72402069.resetFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())
	g:ForEach(function(tc)
		tc:ResetFlagEffect(e:GetLabel())
	end)
	e:Reset()
	e:GetLabelObject():Reset()
end
function c72402069.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c72402069.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c72402069.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
