-- Healer helper
local PERIOD=500
local ORB_CD=10
local ETALON_POWER=1600
local MAX_SCORE=1000
local TEST_DURATION=60000
local SCORE={
	--Abilitys
	total_healed=1.3,	--Points for each (burst/tick)*healing power
	recharge=1,	--Points for each recharge ability/tick
	--Buffs
	courage=52,	--Points for 100% uptime (major+minor/4)
	resolve=40,	--Points for 100% uptime (major+minor/4)
	berserk=40,
	class_buff=40,	--Points for 100% uptime of class minor buffs
	slayer=180,	--Points for 100% uptime (major+minor/4)
	powerful_assault=40,
	--Debuffs
	lifesteal=52,
	vulnerability=52,
	cowardice=32,	--Points for 100% uptime (major+minor/4)
	weakening=40,
	brittle=140,	--Points for 100% uptime (minor/4)
	--DPS
	dps=10,	--Points for each 1000 dps
}
local healing_done_sets={
	["Draugr's Rest"]={items=4,bonus=4},
	["Покой Драугра"]={items=4,bonus=4},
	["Healing Mage"]={items=4,bonus=4},
	["Маг-Целитель"]={items=4,bonus=4},
	["Inventor's Guard"]={items=4,bonus=4},
	["Защита Изобретателя"]={items=4,bonus=4},
	["Jorvuld's Guidance"]={items=4,bonus=4},
	["Напутствие Йорвульда"]={items=4,bonus=4},
	["Naga Shaman"]={items=3,bonus=2},
	["Нага-шаман"]={items=3,bonus=2},
	["Sanctuary"]={items=5,bonus=14},
	["Святилище"]={items=5,bonus=14},
	["Earthgore"]={items=1,bonus=4},
	["Кровь Земли"]={items=1,bonus=4},
	["Sentinel of Rkugamz"]={items=1,bonus=4},
	["Страж Ркугамза"]={items=1,bonus=4},
	["The Troll King"]={items=1,bonus=4},
	["Король Троллей"]={items=1,bonus=4},
	["Symphony of Blades"]={items=1,bonus=4},
	["Симфония Клинков"]={items=1,bonus=4},
	}
local crit_forces={
	["Major Force"]=20,["Великая сила"]=20,
	["Minor Force"]=10,["Малая сила"]=10,
	}
local healing_forces={
	["Major Mending"]=16,["Великое исцеление"]=16,
	["Minor Mending"]=8,["Малое исцеление"]=8,
	}
local buff_forces={
	["Minor Courage"]=true,["Малая храбрость"]=true,["kleinerer Mut"]=true,["Courage mineur"]=true,[147417]=true,
	["Major Courage"]=true,["Великая храбрость"]=true,
	["Major Resolve"]=true,["Великая решимость"]=true,
	["Minor Resolve"]=true,["Малая решимость"]=true,
	["Minor Berserk"]=true,["Малая ярость"]=true,
	["Worm's Raiment"]=true,["Одеяния Червя"]=true,
	["Major Slayer"]=true,["Великая жажда убийств"]=true,["größerer Schlächter"]=true,["Tueur majeur"]=true,[93109]=true,
	["Powerful Assault"]=true,["Мощный натиск"]=true,["kraftvoller Ansturm"]=true,["Assaut puissant"]=true,[61771]=true,
	}
local class_forces={
	["Minor Prophecy"]=1.5,["Малое предвидение"]=1.5,
	["Minor Sorcery"]=1,["Малое колдовство"]=1,
	["Minor Savagery"]=1,["Малая свирепость"]=1,
	["Minor Brutality"]=1.5,["Великая жестокость"]=1.5,
	["Minor Toughness"]=1.5,["Малая твердость"]=1.5,
	["Minor Evasion"]=1,["Малое уклонение"]=1,["kleinere Evasion"]=1,["Évitement mineur"]=1,[61715]=1
	}
local player_buffs,target_buffs={},{
--	["Minor Magickasteal"]=true,["Малое похищение магии"]=true,
--	["Minor Breach"]=true,["Малый прорыв"]=true,
	["Minor Lifesteal"]=true,["Малое похищение жизни"]=true,
	["Minor Vulnerability"]=true,["Малая уязвимость"]=true,
--	["Healing Bane"]=true,["Исцеляющее проклятие"]=true,
	["Minor Cowardice"]=true,["Малая трусость"]=true,
	["Major Cowardice"]=true,["Великая трусость"]=true,["größere Feigheit"]=true,["Lâcheté majeure"]=true,[147643]=true,
	["Weakening"]=true,["Слабость"]=true,
--	["Off-Balance"]=true,["Off Balance"]=true,["Потеря равновесия"]=true,
--	[154783]=true,--Stone Talker's Prayer/ Молитва Говорящего с Камнями
	["Minor Brittle"]=true,["Малая хрупкость"]=true,["kleinere Brüchigkeit"]=true,["Friabilité mineure"]=true,[145975]=true,
	}
--	This commands are used to receive exact buff names
--	/script local i=0 for n,data in pairs(BUI.Stats.Current[BUI.ReportN].TargetBuffs) do for name in pairs(data) do d(i..". "..name) i=i+1 if i==2 then StartChatInput(name) end end end
--	/script local i=0 for n,data in pairs(BUI.Stats.Current[BUI.ReportN].PlayerBuffs) do d(i..". "..tostring(n)) i=i+1 if i==2 then StartChatInput(n) end end
BUI:JoinTables(player_buffs,crit_forces)
BUI:JoinTables(player_buffs,healing_forces)
BUI:JoinTables(player_buffs,buff_forces)
BUI:JoinTables(player_buffs,class_forces)
local TestInProgress=false
local PlayerBuffs,PlayerStats,TargetBuffs={},{},{}
local StartTime,EndTime=0,0
local BonusMax,BonusMin,BonusCur,BonusMaxUp=0,0,0,0
local mainpower="magicka"
local crit_chance,crit_class_bonus,crit_mundus_bonus,crit_champ_bonus,blessed_bonus,rejuvenator_bonus,healing_done,mundus_bonus,divines_bonus,base_stat,damage_power,crit_bonus,buff_bonus,testtime=0,0,0,0,0,0,0,0,0,0,0,0,0,0
local total_heal,total_orbs,last_orb,last_heal=0,0,0,{}
local isHeal={
--Burst (counts as one tick x3)
[85536]={3},[85862]={3},[85863]={3},--Enchanted Growth (Warden)
[22250]={3},[22253]={3},[22256]={3},--Breath of Life (Templar)
[77369]={3},--Twilight Matriarch Restore (Sorc)
[37243]={3},[40103]={3},[40094]={3},--Combat Prayer (Resto)
[114196]={3},[117883]={3},[117888]={3},--Blood Sacrifice (Necr)
[22327]={3},--Ritual of Rebirth (Templar)
[34727]={3},--Healthy Offering (NB)

--HoT {1: duration, 2: tick time}
[61505]={16,2},--Echoing Vigor (Udaunted)
[40169]={10},--Ring of Preservation (Warrior)
[42038]={10},--Energy Orb
	--Resto staf
[28385]={10},[40058]={15},[40060]={10},--Grand Healing
[28536]={10,2},[40076]={10,2},[40079]={10,2},--Radiating Regeneration
	--Templar
[22265]={20,2},[22259]={20,2},[22262]={30,2},--Cleanising Ritual
[21765]={10,2},--Purifying Light
	--NB
[36028]={12},--Refreshing Path
	--DK
[20779]={15},--Cinder Storm
	--Warden
[85578]={3},[85840]={6,1,3},[85845]={3},--Healing Seeds (Budding Seeds have additional burst)
	--Necr
[115710]={16,2},[118912]={16,2},[118840]={16,2},--Spirit Guardian
[115315]={5},[118017]={5},[118809]={5},--Enduring Undeath
[115926]={12,.66},[118070]={12,.66},[118122]={12,.66},--Braided Tether
	--Arcanist
[186189]={6,2},--Evolving Runemend
[186234]={20,2},--Reconstructive Domain
[183537]={4.5,.33},--Remedy Cascade
}
local isResource={
[39298]=20,[42028]=20,[42038]=20,--Orb
[26188]=20,[26858]=20,[26869]=20--Shards
}
local MinMaxStep={	--Stats tester
[1]={10000,60000,1000},--base_stat
[2]={1000,5000,100},	--damage_power
[3]={0,3,.1},		--crit_bonus
[4]={0,15},		--blessed_bonus
[5]={0,15},		--mundus_bonus
[6]={0,16},		--healing_done
[7]={0,33},		--buff_bonus
}

