--S－Force プロフェッサー・Ϝ

--Scripted by mallu11
function c101103012.initial_effect(c)
	--position change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103012,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101103012)
	e1:SetTarget(c101103012.postg)
	e1:SetOperation(c101103012.posop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--position change limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c101103012.chtg)
	c:RegisterEffect(e3)
end
function c101103012.posfilter(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function c101103012.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101103012.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101103012.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c101103012.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c101103012.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c101103012.chfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x259) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c101103012.chtg(e,c)
	local cg=c:GetColumnGroup()
	return cg:IsExists(c101103012.chfilter,1,nil,e:GetHandlerPlayer())
end
