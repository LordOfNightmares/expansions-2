--神の通告
function c40605147.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c40605147.condition)
	e1:SetCost(c40605147.cost)
	e1:SetTarget(c40605147.target)
	e1:SetOperation(c40605147.activate)
	c:RegisterEffect(e1)
	--Activate(summon)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCondition(c40605147.condition1)
	e2:SetCost(c40605147.cost)
	e2:SetTarget(c40605147.target1)
	e2:SetOperation(c40605147.activate1)
	c:RegisterEffect(e2)
end
function c40605147.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c40605147.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c40605147.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c40605147.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		local c=e:GetHandler()
		--Half
		local half=Effect.CreateEffect(c)
		half:SetType(EFFECT_TYPE_FIELD)
		half:SetCode(EFFECT_CHANGE_DAMAGE)
		half:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		half:SetTargetRange(0,1)
		half:SetValue(function(e,re,val,r,rp,rc) return math.floor(val/2) end)
		if Duel.GetTurnPlayer()==tp then
			half:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			half:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		c:RegisterEffect(half)
	end

end
function c40605147.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c40605147.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c40605147.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	local c=e:GetHandler()
	--Half
	local half=Effect.CreateEffect(c)
	half:SetType(EFFECT_TYPE_FIELD)
	half:SetCode(EFFECT_CHANGE_DAMAGE)
	half:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	half:SetTargetRange(0,1)
	half:SetValue(function(e,re,val,r,rp,rc) return math.floor(val/2) end)
	if Duel.GetTurnPlayer()==tp then
		half:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		half:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	end
	c:RegisterEffect(half)
end