Localization={
["en"]={
	--Section 1
	Stats	="Character stats",
	Magicka	="Magicka",
	Stamina	="Stamina",
	Spd	="Spell Damage",
	Wdm	="Weapon Damage",
	CritBonus	="Crit bonus |cccccaa(chance*power)",
	ConstellationsBonus	="Constellations bonus",
	MundusBonus	="Mundus bonus (Ritual)",
	HealingDone	="Healing done bonus",
	MendingBonus	="Mending bonus",
	TotalPower	="Total healing power",
	--Section 2
	Buffs	="Character buffs",
--	MajorCourage	="Major Courage",
	Courage	="Major+Minor Courage",
	Resolve	="Major+Minor Resolve",
	MinorBerserk	="Minor Berserk",
	ClasBuff	="Class minor buff",
--	Worm	="Worm\'s Raiment",
	Slayer	="Major Slayer",
	PowerfulAssault	="Powerful Assault",
	--Section 3
	Debuffs	="Target debuffs",
--	Magickasteal	="Minor Magickasteal",
	Lifesteal	="Minor Lifesteal",
	Vulnerability	="Minor Vulnerability",
--	Cowardice	="Minor Cowardice",
	Cowardice	="Major+Minor Cowardice",
	Weakening	="Weakening",
--	OffBalance	="Off Balance",
--	StoneTalker	="Stone Talker's Prayer",
	Brittle	="Minor Brittle",
	--Section 4
	Abilitys	="Abilitys",
	Healing	="Healing ability (per tick)",
	Resource	="Resource ability (per "..ORB_CD.." seconds)",
	DPS	="DPS (weaving is important)",
	--Section 5
	Test	="Test",
	TestTime	="Test time",
	Score	="Total score",
	},
["ru"]={
	--Section 1
	Stats	="Характеристики персонажа",
	Magicka	="Магия",
	Stamina	="Стамина",
	Spd	="Сила заклинаний",
	Wdm	="Сила оружия",
	CritBonus	="Бонус крита |cccccaa(шанс*сила)",
	ConstellationsBonus	="Бонус созвездий",
	MundusBonus	="Бонус Мундуса (Ритуал)",
	HealingDone	="Исходящее лечение",
	MendingBonus	="Малое+Великое Исцеление",
	TotalPower	="Всего сила отхила",
	--Section 2
	Buffs	="Бафы персонажа",
	Courage	="Великая+Малая храбрость",
	Resolve	="Великая+Малая решимость",
	MinorBerserk	="Малая ярость",
	ClasBuff	="Классовый баф",
	Slayer	="Жажда убийств",
	PowerfulAssault	="Мощный натиск",
	--Section 3
	Debuffs	="Дебафы цели",
	Magickasteal	="Малое похищение магии",
	Lifesteal	="Малое похищение жизни",
	Vulnerability	="Малая уязвимость",
	Cowardice	="Малая трусость",
	Weakening	="Слабость",
	OffBalance	="Потеря равновесия",
	StoneTalker	="Молитва Говорящего с Камнями",
	Brittle	="Малая хрупкость",
	--Section 4
	Abilitys	="Умения",
	Healing	="Исцеляющие умения",
	Resource	="Залив ресурсов (в "..ORB_CD.." секунд)",
	DPS	="DPS (используйте плетение)",
	--Section 5
	Test	="Тест",
	TestTime	="Время теста",
	Score	="Набранный счёт",
	},
}

local function Loc(var)
	return Localization[BUI.language] and Localization[BUI.language][var] or BUI.Localization.en[var] or var
end

local function Reset()
	StartTime=0
	EndTime=0
	PlayerBuffs={}
	PlayerStats={dmg={},stat={}, crit={}}
	TargetBuffs={}
	total_orbs=0
	last_heal={}
	total_heal=0
	testtime=1
	healing_done=0
	BonusMax=0
	BonusMin=100
	BonusCur=0
	BonusMaxUp=0
	BUI_Helper_Lock:SetHidden(true)
end

local function GetDivinesBonus()
	local bonus=0
	for _,i in pairs({0,2,3,6,8,9,16}) do
		local itemLink=GetItemLink(BAG_WORN,i)
		local trait=GetItemLinkTraitInfo(itemLink)
		local quality=GetItemLinkFunctionalQuality(itemLink)
		if trait==ITEM_TRAIT_TYPE_ARMOR_DIVINES then bonus=bonus+(quality>0 and quality+4.1 or 0) end
	end
	divines_bonus=bonus
end

local function GetCritDamage()
	local class=GetUnitClassId("player")
	local class_bonus=0
	local ability_slotted=0
	local ability={}
	if class==3 or class==6 then	--NB or Templar
		for i=1, 6 do
			local id=GetSkillAbilityId(1,1,i)
			ability[id]=true	--nb assasination abilities or templar aedric spear abilities
		end
		for i=3, 8 do
			if ability[BUI.TranslateIdToScribedId(GetSlotBoundId(i))] then ability_slotted=1 end
		end
		local passive_level=GetSkillAbilityUpgradeInfo(1,1,(class==3 and 10 or 7))
		class_bonus=5*passive_level*ability_slotted
	end

	local points=mainpower=="magicka" and GetNumPointsSpentOnChampionSkill(7, 3)*0.01 or GetNumPointsSpentOnChampionSkill(5, 2)*0.01	--Points in elfborn or precise strikes
	crit_class_bonus=50+class_bonus+math.floor(0.25*points*(2-points)*100)
end

local function GetSetBonus()
	local pair=GetActiveWeaponPairInfo()
	local now=GetGameTimeMilliseconds()
	local worn={(pair==1 and EQUIP_SLOT_MAIN_HAND or EQUIP_SLOT_BACKUP_MAIN),EQUIP_SLOT_HEAD,EQUIP_SLOT_SHOULDERS,EQUIP_SLOT_CHEST,EQUIP_SLOT_WAIST,EQUIP_SLOT_LEGS,EQUIP_SLOT_HAND,EQUIP_SLOT_FEET}
	local bonus=0
	local allready_found={}
	for _,i in pairs(worn) do
		local link=GetItemLink(BAG_WORN,i)
		local hasSet,setName,_,numEquipped,maxEquipped=GetItemLinkSetInfo(link)
		if hasSet and not allready_found[setName] and healing_done_sets[setName] and healing_done_sets[setName].items<=numEquipped then
			allready_found[setName]=true
			bonus=bonus+healing_done_sets[setName].bonus
		end
		if i==EQUIP_SLOT_MAIN_HAND or i==EQUIP_SLOT_BACKUP_MAIN then
			local traitType=GetItemLinkTraitInfo(link)
			if traitType==ITEM_TRAIT_TYPE_WEAPON_POWERED then
				bonus=bonus+GetItemLinkQuality(link)+4
			end
		end
	end

	if BonusMin>bonus then BonusMin=bonus end
	if BonusMax<bonus then BonusMax=bonus end
	BonusCur=bonus
end
--	This commands are used to receive set bonuses
--	/script local link=GetItemLink(BAG_WORN,EQUIP_SLOT_CHEST) local hasSet,setName,_,numEquipped,maxEquipped=GetItemLinkSetInfo(link) d(setName)
--	/script d(GetItemLinkQuality("|H1:item:80312:364:50:0:0:0:1:0:0:0:0:0:0:0:1:35:0:1:0:410:0|h|h")==ITEM_TRAIT_TYPE_WEAPON_POWERED)
local function GetMundusBonus()
	mundus_bonus=0
	crit_mundus_bonus=0
	for i=1, GetNumBuffs("player") do
		local name,_,_,_,_,_,_,_,_,_,id=GetUnitBuffInfo("player",i)
		if id==13980 then mundus_bonus=8*(1+divines_bonus/100) end
		if id==13984 then crit_mundus_bonus=11*(1+divines_bonus/100) end
	end
end

local function GetBuffsPlayer()
	local numBuffs=GetNumBuffs("player")
	if StartTime==0 then PlayerBuffs={} PlayerStats={dmg={},stat={}, crit={}} end
	for i=1, numBuffs do
		local buffName,timeStarted,timeEnding,buffSlot,stackCount,iconFilename,buffType,effectType,abilityType,statusEffectType,abilityId,canClickOff,castByPlayer=GetUnitBuffInfo("player",i)
		if castByPlayer and player_buffs[buffName] then
--			if timeStarted~=timeEnding and timeStarted<StartTime/1000 then timeStarted=StartTime/1000 end
			if PlayerBuffs[buffName]==nil then PlayerBuffs[buffName]=PERIOD/1000
			else PlayerBuffs[buffName]=PlayerBuffs[buffName]+PERIOD/1000 end
		end
	end
	--Powers
	local dmg_power=(GetPlayerStat(STAT_SPELL_POWER)>GetPlayerStat(STAT_POWER)) and GetPlayerStat(STAT_SPELL_POWER) or GetPlayerStat(STAT_POWER)
	if PlayerStats.dmg[dmg_power]==nil then PlayerStats.dmg[dmg_power]=PERIOD/1000
	else PlayerStats.dmg[dmg_power]=PlayerStats.dmg[dmg_power]+PERIOD/1000 end

	local _,stat_max=GetUnitPower("player", mainpower=="magicka" and POWERTYPE_MAGICKA or POWERTYPE_STAMINA)
	if PlayerStats.stat[stat_max]==nil then PlayerStats.stat[stat_max]=PERIOD/1000
	else PlayerStats.stat[stat_max]=PlayerStats.stat[stat_max]+PERIOD/1000 end

	local crit_chance=(GetPlayerStat(STAT_SPELL_CRITICAL)>GetPlayerStat(STAT_CRITICAL_STRIKE)) and GetPlayerStat(STAT_SPELL_CRITICAL)/218 or GetPlayerStat(STAT_CRITICAL_STRIKE)/218
	if PlayerStats.crit[crit_chance]==nil then PlayerStats.crit[crit_chance]=PERIOD/1000
	else PlayerStats.crit[crit_chance]=PlayerStats.crit[crit_chance]+PERIOD/1000 end
end

local function GetBuffsTarget()
	if not DoesUnitExist("reticleover") then return end
	local numBuffs=GetNumBuffs("reticleover")
	if StartTime==0 then TargetBuffs={} end
	for i=1, numBuffs do
		local buffName,timeStarted,timeEnding,buffSlot,stackCount,iconFilename,buffType,effectType,abilityType,statusEffectType,abilityId,canClickOff,castByPlayer=GetUnitBuffInfo("reticleover",i)
		local name=target_buffs[buffName] and buffName or target_buffs[abilityId] and abilityId or nil
		if castByPlayer and name then
			if TargetBuffs[name]==nil then TargetBuffs[name]=PERIOD/1000
			else TargetBuffs[name]=TargetBuffs[name]+PERIOD/1000 end
		end
	end
end

local function Helper_Stop(duration)
	PlaySound("Duel_Forfeit")
	TestInProgress=false
	EndTime=StartTime+duration
	EVENT_MANAGER:UnregisterForUpdate("BUI_Helper")
	EVENT_MANAGER:UnregisterForEvent("BUI_Helper", EVENT_ACTION_SLOT_ABILITY_USED)
--	EVENT_MANAGER:UnregisterForEvent("BUI_Helper", EVENT_ACTIVE_WEAPON_PAIR_CHANGED)
	BUI_Helper_Value_5_1:SetText(tostring(math.floor(duration/1000)).."|cccccaas|r")
	BUI_Helper_Lock:SetHidden(false)
	BUI.OnScreen.Message[9]=nil
end

local function Helper_Update()
	if StartTime~=0 and EndTime-StartTime~=TEST_DURATION then
		local now=GetGameTimeMilliseconds()
		if now-StartTime>=TEST_DURATION then
			Helper_Stop(TEST_DURATION)
			return
		else
			EndTime=now
		end
	end
	--Player buffs
	GetBuffsPlayer()
	testtime=math.max((EndTime-StartTime)/1000,1)
	buff_bonus=0
	local crit_buff_bonus=0
	local major_courage,minor_courage=0,0
	local major_resolve, minor_resolve=0,0
	local class_buff=0
	local class_buff_name=""
--	local worm_buff=0
	local lifesteal=0
--	local off_balance=0
	local weakening=0
--	local stone_talker=0
	local berserk=0
	local major_slayer=0
	local powerful_assault=0
	for name,duration in pairs(PlayerBuffs) do
		local pct=StartTime==0 and 1 or math.min(math.max(duration,1)/testtime,1)
		if crit_forces[name] then crit_buff_bonus=crit_buff_bonus+crit_forces[name]*pct
		elseif healing_forces[name] then buff_bonus=buff_bonus+healing_forces[name]*pct
		elseif class_forces[name] then
			class_buff=pct class_buff_name=name
			BUI_Helper_Label_2_4:SetText("|cccccaa"..class_buff_name.."|r")
		elseif name=="Major Courage" or name=="Великая храбрость" then major_courage=pct
		elseif name=="Minor Courage" or name=="Малая храбрость" then minor_courage=pct
		elseif name=="Major Resolve" or name=="Великая решимость" then major_resolve=pct
		elseif name=="Minor Resolve" or name=="Малая решимость" then minor_resolve=pct
		elseif name=="Minor Berserk" or name=="Малая ярость" then berserk=pct
		elseif name=="Major Slayer" or name=="Великая жажда убийств" then major_slayer=pct
		elseif name=="Powerful Assault" or name=="Мощный натиск" then powerful_assault=pct
--		elseif name=="Worm's Raiment" or name=="Одеяния Червя" then worm_buff=1
		end
	end
	--Powers
	damage_power=0
	for value,duration in pairs(PlayerStats.dmg) do damage_power=damage_power+value*math.min(math.max(duration,1)/testtime,1) end
	base_stat=0
	for value,duration in pairs(PlayerStats.stat) do base_stat=base_stat+value*math.min(math.max(duration,1)/testtime,1) end
	crit_chance=0
	for value,duration in pairs(PlayerStats.crit) do crit_chance=crit_chance+value*math.min(math.max(duration,1)/testtime,1) end

	if BonusCur==BonusMax then BonusMaxUp=BonusMaxUp+PERIOD/1000 end
	healing_done=StartTime==0 and BonusCur or BonusMin+(BonusMax-BonusMin)*(BonusMaxUp/testtime)
--	if StartTime>0 then d(BonusMax.." - "..BonusMin.." * ".. BonusMaxUp.." / "..math.floor(testtime).." = "..math.floor(healing_done*100)/100 .." ("..BonusCur..") ") end

	crit_bonus=1+(1+(crit_class_bonus+crit_buff_bonus+crit_mundus_bonus+crit_champ_bonus)/100)*crit_chance/100/2
	local healing_power=math.floor((base_stat+rejuvenator_bonus+damage_power*10.5)/100*crit_bonus*(1+(blessed_bonus+buff_bonus+mundus_bonus+healing_done)/100))
	local power=math.min(healing_power/ETALON_POWER,1)

	--Target buffs
	GetBuffsTarget()
	local magickasteal=0
	local vulnerability=0
	local major_cowardice,minor_cowardice=0,0
	local minor_brittle=0
--	local minor_penetr=0
	for name,duration in pairs(TargetBuffs) do
		local pct=StartTime==0 and 1 or math.min(math.max(duration,1)/testtime,1)
		if name=="Minor Magickasteal" or name=="Малое похищение магии" then magickasteal=pct
		elseif name=="Minor Vulnerability" or name=="Малая уязвимость" then vulnerability=pct
--		elseif name=="Minor Breach" or name=="Малый прорыв" then minor_penetr=pct
		elseif name=="Minor Lifesteal" or name=="Малое похищение жизни" then lifesteal=pct
		elseif name=="Major Cowardice" or name=="Великая трусость" then major_cowardice=pct
		elseif name=="Minor Cowardice" or name=="Малая трусость" then minor_cowardice=pct
		elseif name=="Minor Brittle" or name=="Малая хрупкость" then minor_brittle=pct
--		elseif name=="Off Balance" or name=="Off-Balance" or name=="Потеря равновесия" then off_balance=pct
		elseif name=="Weakening" or name=="Слабость" then weakening=pct
--		elseif name==154783 then stone_talker=pct	--Stone Talker's Prayer
		end
	end

	--UI update
	--Section 1
	BUI_Helper_Value_1_1:SetText(math.floor(base_stat))
	BUI_Helper_Value_1_2:SetText(math.floor(damage_power))
	BUI_Helper_Value_1_3:SetText("|cccccaax|r"..math.floor(crit_bonus*100)/100)
--	BUI_Helper_Value_1_4:SetText(math.floor(blessed_bonus*10)/10 .."|cccccaa%|r")
	BUI_Helper_Value_1_4:SetText(math.floor(mundus_bonus*10)/10 .."|cccccaa%|r")
	BUI_Helper_Value_1_5:SetText(math.floor(healing_done*10)/10 .."|cccccaa%|r")
	BUI_Helper_Value_1_6:SetText(math.floor(buff_bonus*10)/10 .."|cccccaa%|r")
	BUI_Helper_Value_1_7:SetText("|cffff55"..healing_power.."|r")
	--Section 2
	BUI_Helper_Value_2_1:SetText(math.floor((major_courage+minor_courage/4)*100) .."|cccccaa%|r")
	BUI_Helper_Score_2_1:SetText(math.floor((major_courage+minor_courage/4)*SCORE.courage))
	BUI_Helper_Value_2_2:SetText(math.floor((major_resolve+minor_resolve/4)*100).."|cccccaa%|r")
	BUI_Helper_Score_2_2:SetText(math.floor((major_resolve+minor_resolve/4)*SCORE.resolve))
	BUI_Helper_Value_2_3:SetText(math.floor(berserk*100) .."|cccccaa%|r")
	BUI_Helper_Score_2_3:SetText(math.floor(berserk*SCORE.berserk))
	BUI_Helper_Value_2_4:SetText(math.floor(class_buff*100) .."|cccccaa%|r")
	BUI_Helper_Score_2_4:SetText(math.floor(class_buff*(class_forces[class_buff_name] or 1)*SCORE.class_buff))
--	BUI_Helper_Value_2_5:SetText(math.floor(worm_buff*100) .."|cccccaa%|r")
	BUI_Helper_Value_2_5:SetText(math.floor(major_slayer*100) .."|cccccaa%|r")
	BUI_Helper_Score_2_5:SetText(math.floor(major_slayer*SCORE.slayer))
	BUI_Helper_Value_2_6:SetText(math.floor(powerful_assault*100) .."|cccccaa%|r")
	BUI_Helper_Score_2_6:SetText(math.floor(powerful_assault*SCORE.powerful_assault))
	--Section 3
--	BUI_Helper_Value_3_1:SetText(math.floor(magickasteal*100) .."|cccccaa%|r")
	BUI_Helper_Value_3_1:SetText(math.floor(lifesteal*100) .."|cccccaa%|r")
	BUI_Helper_Score_3_1:SetText(math.floor(lifesteal*SCORE.lifesteal))
--	BUI_Helper_Value_3_3:SetText(math.floor(minor_penetr*100) .."|cccccaa%|r")
	BUI_Helper_Value_3_2:SetText(math.floor(vulnerability*100) .."|cccccaa%|r")
	BUI_Helper_Score_3_2:SetText(math.floor(vulnerability*SCORE.vulnerability))
	BUI_Helper_Value_3_3:SetText(math.floor((major_cowardice+minor_cowardice/4)*100) .."|cccccaa%|r")
	BUI_Helper_Score_3_3:SetText(math.floor((major_cowardice+minor_cowardice/4)*SCORE.cowardice))
	BUI_Helper_Value_3_4:SetText(math.floor(weakening*100) .."|cccccaa%|r")
	BUI_Helper_Score_3_4:SetText(math.floor(weakening*SCORE.weakening))
	BUI_Helper_Value_3_5:SetText(math.floor(minor_brittle*100) .."|cccccaa%|r")
	BUI_Helper_Score_3_5:SetText(math.floor((minor_brittle/4)*SCORE.brittle))
--	BUI_Helper_Value_3_6:SetText(math.floor(stone_talker*100) .."|cccccaa%|r")
--	BUI_Helper_Value_3_6:SetText(math.floor(off_balance*100) .."|cccccaa%|r")
	--Section 4
	local springs=math.min(math.floor(total_heal/testtime*100),500) --Max value must be corrected
	local orbs=math.min(math.floor(total_orbs/testtime*100),200)
	BUI_Helper_Value_4_1:SetText(springs.."|cccccaa%|r")
	BUI_Helper_Score_4_1:SetText(math.floor(power*springs*SCORE.total_healed))
	BUI_Helper_Value_4_2:SetText(orbs.."|cccccaa%|r")
	BUI_Helper_Score_4_2:SetText(math.floor(orbs*SCORE.recharge))
	local fighttime=math.max((BUI.Stats.Current[BUI.ReportN].endTime-BUI.Stats.Current[BUI.ReportN].startTime)/1000,1)
	local dps	=BUI.Stats.Current[BUI.ReportN].damage/fighttime
	BUI_Helper_Value_4_3:SetText(math.floor(dps/1000).."|cccccaaK|r")
	BUI_Helper_Score_4_3:SetText(math.floor(math.min(dps/1000,15)*SCORE.dps))
	--Section 5
	BUI_Helper_Value_5_1:SetText(math.floor(testtime).."|cccccaas|r")
	local score=math.min(
	--Abilitys
		power*springs*SCORE.total_healed
		+orbs*SCORE.recharge
	--Buffs
		+(major_courage+minor_courage/4)*SCORE.courage
		+(major_resolve+minor_resolve/4)*SCORE.resolve
		+berserk*SCORE.berserk
		+class_buff*(class_forces[class_buff_name] or 1)*SCORE.class_buff
--		+worm_buff*62
		+major_slayer*SCORE.slayer
		+powerful_assault*SCORE.powerful_assault
	--Debuffs
--		+magickasteal*88
		+lifesteal*SCORE.lifesteal
		+vulnerability*SCORE.vulnerability
--		+minor_penetr*88
		+(major_cowardice+minor_cowardice/4)*SCORE.cowardice
--		+off_balance*88
		+weakening*SCORE.weakening
--		+stone_talker*88
		+(minor_brittle/4)*SCORE.brittle
	--DPS
		+math.min(dps/1000,15)*SCORE.dps
		,MAX_SCORE)
	BUI_Helper_Value_5_2:SetText("|cffff55"..math.floor(score).."|r")
end

local function Helper_Init()
	local magicka,stamina=GetPlayerStat(STAT_MAGICKA_MAX),GetPlayerStat(STAT_STAMINA_MAX)
	mainpower=(stamina>magicka) and "stamina" or "magicka"
	crit_chance=(GetPlayerStat(STAT_SPELL_CRITICAL)>GetPlayerStat(STAT_CRITICAL_STRIKE)) and GetPlayerStat(STAT_SPELL_CRITICAL)/218 or GetPlayerStat(STAT_CRITICAL_STRIKE)/218
	--Constellations
	--	9 Rejuvenator Grants 41 Weapon and Spell Damage to your healing abilities per stage.
	--	12 Fighting Finesse Increases your Critical Damage and Critical Healing done by 4% per stage.
	--	24 Soothing Tide Increases your Healing Done by area of effect heals by 2% per stage.
	--	26 Focused Mending Increases your Healing Done with single target heals by 2% per stage.
	--	28 Swift Renewal Increases your Healing Done with healing over time effects by 2% per stage.
	rejuvenator_bonus=math.floor(GetNumPointsSpentOnChampionSkill(9)/10)*41
	blessed_bonus=0
	local healing_done_descr=''
	for i=5,8 do
		local id=BUI.TranslateIdToScribedId(GetSlotBoundId(i,HOTBAR_CATEGORY_CHAMPION))
		if id==12 then	--Finese
			crit_champ_bonus=math.floor(GetNumPointsSpentOnChampionSkill(id)/25)*4
		elseif id==24 or id==26 or id==28 then	--Tide, Renewal, Mending
			local value=math.floor(GetNumPointsSpentOnChampionSkill(id)/10)*2
			blessed_bonus=blessed_bonus+value/3
			if value>0 then
				healing_done_descr=healing_done_descr..", "..tostring(value)
			end
		end
	end
	BUI.OnScreen.Message[9]=nil
	Reset()
	--Section 1
	BUI_Helper_Label_1_1:SetText(mainpower=="magicka" and "|c5555ff"..Loc("Magicka").."|r" or "|c33bb33"..Loc("Stamina").."|r")
	BUI_Helper_Label_1_2:SetText(((GetPlayerStat(STAT_SPELL_POWER)>GetPlayerStat(STAT_POWER)) and "|c5555ff"..Loc("Spd").."|r" or "|c33bb33"..Loc("Wdm").."|r").." (+"..rejuvenator_bonus..")")
	BUI_Helper_Label_1_3:SetText(((GetPlayerStat(STAT_SPELL_CRITICAL)>GetPlayerStat(STAT_CRITICAL_STRIKE)) and "|c5555ff" or "|c33bb33")..Loc("CritBonus").."|r")
--	BUI_Helper_Label_1_4:SetText("|cccccaa"..Loc("ConstellationsBonus").."|r (+"..healing_done_descr..")")
	BUI_Helper_Label_1_4:SetText("|cccccaa"..Loc("MundusBonus").."|r")
	BUI_Helper_Label_1_5:SetText("|cccccaa"..Loc("HealingDone").."|r (+"..healing_done_descr..")")
	BUI_Helper_Label_1_6:SetText("|cccccaa"..Loc("MendingBonus").."|r")
	BUI_Helper_Label_1_7:SetText(Loc("TotalPower"))
	--Section 2
	BUI_Helper_Label_2_1:SetText("|cccccaa"..Loc("Courage").."|r")
	BUI_Helper_Label_2_2:SetText("|cccccaa"..Loc("Resolve").."|r")
	BUI_Helper_Label_2_3:SetText("|cccccaa"..Loc("MinorBerserk").."|r")
	BUI_Helper_Label_2_4:SetText("|cccccaa"..Loc("ClasBuff").."|r")
--	BUI_Helper_Label_2_5:SetText("|cccccaa"..Loc("Worm").."|r")
	BUI_Helper_Label_2_5:SetText("|cccccaa"..Loc("Slayer").."|r")
	BUI_Helper_Label_2_6:SetText("|cccccaa"..Loc("PowerfulAssault").."|r")
	--Section 3
--	BUI_Helper_Label_3_1:SetText("|cccccaa"..Loc("Magickasteal").."|r")
	BUI_Helper_Label_3_1:SetText("|cccccaa"..Loc("Lifesteal").."|r")
--	BUI_Helper_Label_3_3:SetText("|cccccaaMinor Fracture/Breach|r")
	BUI_Helper_Label_3_2:SetText("|cccccaa"..Loc("Vulnerability").."|r")
	BUI_Helper_Label_3_3:SetText("|cccccaa"..Loc("Cowardice").."|r")
	BUI_Helper_Label_3_4:SetText("|cccccaa"..Loc("Weakening").."|r")
	BUI_Helper_Label_3_5:SetText("|cccccaa"..Loc("Brittle").."|r")
--	BUI_Helper_Label_3_6:SetText("|cccccaa"..Loc("StoneTalker").."|r")
--	BUI_Helper_Label_3_6:SetText("|cccccaa"..Loc("OffBalance").."|r")
	--Section 4
	BUI_Helper_Label_4_1:SetText("|cccccaa"..Loc("Healing").."|r")
	BUI_Helper_Label_4_2:SetText("|cccccaa"..Loc("Resource").."|r")
	BUI_Helper_Label_4_3:SetText("|cccccaa"..Loc("DPS").."|r")
	--Section 5
	BUI_Helper_Label_5_1:SetText("|cccccaa"..Loc("TestTime").."|r")
	BUI_Helper_Label_5_2:SetText(Loc("Score"))
	local fs=18
	local name="|t"..fs..":"..fs..":"..GetClassIcon(GetUnitClassId("player")).."|t"..BUI.Player.name.." ("..BUI.Player:GetColoredLevel("player")..")"
	BUI_Helper_Name:SetText(name)
	local date=GetDate() date=" "..string.sub(date,7,8).."."..string.sub(date,5,6).."."..string.sub(date,1,4)
	BUI_Helper_Version:SetText(BUI.ESOVersion..date)

	GetCritDamage()
	GetSetBonus()
	GetDivinesBonus()
	GetMundusBonus()
	Helper_Update()
end

local function CustomUpdate()
	local stat=BUI_Helper_Slider_1.value
	local damage=BUI_Helper_Slider_2.value
	local crit=BUI_Helper_Slider_3.value
	local blessed=BUI_Helper_Slider_4.value
	local mundus=BUI_Helper_Slider_5.value
	local set=BUI_Helper_Slider_6.value
	local buff=BUI_Helper_Slider_7.value
	local power=math.floor((stat+damage*10.5)/100*crit*(1+(blessed+buff+mundus+set)/100))
	BUI_Helper_Custom_Value:SetText(power)
end

local function CustomInit()
	BUI_Helper_Slider_1:UpdateValue(math.floor(base_stat))
	BUI_Helper_Slider_2:UpdateValue(math.floor(damage_power))
	BUI_Helper_Slider_3:UpdateValue(crit_bonus)
	BUI_Helper_Slider_4:UpdateValue(blessed_bonus)
	BUI_Helper_Slider_5:UpdateValue(mundus_bonus)
	BUI_Helper_Slider_6:UpdateValue(healing_done)
	BUI_Helper_Slider_7:UpdateValue(buff_bonus)
	CustomUpdate()
end

local function UI_Custom()
	if BUI_Helper_Custom then
		if BUI_Helper_Custom:IsHidden()==false then
			BUI_Helper_Custom_sw:SetState(BSTATE_NORMAL)
			BUI_Helper_Custom:SetHidden(true)
		else
			BUI_Helper_Custom:SetHidden(false)
			BUI_Helper_Custom_sw:SetState(BSTATE_PRESSED)
			CustomInit()
		end
		return
	end
	BUI_Helper_Custom_sw:SetState(BSTATE_PRESSED)
	local fs,s=18,1
	local w,h=220,fs*1.5*9+2
	local space=5
	local ui	=BUI.UI.Control(	"BUI_Helper_Custom",		BUI_Helper,	{w,h},		{TOPLEFT,TOPRIGHT,-2,28},	false)
	ui.bg		=BUI.UI.Backdrop(	"BUI_Helper_Custom_Bg",		ui,		"inherit",		{TOPLEFT,TOPLEFT,0,0},		{0,0,0,0.7}, {.7,.7,.5,.3}, nil, false)
	ui.header	=BUI.UI.Label(	"BUI_Helper_Custom_Header",	ui,		{w,fs*1.5},		{TOPLEFT,TOPLEFT,30,0},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, "Stats tester", false)
	ui.bg1	=BUI.UI.Backdrop(	"BUI_Helper_Custom_Header_BG",ui.header,	{w-20,fs},		{LEFT,LEFT,-20,0},		{.4,.4,.4,.3}, {0,0,0,0}, nil, false)
	for i=1,7 do
		BUI.UI.Slider(	"BUI_Helper_Slider_"..i,		ui,		{w-20,fs},		{TOPLEFT,TOPLEFT,10,10+fs*1.5*i},	false, function() CustomUpdate() end,MinMaxStep[i])
	end
	ui.value	=BUI.UI.Label(	"BUI_Helper_Custom_Value",	ui,		{50,fs*1.5},	{BOTTOMRIGHT,BOTTOMRIGHT,-10,0},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "0"	, false)
	CustomInit()
end

local function UI_Init()
	local fs,s=18,1
	local w,h=370,30+fs*1.5*(8+7+6+3+5)
	local lh=h-30-fs*1.5
	local ui		=BUI.UI.TopLevelWindow("BUI_Helper",		GuiRoot,	{w+20,h},		{TOPLEFT,TOPLEFT,220,50})
	ui:SetMouseEnabled(true) ui:SetMovable(true)
	ui.bg			=BUI.UI.Backdrop(	"BUI_Helper_Backdrop",		ui,		"inherit",		{CENTER,CENTER,0,0},		{0,0,0,0.7}, {0,0,0,0.9})
	ui.header		=BUI.UI.Statusbar("BUI_Helper_Header",		ui,		{w+20,30},		{TOPLEFT,TOPLEFT,0,0},		{.5,.5,.5,.7})
	ui.header:SetGradientColors(0.4,0.4,0.4,0.7,0,0,0,0)
	ui.close		=BUI.UI.Button(	"BUI_Helper_Close",		ui,		{34,34},		{TOPRIGHT,TOPRIGHT,5*s,5*s},	BSTATE_NORMAL)
	ui.close:SetNormalTexture('/esoui/art/buttons/closebutton_up.dds')
	ui.close:SetMouseOverTexture('/esoui/art/buttons/closebutton_mouseover.dds')
	ui.close:SetHandler("OnClicked", function() PlaySound("Click") BUI.Helper_Toggle() end)
	--Reset
	ui.reset		=BUI.UI.Button(	"BUI_Helper_Reset",		ui,		{34,34},		{TOPRIGHT,TOPRIGHT,5*s-34,-2*s},	BSTATE_NORMAL)
	ui.reset:SetNormalTexture('/esoui/art/help/help_tabicon_feedback_up.dds')
	ui.reset:SetMouseOverTexture('/esoui/art/help/help_tabicon_feedback_over.dds')
	ui.reset:SetHandler("OnClicked", Helper_Init)
--	ui.box		=BUI.UI.Backdrop(	"BUI_Helper_Box",			ui.header,	{20,20},		{LEFT,LEFT,5*s,0},		{0,0,0,0}, {.7,.7,.5,1})
	ui.box		=BUI.UI.Button(	"BUI_Helper_Box",			ui,		{30,30},		{TOPLEFT,TOPLEFT,5*s,0},	BSTATE_NORMAL)
	ui.box:SetNormalTexture('/esoui/art/lfg/lfg_healer_up.dds')
	ui.box:SetMouseOverTexture('/esoui/art/lfg/lfg_healer_over.dds')
	ui.title		=BUI.UI.Label(	"BUI_Helper_Title",		ui.header,	{w,30},		{LEFT,LEFT,40*s,0},		BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, "Healer helper")
	ui.lock		=BUI.UI.Backdrop(	"BUI_Helper_Lock",		ui.header,	{105,lh},		{TOPRIGHT,BOTTOMRIGHT,-10,0},	{.4,.4,.4,.3}, {0,0,0,0}, nil, true)
	ui.lockicon		=BUI.UI.Texture(	"BUI_Helper_LockIcon",		ui.lock,	{24,24},		{TOP,TOP,0,0},			'esoui/art/tooltips/icon_lock.dds')
	--Section 1
	ui.cont1		=BUI.UI.Backdrop(	"BUI_Helper_Border_1",		ui.header,	{w+20,fs*1.5*8+2},{TOPLEFT,BOTTOMLEFT,0,-2},	{0,0,0,0}, {.7,.7,.5,.3})
	ui.S1			=BUI.UI.Label(	"BUI_Helper_Section_1",		ui.header,	{w,fs*1.5},		{TOPLEFT,BOTTOMLEFT,30,0},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, Loc("Stats"))
	ui.bg1		=BUI.UI.Backdrop(	"BUI_Helper_BG_1",		ui.S1,	{w-110,fs},		{LEFT,LEFT,-20,0},		{.4,.4,.4,.3}, {0,0,0,0})
	--Custom
	ui.custom		=BUI.UI.Button(	"BUI_Helper_Custom_sw",		ui.bg1,	{fs,fs},	{RIGHT,RIGHT,0,0},	BSTATE_NORMAL)
	ui.custom:SetNormalTexture('/esoui/art/charactercreate/charactercreate_rightarrow_up.dds')
	ui.custom:SetMouseOverTexture('/esoui/art/charactercreate/charactercreate_rightarrow_over.dds')
	ui.custom:SetPressedTexture('/esoui/art/charactercreate/charactercreate_leftarrow_up.dds')
	ui.custom:SetPressedMouseOverTexture('/esoui/art/charactercreate/charactercreate_leftarrow_over.dds')
	ui.custom:SetHandler("OnClicked", UI_Custom)
	for i=1,7 do
		local label	=BUI.UI.Label(	"BUI_Helper_Label_1_"..i,	ui.header,	{w,fs*1.5},		{TOPLEFT,BOTTOMLEFT,10,fs*1.5*i},	BUI.UI.Font(i==8 and "esobold" or "standard",fs,true), {1,1,1,1}, {0,1}, "")
				BUI.UI.Label(	"BUI_Helper_Value_1_"..i,	label,	{50,fs*1.5},	{RIGHT,RIGHT,-50,0},		BUI.UI.Font(i==8 and "esobold" or "standard",fs,true), {1,1,1,1}, {0,1}, "")
	end
	--Section 2
	ui.cont2		=BUI.UI.Backdrop(	"BUI_Helper_Border_2",		ui.cont1,	{w+20,fs*1.5*7+2},{TOPLEFT,BOTTOMLEFT,0,-2},	{0,0,0,0}, {.7,.7,.5,.3})
	ui.S2			=BUI.UI.Label(	"BUI_Helper_Section_2",		ui.cont1,	{w,fs*1.5},		{TOPLEFT,BOTTOMLEFT,30,0},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, Loc("Buffs"))
	ui.bg2		=BUI.UI.Backdrop(	"BUI_Helper_BG_2",		ui.S2,	{w-110,fs},		{LEFT,LEFT,-20,0},		{.4,.4,.4,.3}, {0,0,0,0})
	for i=1,6 do
		local label	=BUI.UI.Label(	"BUI_Helper_Label_2_"..i,	ui.cont1,	{w,fs*1.5},		{TOPLEFT,BOTTOMLEFT,10,fs*1.5*i},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "")
				BUI.UI.Label(	"BUI_Helper_Value_2_"..i,	label,	{50,fs*1.5},	{RIGHT,RIGHT,-50,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "")
				BUI.UI.Label(	"BUI_Helper_Score_2_"..i,	label,	{50,fs*1.5},	{RIGHT,RIGHT,0,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "0")
	end
	--Section 3
	ui.cont3		=BUI.UI.Backdrop(	"BUI_Helper_Border_3",		ui.cont2,	{w+20,fs*1.5*6+2},{TOPLEFT,BOTTOMLEFT,0,-2},	{0,0,0,0}, {.7,.7,.5,.3})
	ui.S3			=BUI.UI.Label(	"BUI_Helper_Section_3",		ui.cont2,	{w,fs*1.5},		{TOPLEFT,BOTTOMLEFT,30,0},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, Loc("Debuffs"))
	ui.bg3		=BUI.UI.Backdrop(	"BUI_Helper_BG_3",		ui.S3,	{w-110,fs},		{LEFT,LEFT,-20,0},		{.4,.4,.4,.3}, {0,0,0,0})
	for i=1,5 do
		local label	=BUI.UI.Label(	"BUI_Helper_Label_3_"..i,	ui.cont2,	{w,fs*1.5},		{TOPLEFT,BOTTOMLEFT,10,fs*1.5*i},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "")
				BUI.UI.Label(	"BUI_Helper_Value_3_"..i,	label,	{50,fs*1.5},	{RIGHT,RIGHT,-50,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "")
				BUI.UI.Label(	"BUI_Helper_Score_3_"..i,	label,	{50,fs*1.5},	{RIGHT,RIGHT,0,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "0")
	end
	--Section 4
	ui.cont4		=BUI.UI.Backdrop(	"BUI_Helper_Border_4",		ui.cont3,	{w+20,fs*1.5*4+2},{TOPLEFT,BOTTOMLEFT,0,-2},	{0,0,0,0}, {.7,.7,.5,.3})
	ui.S4			=BUI.UI.Label(	"BUI_Helper_Section_4",		ui.cont3,	{w,fs*1.5},		{TOPLEFT,BOTTOMLEFT,30,0},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, Loc("Abilitys"))
	ui.bg4		=BUI.UI.Backdrop(	"BUI_Helper_BG_4",		ui.S4,	{w-110,fs},		{LEFT,LEFT,-20,0},		{.4,.4,.4,.3}, {0,0,0,0})
	for i=1,3 do
		local label	=BUI.UI.Label(	"BUI_Helper_Label_4_"..i,	ui.cont3,	{w,fs*1.5},		{TOPLEFT,BOTTOMLEFT,10,fs*1.5*i},	BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "")
				BUI.UI.Label(	"BUI_Helper_Value_4_"..i,	label,	{50,fs*1.5},	{RIGHT,RIGHT,-50,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "")
				BUI.UI.Label(	"BUI_Helper_Score_4_"..i,	label,	{50,fs*1.5},	{RIGHT,RIGHT,0,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "0")
	end
	--Section 5
	ui.cont5		=BUI.UI.Backdrop(	"BUI_Helper_Border_5",		ui.cont4,	{w+20,fs*1.5*3+2},{TOPLEFT,BOTTOMLEFT,0,-2},	{0,0,0,0}, {.7,.7,.5,.3})
	ui.S5			=BUI.UI.Label(	"BUI_Helper_Section_5",		ui.cont4,	{w,fs*1.5},		{TOPLEFT,BOTTOMLEFT,30,0},	BUI.UI.Font("esobold",fs,true), {1,1,1,1}, {0,1}, Loc("Test"))
	ui.bg5		=BUI.UI.Backdrop(	"BUI_Helper_BG_5",		ui.S5,	{w-110,fs},		{LEFT,LEFT,-20,0},		{.4,.4,.4,.3}, {0,0,0,0})
	--Help
	BUI.UI.SimpleButton("BUI_Helper_Help", ui.bg5, {26,26}, {RIGHT,RIGHT,0,0}, "/esoui/art/miscellaneous/help_icon.dds", false, nil, BUI.Loc("HelperToolTip"))
	for i=1,2 do
		local label	=BUI.UI.Label(	"BUI_Helper_Label_5_"..i,	ui.cont4,	{w,fs*1.5},		{TOPLEFT,BOTTOMLEFT,10,fs*1.5*i},	BUI.UI.Font(i==3 and "esobold" or "standard",fs,true), {1,1,1,1}, {0,1}, "")
				BUI.UI.Label(	"BUI_Helper_Value_5_"..i,	label,	{50,fs*1.5},	{RIGHT,RIGHT,0,0},		BUI.UI.Font(i==3 and "esobold" or "standard",fs,true), {1,1,1,1}, {0,1}, "")
	end
	--Bottom
	ui.cont6		=BUI.UI.Statusbar("BUI_Helper_Border_6",		ui,		{w+20,fs*1.5+2},	{BOTTOMLEFT,BOTTOMLEFT,0,0},	{.65,.65,.5,.2})
	ui.S6			=BUI.UI.Label(	"BUI_Helper_Name",		ui.cont6,	{w,fs*1.5},		{LEFT,LEFT,10,0},			BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "")
	ui.version		=BUI.UI.Label(	"BUI_Helper_Version",		ui.S6,	{140,fs*1.5},	{RIGHT,RIGHT,0,0},		BUI.UI.Font("standard",fs,true), {1,1,1,1}, {0,1}, "")
end

local function OnSlotAbilityUsed(_,slot)
	if slot<3 or slot>7 then return end
	local id=BUI.TranslateIdToScribedId(GetSlotBoundId(slot))
	local now=GetGameTimeMilliseconds()
--	if BUI.Vars.DeveloperMode then d(BUI.TimeStamp().."["..id.."] "..GetAbilityName(id)) end

	if isHeal[id] then
		local start=now
		local duration=isHeal[id][1]
		local ticks_time=isHeal[id][2] or 1
		local least=duration
		if last_heal[id] then
			--Count 'least' duration if abilyty is still active
			least=duration-math.floor(math.max(last_heal[id]-now,0)/1000)
		end

		if isHeal[id][3] then	--Additional burst (Budding Seeds)
			least=least+isHeal[id][3]
		end

		least=math.min(least, (StartTime+TEST_DURATION-now)/1000)
		local ticks=least/ticks_time
		total_heal=total_heal+ticks
		last_heal[id]=now+duration*1000

		if BUI.Vars.DeveloperMode then
			d(BUI.TimeStamp()
				..'['..id..'] '
				..GetAbilityName(id)
				..'|cccccaa'
				..' duration: '..duration
				..((least<duration) and '(-'..math.floor(duration-least)..')' or '')
				..' ticks: '..math.floor(ticks)
				..'|r'
			)
		end
	end

	if isResource[id] and last_orb-500<now then
		total_orbs=total_orbs+isResource[id]
		last_orb=now+isResource[id]*1000
	end
end

local function OnCombatState(_,inCombat)
	if inCombat and (StartTime==0 or EndTime-StartTime==TEST_DURATION) then
		TestInProgress=true
		Reset()
		GetCritDamage()
		GetSetBonus()
		GetDivinesBonus()
		GetMundusBonus()
		StartTime=GetGameTimeMilliseconds()
		EVENT_MANAGER:RegisterForUpdate("BUI_Helper", PERIOD, Helper_Update)
		EVENT_MANAGER:RegisterForEvent("BUI_Helper", EVENT_ACTION_SLOT_ABILITY_USED,OnSlotAbilityUsed)
		BUI.OnScreen.Notification(9,"Healer test","Duel_Start",TEST_DURATION)
	elseif TestInProgress then
		Helper_Stop(GetGameTimeMilliseconds()-StartTime)
	end
end

function BUI.Helper_Toggle()
	if BUI_Helper and BUI_Helper:IsHidden()==false then
		BUI_Helper:SetHidden(true)
		BUI.OnScreen.Message[9]=nil
		EVENT_MANAGER:UnregisterForUpdate("BUI_Helper")
		EVENT_MANAGER:UnregisterForEvent("BUI_Helper", EVENT_PLAYER_COMBAT_STATE)
		EVENT_MANAGER:UnregisterForEvent("BUI_Helper", EVENT_ACTIVE_WEAPON_PAIR_CHANGED)
	else
		if not BUI_Helper then UI_Init() else BUI_Helper:SetHidden(false) end
		Helper_Init()
		EVENT_MANAGER:RegisterForUpdate("BUI_Helper", PERIOD, Helper_Update)
		EVENT_MANAGER:RegisterForEvent("BUI_Helper", EVENT_PLAYER_COMBAT_STATE,OnCombatState)
		EVENT_MANAGER:RegisterForEvent("BUI_Helper", EVENT_ACTIVE_WEAPON_PAIR_CHANGED,GetSetBonus)
	end
end
