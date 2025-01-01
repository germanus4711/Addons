aTim99_Tbar = aTim99_Tbar or {}
local ttb = aTim99_Tbar
	
ttb.name          = "aTim99_Tbar"
ttb.author        = "tim99"
ttb.dbA	          = {}
ttb.dbP           = {}
ttb.firstRun      = 0
ttb.doReadMount   = true
ttb.doReadSmith   = true
ttb.doReadWoody   = true
ttb.doReadCloth   = true
ttb.doReadJewly   = true
ttb.toggleShare   = false
ttb.allSvData1    = {}
ttb.allSvData2    = {}
ttb.prefix        = "tbr:"
ttb.doReadDragon  = true
ttb.doReadSilent  = true
--ttb.doReadAnnihil = true
ttb.isRegistered  = false
ttb.isRegistered2 = false
ttb.isRegistered3 = false
ttb.isRegistered4 = false
ttb.isRegistered5 = false
ttb.displayName   = GetDisplayName()
ttb.charName      = GetUnitName("player")
ttb.accSrvName    = string.format("%s%s", string.sub(GetWorldName(),1,2), GetDisplayName())
ttb.srv           = string.sub(GetWorldName(),1,2)
--ttb.lowPopEP      = false
--ttb.lowPopDC      = false
--ttb.lowPopAD      = false

ttb.svDefPc={
	accList       = {},
	trusted       = {},
}
ttb.svDefPc.accList[ttb.accSrvName]={
	name          = ttb.accSrvName,
	claimed       = 0,
	sort          = 99,
}
ttb.svDefAcc={
	refreshTime   = 4, --sec
	hideTheTruth  = false,
	charList      = {},
	dragonGuard	  = 0,
	newMoon	      = 0,
	upOrDown      = 1,
	meritenIC     = 0,
	annihil       = 0,
	showSkull     = true,
	showSilent    = true,
	showDragon    = true,
	--showDeadland  = true,
	showIC        = true,
	showDebug     = false,
	showXPperc    = false,
	showEndeaProg = true,
}
ttb.svDefAcc.charList[ttb.charName]={
	name          = ttb.charName,
	sort          = 21,
	trackWrit     = true,
	trackStiller  = true,
	trackMount    = true,
	destroyMonk	  = true,
	writsDone     = 0,
	mountFeed     = 0,
	stiller       = select(6,GetSkillAbilityInfo(5,2,4)) and 0 or 1,
	showResearch  = false,
}
--must fit XML
ttb.offsets={
	skull         = 11,
	--deadlands     = -1,
	ic            = -2,
	dragon        = 4,
	silent        = -2,
	research1     = 14,
	research23    = 3,
	research4     = 2,
}
ttb.cntItem={
	[54200]={icon="/esoui/art/icons/quest_head_monster_016.dds",lnk="|H1:item:54200:4:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h"},		--Skull
	[30357]={icon="/esoui/art/icons/lockpick.dds",			    lnk="|H1:item:30357:175:1:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h"},	--Lockpick
	[33271]={icon="/esoui/art/icons/soulgem_006_filled.dds",	lnk="|H1:item:33271:31:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h"},	--Soulgem
	[44879]={icon="/esoui/art/lfg/lfg_bonus_crate.dds",		    lnk="|H1:item:44879:121:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h"},	--Repairkit
}
ttb.colors={
	c_no_avail=ZO_ColorDef:New(.25,.25,.25, 1), --#404040  //( 64, 64, 64)  //( 64/255, 64/255, 64/255,1)
	c_disabled=ZO_ColorDef:New(.45,.45,.45, 1), --#737373  //(115,115,115)  //(115/255,115/255,115/255,1)
	c_red_todo=ZO_ColorDef:New(  1,.15,  0, 1), --#ff2600  //(255, 38,  0)  //(255/255, 38/255,  0/255,1)
	c_green_ok=ZO_ColorDef:New(  0,  1,  0, 1), --#00ff00  //(  0,255,  0)  //(  0/255,255/255,  0/255,1)
	c_yellow  =ZO_ColorDef:New(  1,.80,  0, 1), --#ffcc00  //(255,204,  0)  //(255/255,204/255,  0/255,1)
}
local isRemainsSilent={["Schweigt-still"]=true, ["Remains-Silent"]=true, ["Хранит-Молчание"]=true, ["Garde-le-Silence"]=true}
local outlawNPCs={["Fa'ren-dar"]=true, ["Фа'рен-дар"]=true, ["Kari"]=true, ["Кари"]=true}

--local IsChest={["Chest"]=true,["Truhe^f"]=true,["coffre^m"]=true,["Сундук"]=true,}
--/tbug TimTbarWindow
--/script d( zo_iconFormat("/esoui/art/ava/tabicon_bg_helper.dds",26,26) )
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
local function GetTTime(i_ctrl)
	local day,night=20955,7200
	local tSinceMidnight=GetTimeStamp()-(1398044126-night/2-(day-night)/2)
	local daysPast=day*math.floor(tSinceMidnight/day)
	local s=tSinceMidnight-daysPast
	local t=24*s/day
	local h=math.floor(t) t=(t-h)*60
	local m=math.floor(t) t=(t-m)*60
	local ico=(h>=4 and h<22) and 
		zo_iconFormat("/esoui/art/tutorial/cadwell_indexicon_gold_up.dds", 28,28) or 
		zo_iconFormat("/esoui/art/tutorial/cadwell_indexicon_silver_up.dds", 26,26)
	i_ctrl:SetText(string.format('%s|cCCCCAA%02d:%02d|r',ico,h,m))
end
----------------------------------------------------------------------------------------------------
local function GetNiceTime(i_unixtime)
	return os.date("%d.%m.%Y %X", i_unixtime)
end
----------------------------------------------------------------------------------------------------
function ttb.GetStaticInfos(i_ctrl,i_ctrlL,i_ctrlR)
	--CHAR-NAME, CLASS-SYMBOL
	local classX={
		[1]={n="dragonknight",c={255, 102,   0} }, --#ff6600 //orange             --c={ 51, 204,  51} }, --#33cc33 //grün
		[2]={n="sorcerer"    ,c={184,  89, 255} }, --#b859ff //lila
		[3]={n="nightblade"  ,c={255, 102, 204} }, --#ff66cc //rosa  (Schwuggeles)
		[4]={n="warden"      ,c={128, 255, 128} }, --#80ff80 //hellgrün
		[5]={n="necromancer" ,c={102, 255, 255} }, --#66ffff //blau
		[6]={n="templar"     ,c={255, 214,  51} }, --#ffd633 //orange-gelb
	  [117]={n="arcanist"    ,c={ 0 , 255,   0} }} --#00ff00 //grün
	local pClassX=classX[GetUnitClassId("player")] or classX[1]
	local pIco=string.format("/esoui/art/icons/class/gamepad/gp_class_%s.dds",pClassX.n)
	local ico=ZO_ColorDef:New(pClassX.c[1]/255,pClassX.c[2]/255,pClassX.c[3]/255,1):Colorize(zo_iconFormatInheritColor(pIco, 25,25))
	--CURSE
	local ico2=""
	for i = 1, GetNumBuffs("player") do
		local iconFilename,_,_,_,_,abilityId=select(6,GetUnitBuffInfo("player",i))
		if abilityId==135397 or abilityId==135399 or abilityId==135400 or abilityId==135402 then
			ico2=zo_iconFormat(iconFilename,19,19)
		elseif abilityId==35658 then
			ico2=zo_iconFormat(iconFilename,21,21).." "
		end
	end
	i_ctrl:SetText(string.format('%s%s|cC0A27F|u2:0::%s|u|r',ico2,ico,GetUnitName("player")))
	--ALLIANZ
	local allyX
	if ttb.dbA.hideTheTruth~=nil and ttb.dbA.hideTheTruth==true then
		allyX={"esoUI/art/scoredisplay/yellowflag.dds","esoUI/art/scoredisplay/redflag.dds","EsoUI/art/scoredisplay/blueflag.dds"}
	else
		allyX={"aTim99_Tbar/img/yellowflag.dds","esoUI/art/scoredisplay/redflag.dds","EsoUI/art/scoredisplay/blueflag.dds"}
	end
	local pAllyFlag=allyX[GetUnitAlliance("player")]
	i_ctrlL:SetTexture(pAllyFlag) i_ctrlL:SetColor(1,1,1,1)
	i_ctrlR:SetTexture(pAllyFlag) i_ctrlR:SetColor(1,1,1,1)
end
----------------------------------------------------------------------------------------------------
local function GetNumCP(i_ctrl)
	local ico,lvl=" "," "
	if IsUnitChampion('player') then
		--erfrischt?
		if IsEnlightenedAvailableForCharacter() and GetEnlightenedPool()>0 then
			ico=ZO_ColorDef:New(1,1,0,1):Colorize(zo_iconFormatInheritColor("/esoui/art/mainmenu/menubar_champion_down.dds", 33,33))
		else
			ico=zo_iconFormat("/esoui/art/mainmenu/menubar_champion_up.dds",27,27)
		end
		lvl=string.format('|cC9BC0Fcp|r|cFFFFCC%s|r',GetPlayerChampionPointsEarned())
	else
		ico=zo_iconFormat("/esoui/art/mainmenu/menubar_skills_up.dds",28,28)
		lvl=string.format('|c7FA292Level:|r |cE8E7E3%s|r',GetUnitLevel("player"))
	end
	i_ctrl:SetText(string.format('%s%s',ico,lvl))
end
----------------------------------------------------------------------------------------------------
local function GetCntXP(i_ctrl)
	local ico=" "
	local myStatus=GetPlayerStatus()
	if myStatus==PLAYER_STATUS_OFFLINE then
		ico=zo_iconFormat("/esoui/art/tutorial/tutorial_illo_status_offline.dds", 27,26)
	elseif myStatus==PLAYER_STATUS_AWAY then
		ico=zo_iconFormat("/esoui/art/tutorial/tutorial_illo_status_afk.dds", 27,26)
	elseif myStatus==PLAYER_STATUS_DO_NOT_DISTURB then
		ico=zo_iconFormat("/esoui/art/tutorial/tutorial_illo_status_dnd.dds", 27,26)
	else --myStatus==PLAYER_STATUS_ONLINE
		ico=zo_iconFormat("/esoui/art/tutorial/tutorial_illo_status_online.dds", 27,26)
	end	
	local lvl=GetUnitLevel('player')
	local XPcurr,XPnxtCP,XPperc
	if lvl>=50 then
		XPcurr,XPnxtCP=GetPlayerChampionXP(),GetNumChampionXPInChampionPoint(GetPlayerChampionPointsEarned())
	else
		XPcurr,XPnxtCP=GetUnitXP('player'),GetUnitXPMax('player')
	end
	if GetPlayerChampionPointsEarned()==3600 and lvl>=50 then
		i_ctrl:SetText(string.format('%s',ico))
	else
		if ttb.dbA.showXPperc then
			XPperc=math.floor((math.floor(XPcurr*100/XPnxtCP*2) + 1)/2)
			i_ctrl:SetText(string.format('%s|cDEDEDE%s|r|cA0A0CF|u2:1::/|u%s|r |cDEDEDE(%s%%)|r',ico,zo_strformat(SI_NUMBER_FORMAT,XPcurr),zo_strformat(SI_NUMBER_FORMAT,XPnxtCP),XPperc))
		else
			i_ctrl:SetText(string.format('%s|cDEDEDE%s|r|cA0A0CF|u2:1::/|u%s|r',ico,zo_strformat(SI_NUMBER_FORMAT,XPcurr),zo_strformat(SI_NUMBER_FORMAT,XPnxtCP)))
		end
	end
end
----------------------------------------------------------------------------------------------------
local function GetFillGrade(i_ctrl,i_invType)
	local ico=(i_invType==INVENTORY_BACKPACK) and 
		zo_iconFormat("/esoui/art/tooltips/icon_bag.dds",19,19) or
		zo_iconFormat("/esoui/art/tooltips/icon_bank.dds",19,19)
	local numUsedSlots,numSlots = PLAYER_INVENTORY:GetNumSlots(i_invType)
	if (numSlots-numUsedSlots)<=0 then
		i_ctrl:SetColor(1,0,0,1) --//red
	elseif (numSlots-numUsedSlots)<=10 then
		i_ctrl:SetColor(1,1,0,1) --//yellow
	else
		i_ctrl:SetColor(0,1,0,1) --//green
	end
	i_ctrl:SetText(string.format('%s%s|cBFBFBF|u2:1::/|u|r|cDEDEDE%s|r',ico,numUsedSlots,numSlots))
end
----------------------------------------------------------------------------------------------------
local function GetMyCurr(i_ctrl,currencyType,i_X,i_Y)
	local location=(currencyType==CURT_CHAOTIC_CREATIA or currencyType==CURT_UNDAUNTED_KEYS or 
					currencyType==CURT_EVENT_TICKETS or currencyType==CURT_ENDEAVOR_SEALS or currencyType==CURT_ENDLESS_DUNGEON) and 
					CURRENCY_LOCATION_ACCOUNT or CURRENCY_LOCATION_CHARACTER
	local currBag=GetCurrencyAmount(currencyType,location)
	local xmuteWarn,xmuteMax=450,500
	local ico=""
	local hlpTxt,hlpTxt2="",""
	--icon-mod
	if currencyType==CURT_ALLIANCE_POINTS then
		ico=GetColoredAvARankIconMarkup(GetUnitAvARank("player"),GetUnitAlliance("player"),i_X)
	else
		ico=zo_iconFormat(GetCurrencyKeyboardIcon(currencyType),i_X,i_Y)
	end
	--text-mod
	if currencyType==CURT_CHAOTIC_CREATIA then
		if IsESOPlusSubscriber() then xmuteWarn=950	xmuteMax=1000 end
		hlpTxt=string.format("|cA0A0CF|u2:1::/|u%s|r",xmuteMax)
		hlpTxt2=""
	end
	--color-mod
	if currencyType==CURT_EVENT_TICKETS and currBag>9 then 
		i_ctrl:SetColor(1,0,0,1) --//rot
	elseif currencyType==CURT_CHAOTIC_CREATIA and currBag>=xmuteWarn then	
		i_ctrl:SetColor(1,0,0,1) --//rot
	elseif currencyType==CURT_ALLIANCE_POINTS then
		i_ctrl:SetColor(.65,1,.76,1)
	else
		i_ctrl:SetColor(1,1,.76,1)
	end
	i_ctrl:SetText(string.format('%s%s|u1:0::%s|u%s',ico,hlpTxt2,zo_strformat(SI_NUMBER_FORMAT,currBag),hlpTxt))
end
----------------------------------------------------------------------------------------------------
local function GetEndeas(i_ctrl)
	local bestrebDaily,bestrebWeekly=0,0
	for i=1, GetNumTimedActivities() do
		if GetTimedActivityType(i)==TIMED_ACTIVITY_TYPE_DAILY then
			if GetTimedActivityProgress(i)==GetTimedActivityMaxProgress(i) then bestrebDaily=bestrebDaily+1 end
		elseif GetTimedActivityType(i)==TIMED_ACTIVITY_TYPE_WEEKLY then
			if GetTimedActivityProgress(i)==GetTimedActivityMaxProgress(i) then bestrebWeekly=bestrebWeekly+1 end
		end
	end
	local c1=(bestrebDaily==3) and '00FF00' or 'FF0000' --//grün or rot
	local c2=(bestrebWeekly==1) and '00FF00' or 'FF0000' --//grün or rot
	i_ctrl:SetColor(.75,.75,.75,1) --//grau
	i_ctrl:SetText(string.format(" (|c%s%s/3|r)|u1:1::|u[|c%s%s/1|r]",c1,bestrebDaily,c2,bestrebWeekly))
end
----------------------------------------------------------------------------------------------------
local function GetKrusch(i_ctrl,i_id,i_X,i_Y)
	local ico=zo_iconFormat(ttb.cntItem[i_id].icon,i_X,i_Y)
	local invCnt,bankCnt,crftBagCnt=GetItemLinkStacks(ttb.cntItem[i_id].lnk)
	if invCnt==0 then
		i_ctrl:SetColor(1,.7,.7,1)		--//#FFB3B3 //255,179,179 //hell-rot
	elseif i_id==54200 then
		i_ctrl:SetColor(.76,.56,.94,1)	--//#C28FF0 //194,143,240 //hell-lila
	else
		i_ctrl:SetColor(.87,.87,.87,1)	--//#DEDEDE //222,222,222 //hell-grau
	end
	i_ctrl:SetText(string.format('%s%s',ico,invCnt))
end
----------------------------------------------------------------------------------------------------
local function GetGearCon(i_ctrl)
	local ico=" "
	local cost=0; 
	for pSlot=0,GetBagSize(0),1 do cost=cost+GetItemRepairCost(0,pSlot); end
	if cost==0 then 
		i_ctrl:SetColor(1,1,.76,.5)
		cost=" ~"; 
		ico=zo_iconFormat("/esoui/art/repair/inventory_tabicon_repair_disabled.dds", 22,21)
	else 
		if cost>=1000 then i_ctrl:SetColor(1,0,0,1) else i_ctrl:SetColor(.8,.8,.66,1) end --//#CCCCAA //204,204,170
		cost=string.format("%s g",zo_strformat(SI_NUMBER_FORMAT,cost))
		ico=zo_iconFormat("/esoui/art/repair/inventory_tabicon_repair_up.dds", 22,21)
	end
	i_ctrl:SetText(string.format("%s%s",ico,cost))
end
----------------------------------------------------------------------------------------------------
local function GetDlyLogin(i_ctrl)
	local ico
	if GetDailyLoginClaimableRewardIndex()==nil then
		ico="|cCCCCCC|t24:24:/esoui/art/screens_app/gamepad/gp_screensapp_ouroboros.dds:inheritcolor|t|r"
		if ttb.dbP.accList[ttb.accSrvName] then ttb.dbP.accList[ttb.accSrvName].claimed=GetTimeStamp() end
	else
		ico="|cFF0000|t24:24:/esoui/art/screens_app/gamepad/gp_screensapp_ouroboros.dds:inheritcolor|t|r"
	end
	i_ctrl:SetText(ico)
end
----------------------------------------------------------------------------------------------------
local function GetDlyLoginTooltip(accName,i_X,i_Y)
	local _c,ico=" "," "
	if ttb.dbP.accList[accName] and ttb.dbP.accList[accName].claimed>0 then --wir haben was in den SavedVars
		if ttb.srv=="EU" then
			local diff=zo_floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1641006000)/(24*60*60))
			local todayReset=1641006000+(diff*24*60*60) --04:00 (UTC+1)
			if ttb.dbP.accList[accName].claimed>=todayReset then _c="dis" end
		else
			local diff=zo_floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1641031200)/(24*60*60))
			local todayReset=1641031200+(diff*24*60*60) --11:00 (UTC+1)
			if ttb.dbP.accList[accName].claimed>=todayReset then _c="dis" end
		end
	end
	if _c=="dis" then
		--ico="|cCCCCCC|t24:24:/esoui/art/screens_app/gamepad/gp_screensapp_ouroboros.dds:inheritcolor|t|r" --gray
		ico="|c00FF00|t24:24:/esoui/art/screens_app/gamepad/gp_screensapp_ouroboros.dds:inheritcolor|t|r" --green
	else
		ico="|cFF0000|t24:24:/esoui/art/screens_app/gamepad/gp_screensapp_ouroboros.dds:inheritcolor|t|r" --red
	end
	return ico
end
----------------------------------------------------------------------------------------------------
local function GetWrits(i_ctrl,i_charname,i_X,i_Y)
	local _c,ico=" "," "
	if ttb.dbA.charList[i_charname].writsDone and ttb.dbA.charList[i_charname].writsDone>0 then --wir haben was in den SavedVars
		if ttb.srv=="EU" then
			local diff=zo_floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1641006000)/(24*60*60)) --1538200800
			local todayReset=1641006000+(diff*24*60*60) --05:00 (UTC+2)
			if ttb.dbA.charList[i_charname].writsDone>=todayReset then _c="dis" end
		else
			local diff=zo_floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1641031200)/(24*60*60)) --1538200800
			local todayReset=1641031200+(diff*24*60*60) --11:00 (UTC+1)
			if ttb.dbA.charList[i_charname].writsDone>=todayReset then _c="dis" end
		end
	end
	if _c=="dis" then
		ico=ttb.colors.c_disabled:Colorize(zo_iconFormatInheritColor("/esoui/art/icons/mapkey/mapkey_crafting.dds",i_X,i_Y))
	else
		ico=ttb.colors.c_red_todo:Colorize(zo_iconFormatInheritColor("/esoui/art/icons/mapkey/mapkey_crafting.dds",i_X,i_Y))
	end
	if i_ctrl~=false then i_ctrl:SetText(ico) else return ico end
end
----------------------------------------------------------------------------------------------------
local function GetSilent(i_ctrl,i_charname,i_X,i_Y)
	local _c,ico=" "," "
	if ttb.dbA.charList[i_charname].stiller and ttb.dbA.charList[i_charname].stiller>1 then --wir haben zeit in den SavedVars
		if ttb.srv=="EU" then
			local diff=zo_floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1641006000)/(24*60*60)) --1538200800
			local todayReset=1641006000+(diff*24*60*60) --05:00 (UTC+2)
			if ttb.dbA.charList[i_charname].stiller>=todayReset then _c="dis" end
		else
			local diff=zo_floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1641031200)/(24*60*60)) --1538200800
			local todayReset=1641031200+(diff*24*60*60) --11:00 (UTC+1)
			if ttb.dbA.charList[i_charname].stiller>=todayReset then _c="dis" end
		end
	elseif ttb.dbA.charList[i_charname].stiller and ttb.dbA.charList[i_charname].stiller==1 then
		_c="not"
	end
	if _c=="dis" then
		ico=ttb.colors.c_disabled:Colorize(zo_iconFormatInheritColor("/esoui/art/icons/mapkey/mapkey_darkbrotherhood.dds",i_X,i_Y))
	elseif _c=="not" then
		ttb.doReadSilent=false
		ico=ttb.colors.c_no_avail:Colorize(zo_iconFormatInheritColor("/esoui/art/icons/mapkey/mapkey_darkbrotherhood.dds",i_X,i_Y))
	else
		ico=ttb.colors.c_red_todo:Colorize(zo_iconFormatInheritColor("/esoui/art/icons/mapkey/mapkey_darkbrotherhood.dds",i_X,i_Y))
	end
	if i_ctrl~=false then i_ctrl:SetText(ico) else return ico end
end
----------------------------------------------------------------------------------------------------
local function GetDraguard(i_ctrl)
	local _c,ico=" "," "
	local X,Y=20,23
	local todayReset
	if ttb.dbA.dragonGuard and ttb.dbA.dragonGuard>1 then --wir haben zeit in den SavedVars
		if ttb.srv=="EU" then
			local diff=zo_floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1641006000)/(24*60*60))
			todayReset=1641006000+(diff*24*60*60) --05:00 (UTC+2)
		else
			local diff=zo_floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1641031200)/(24*60*60))
			todayReset=1641031200+(diff*24*60*60) --05:00 (UTC+2)
		end
		if ttb.dbA.dragonGuard>=todayReset then
			_c="dis" --on CD
		else
			if ttb.dbA.newMoon>0 then --wir haben was in den SavedVars
				if ttb.dbA.newMoon>=GetTimeStamp() then _c="yell" end --on CD
			end
		end
	elseif ttb.dbA.dragonGuard==1 then
		_c="not"
	end
	if _c=="dis" then --chest not up
		ico=ttb.colors.c_disabled:Colorize(zo_iconFormatInheritColor("/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_dragonguard.dds",X,Y))
	elseif _c=="yell" then --chest up, but motif on cd
		ico=ttb.colors.c_yellow:Colorize(zo_iconFormatInheritColor("/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_dragonguard.dds",X,Y))
	elseif _c=="not" then --does not own dragonhold
		ttb.doReadDragon=false
		ico=ttb.colors.c_no_avail:Colorize(zo_iconFormatInheritColor("/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_dragonguard.dds",X,Y))
	else
		ico=ttb.colors.c_red_todo:Colorize(zo_iconFormatInheritColor("/esoui/art/treeicons/gamepad/gp_tutorial_idexicon_dragonguard.dds",X,Y))
	end
	if i_ctrl~=false then i_ctrl:SetText(ico) else return ico end
end
----------------------------------------------------------------------------------------------------
--[[
local function GetAnnihil(i_ctrl)
	local _c,ico=" "," "
	local X,Y=30,23
	--if ttb.dbA.annihil and ttb.dbA.annihil>1 then --wir haben zeit in den SavedVars
	--	if ttb.dbA.annihil>=GetTimeStamp() then _c="dis" end --on CD
	--elseif ttb.dbA.annihil and ttb.dbA.annihil==1 then
	--	_c="not"
	--end
	if ttb.dbA.annihil and ttb.dbA.annihil>1 then --wir haben was in den SavedVars
		local diff=zo_floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1538200800)/(24*60*60))
		local todayReset=1538200800+(diff*24*60*60) --07:00 (UTC+1)
		if ttb.dbA.annihil>=todayReset then _c="dis" end
	elseif ttb.dbA.annihil and ttb.dbA.annihil==1 then
		_c="not"
	end	
	--/script d(zo_iconFormat("/esoui/art/treeicons/gamepad/gp_lorelibrary_categoryicon_daedric.dds", 34,21))
	if _c=="dis" then
		ico=ttb.colors.c_disabled:Colorize(zo_iconFormatInheritColor("/esoui/art/treeicons/gamepad/gp_lorelibrary_categoryicon_daedric.dds",X,Y))
	elseif _c=="not" then --does not own deadlands
		ttb.doReadAnnihil=false
		ico=ttb.colors.c_no_avail:Colorize(zo_iconFormatInheritColor("/esoui/art/treeicons/gamepad/gp_lorelibrary_categoryicon_daedric.dds",X,Y))
	else
		ico=ttb.colors.c_red_todo:Colorize(zo_iconFormatInheritColor("/esoui/art/treeicons/gamepad/gp_lorelibrary_categoryicon_daedric.dds",X,Y))
	end
	if i_ctrl~=false then i_ctrl:SetText(ico) else return ico end
end
]]
----------------------------------------------------------------------------------------------------
local function GetStable(i_ctrl)
	local _c,ico=" "," "
	local tstr
	local myInv,maxInv,myStam,maxStam,myV,maxV=GetRidingStats()
	--if ttb.dbA.showDebug then d("GetRidingStats "..myInv.."/"..maxInv.." - "..myStam.."/"..maxStam.." - "..myV.."/"..maxV) end
	if myInv~=60 or myStam~=60 or myV~=60 then
		local t=GetTimeUntilCanBeTrained()	--t=(1000*60*60*6)+(1000*60*4)
		_c=(t<=180000) and "red" or "grn"		
		tstr=ZO_FormatTime(t/1000,TIME_FORMAT_STYLE_SHOW_LARGEST_UNIT,TIME_FORMAT_PRECISION_TWELVE_HOUR_NO_SECONDS,TIME_FORMAT_DIRECTION_DESCENDING)
	end
	if _c=="red" then
		ico=ttb.colors.c_red_todo:Colorize(zo_iconFormatInheritColor("/esoui/art/icons/servicemappins/servicepin_stable.dds",26,26))
		i_ctrl:SetColor(.8,.13,.13,1) --//#CC2222 //204,34,34
		i_ctrl:SetText(string.format("%s%s",ico,tostring(tstr)))
		ttb.doReadMount=true
		--if ttb.dbA.charList[ttb.charName].mountFeed==1 then ttb.dbA.charList[ttb.charName].mountFeed=GetTimeStamp() end --Pferd wurde mal fälschlichwerweise als fertig angezeigt?
	elseif _c=="grn" then
		ico=ttb.colors.c_green_ok:Colorize(zo_iconFormatInheritColor("/esoui/art/icons/servicemappins/servicepin_stable.dds",26,26))
		i_ctrl:SetColor(.8,.8,.66,1)  --//#CCCCAA //204,204,170
		i_ctrl:SetText(string.format("%s%s",ico,tostring(tstr)))
		ttb.doReadMount=true
		--if ttb.dbA.charList[ttb.charName].mountFeed==1 then ttb.dbA.charList[ttb.charName].mountFeed=GetTimeStamp()+GetTimeUntilCanBeTrained() end --Pferd wurde mal fälschlichwerweise als fertig angezeigt?
	else
		ttb.doReadMount=false
		ttb.dbA.charList[ttb.charName].mountFeed=1
		ico=ttb.colors.c_disabled:Colorize(zo_iconFormatInheritColor("/esoui/art/icons/servicemappins/servicepin_stable.dds",26,26))
		i_ctrl:SetText(ico)
	end
end
----------------------------------------------------------------------------------------------------
local function GetMeriIC(i_ctrl)
	local _c,ico=" "," "
	if ttb.dbA.meritenIC and ttb.dbA.meritenIC>0 then --wir haben zeit in den SavedVars
		if ttb.dbA.meritenIC>=GetTimeStamp() then _c="dis" end --on CD
	end
	if _c=="dis" then
		ico=ttb.colors.c_disabled:Colorize(zo_iconFormatInheritColor("/esoui/art/compass/ava_imperialcity_neutral.dds",32,30))
	else
		ico=ttb.colors.c_red_todo:Colorize(zo_iconFormatInheritColor("/esoui/art/compass/ava_imperialcity_neutral.dds",32,30))
	end
	if i_ctrl~=false then i_ctrl:SetText(ico) else return ico end
end
----------------------------------------------------------------------------------------------------
local function GetStableTooltip(i_charname,i_X,i_Y)
	local _c,ico=" "," "
	if ttb.dbA.charList[i_charname].mountFeed and ttb.dbA.charList[i_charname].mountFeed>0 then --wir haben was in den SavedVars
		if ttb.dbA.charList[i_charname].mountFeed==1 then --maxLvl
			_c="dis"
		else --zeitstempel
			--if ttb.dbA.charList[i_charname].mountFeed>=GetTimeStamp() then _c="grn"	end --on CD
			if ttb.srv=="EU" then
				local diff=zo_floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1641006000)/(24*60*60)) --1538200800
				local todayReset=1641006000+(diff*24*60*60) --05:00 (UTC+2)
				if ttb.dbA.charList[i_charname].mountFeed>=todayReset then _c="grn" end --on CD
			else
				local diff=zo_floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1641031200)/(24*60*60)) --1538200800
				local todayReset=1641031200+(diff*24*60*60) --05:00 (UTC+2)
				if ttb.dbA.charList[i_charname].mountFeed>=todayReset then _c="grn" end --on CD
			end
		end
	end
	if _c=="dis" then
		ico=ttb.colors.c_disabled:Colorize(zo_iconFormatInheritColor("/esoui/art/icons/servicemappins/servicepin_stable.dds",i_X,i_Y))
	elseif _c=="grn" then
		ico=ttb.colors.c_green_ok:Colorize(zo_iconFormatInheritColor("/esoui/art/icons/servicemappins/servicepin_stable.dds",i_X,i_Y))
	else
		ico=ttb.colors.c_red_todo:Colorize(zo_iconFormatInheritColor("/esoui/art/icons/servicemappins/servicepin_stable.dds",i_X,i_Y))
	end
	return ico
end
----------------------------------------------------------------------------------------------------
local function GetStolen(i_ctrl)
	local ico=""
	local bag=SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK)
	local stolenItems=0
	for _, data in pairs(bag) do
		if IsItemStolen(data.bagId,data.slotIndex) then 
			stolenItems=stolenItems+GetSlotStackSize(data.bagId,data.slotIndex) 
		end
	end
	local maxSell,curSell,_=GetFenceSellTransactionInfo()
	local maxLaun,curLaun,_=GetFenceLaunderTransactionInfo()
	local canSell=maxSell-curSell
	local canLaun=maxLaun-curLaun
	local combined=""
	if stolenItems>0 then
		stolenItems=tostring(stolenItems)
		ico=ttb.colors.c_red_todo:Colorize(zo_iconFormatInheritColor("/esoui/art/inventory/inventory_stolenitem_icon.dds",20,20))
		if canSell~=maxSell or canLaun~=maxLaun then combined=string.format("|c999999|u1:0::(%s/%s)|u|r",canSell,canLaun) end
	else
		stolenItems=""
		--ico=ttb.colors.c_disabled:Colorize(zo_iconFormatInheritColor("/esoui/art/inventory/inventory_stolenitem_icon.dds",18,18))
		ico=zo_iconFormat("/aTim99_Tbar/img/inventory_stolenitem_icon.dds",20,20)
	end
	i_ctrl:SetText(string.format("%s|cCCCCAA%s|r%s",ico,stolenItems,combined))
end
----------------------------------------------------------------------------------------------------
local function GetCrafting(i_ctrl,craftType,icopath)
	local ico,txt="",""
	local numSlots=GetMaxSimultaneousSmithingResearch(craftType)
	local numResearchLines=GetNumSmithingResearchLines(craftType)
	local numUsedSlots=0
	local allResearched=true
	--if ttb.dbA.showDebug then d("GetCrafting numSlots="..numSlots.." / numResearchLines="..numResearchLines) end
	for researchLine=1,numResearchLines do
		local _,_,numTraits,_=GetSmithingResearchLineInfo(craftType,researchLine)
		for traitIndex=1, numTraits do
			local _,_,known=GetSmithingResearchLineTraitInfo(craftType,researchLine,traitIndex)
			if known==false then
				allResearched=false
				local totalTimeSecs,timeLeftSecs=GetSmithingResearchLineTraitTimes(craftType,researchLine,traitIndex)
				--d(tostring(totalTimeSecs) .." / "..tostring(timeLeftSecs))
				if totalTimeSecs~=nil and timeLeftSecs~=nil then numUsedSlots=numUsedSlots+1 end
			end
		end
	end
	if allResearched==true then
		if ttb.dbA.showDebug then CHAT_SYSTEM:AddMessage("GetCrafting allResearched==true") end
		ico=ttb.colors.c_disabled:Colorize(zo_iconFormatInheritColor(icopath,19,19))
		txt=ttb.colors.c_disabled:Colorize(string.format("%s/%s",numUsedSlots,numSlots))
		--if     craftType==CRAFTING_TYPE_BLACKSMITHING   then ttb.doReadSmith=false
		--elseif craftType==CRAFTING_TYPE_WOODWORKING     then ttb.doReadWoody=false
		--elseif craftType==CRAFTING_TYPE_CLOTHIER        then ttb.doReadCloth=false
		--elseif craftType==CRAFTING_TYPE_JEWELRYCRAFTING then ttb.doReadJewly=false
		--end
	else
		if numUsedSlots==numSlots then
			ico=ttb.colors.c_green_ok:Colorize(zo_iconFormatInheritColor(icopath,20,20))
			txt=ttb.colors.c_green_ok:Colorize(string.format("%s/%s",numUsedSlots,numSlots))
		else
			ico=ttb.colors.c_red_todo:Colorize(zo_iconFormatInheritColor(icopath,20,20))
			txt=ttb.colors.c_red_todo:Colorize(string.format("%s/%s",numUsedSlots,numSlots))
		end
	end
	ico=ZO_DEFAULT_TEXT:Colorize(zo_iconFormatInheritColor(icopath,19,19))
	--ico=zo_iconFormat(icopath,19,19)
	i_ctrl:SetText(string.format("%s%s|r",ico,txt))
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function ttb.Toolbar_Update()
	--d("|c666666["..GetTimeString().."]|r Toolbar_Update Start")

	--- Zeit -------------------------------------------------
	GetTTime(TimTbarWindowInfo01)
	--- Spielerinfos -----------------------------------------
	GetNumCP(TimTbarWindowInfo03)
	GetCntXP(TimTbarWindowInfo04)
	--- Platz ------------------------------------------------
	GetFillGrade(TimTbarWindowInfo05, INVENTORY_BACKPACK)
	GetFillGrade(TimTbarWindowInfo06, INVENTORY_BANK)
	--- Währungen --------------------------------------------
	GetMyCurr(TimTbarWindowInfo07, CURT_MONEY,           17,17)
	GetMyCurr(TimTbarWindowInfo08, CURT_ALLIANCE_POINTS, 23, 0)
	GetMyCurr(TimTbarWindowInfo09, CURT_TELVAR_STONES,   21,21)
	GetMyCurr(TimTbarWindowInfo10, CURT_WRIT_VOUCHERS,   21,21)
	GetMyCurr(TimTbarWindowInfo11, CURT_EVENT_TICKETS,   21,21)
	GetMyCurr(TimTbarWindowInfo12, CURT_CHAOTIC_CREATIA, 18,18)
	GetMyCurr(TimTbarWindowInfo13, CURT_UNDAUNTED_KEYS,  21,21)
	GetMyCurr(TimTbarWindowInfo14, CURT_ENDEAVOR_SEALS,  21,19)
	if ttb.dbA.showEndeaProg then GetEndeas(TimTbarWindowInfo15) end
	GetMyCurr(TimTbarWindowInfo16, CURT_ENDLESS_DUNGEON, 19,19)
	--- Inventar ---------------------------------------------
	GetKrusch(TimTbarWindowInfo17, 30357, 20,20)	--Lockpick
	GetKrusch(TimTbarWindowInfo18, 33271, 20,19)	--Soulgem
	GetKrusch(TimTbarWindowInfo19, 44879, 20,20)	--Repairkit
	if ttb.dbA.showSkull==true then GetKrusch(TimTbarWindowInfo20, 54200, 20,20) end	--Klappernder Schädel
	--- Zustände ---------------------------------------------
	GetGearCon(TimTbarWindowInfo21)
	--- Red Buttons ------------------------------------------
	GetWrits(TimTbarWindowInfo23, ttb.charName, 29,26)
	if ttb.dbA.showSilent==true and ttb.doReadSilent==true then GetSilent(TimTbarWindowInfo24, ttb.charName, 27,27) end
	if ttb.doReadMount==true then GetStable(TimTbarWindowInfo25) end
	if ttb.dbA.showDragon==true and ttb.doReadDragon==true then GetDraguard(TimTbarWindowInfo26) end
	--if ttb.dbA.showDeadland==true and ttb.doReadAnnihil==true then GetAnnihil(TimTbarWindowInfo27) end
	if ttb.dbA.showIC==true then GetMeriIC(TimTbarWindowInfo28) end
	GetStolen(TimTbarWindowInfo29)
	if ttb.dbA.charList[ttb.charName].showResearch==true and ttb.doReadSmith==true then GetCrafting(TimTbarWindowInfo30, CRAFTING_TYPE_BLACKSMITHING, "/esoui/art/icons/servicemappins/servicepin_smithy.dds") end
	if ttb.dbA.charList[ttb.charName].showResearch==true and ttb.doReadWoody==true then GetCrafting(TimTbarWindowInfo31, CRAFTING_TYPE_WOODWORKING, "/esoui/art/icons/servicemappins/servicepin_woodworking.dds") end
	if ttb.dbA.charList[ttb.charName].showResearch==true and ttb.doReadCloth==true then GetCrafting(TimTbarWindowInfo32, CRAFTING_TYPE_CLOTHIER, "/esoui/art/icons/servicemappins/servicepin_outfitter.dds") end
	if ttb.dbA.charList[ttb.charName].showResearch==true and ttb.doReadJewly==true then GetCrafting(TimTbarWindowInfo33, CRAFTING_TYPE_JEWELRYCRAFTING, "/esoui/art/icons/servicemappins/servicepin_jewelrycrafting.dds") end
	
	--get WeaponCon()
	--get Lowpop() ?  :(
	
	ttb.totalWidth=15
	local myControls={
		[1] =TimTbarWindowInfo01,[2] =TimTbarWindowInfo02,[3] =TimTbarWindowInfo03,[4] =TimTbarWindowInfo04,
		[5] =TimTbarWindowInfo05,[6] =TimTbarWindowInfo06,[7] =TimTbarWindowInfo07,[8] =TimTbarWindowInfo08,
		[9] =TimTbarWindowInfo09,[10]=TimTbarWindowInfo10,[11]=TimTbarWindowInfo11,[12]=TimTbarWindowInfo12,
		[13]=TimTbarWindowInfo13,[14]=TimTbarWindowInfo14,[15]=TimTbarWindowInfo15,[16]=TimTbarWindowInfo16,
		[17]=TimTbarWindowInfo17,[18]=TimTbarWindowInfo18,[19]=TimTbarWindowInfo19,[20]=TimTbarWindowInfo20,
		[21]=TimTbarWindowInfo21,[22]=TimTbarWindowInfo22,[23]=TimTbarWindowInfo23,[24]=TimTbarWindowInfo24,
		[25]=TimTbarWindowInfo25,[26]=TimTbarWindowInfo26,                         [27]=TimTbarWindowInfo28,
		[28]=TimTbarWindowInfo29,[29]=TimTbarWindowInfo30,[30]=TimTbarWindowInfo31,[31]=TimTbarWindowInfo32,[32]=TimTbarWindowInfo33,
	}
	for i,ctrl in ipairs(myControls) do
		local _, _, _, _, x, _, _=ctrl:GetAnchor(0)	
		ttb.totalWidth = ttb.totalWidth+ctrl:GetTextWidth()+x
	end
	TimTbarWindow:SetWidth(ttb.totalWidth)
	--d("|c666666["..GetTimeString().."]|r Toolbar_Update Done")
end
----------------------------------------------------------------------------------------------------
local function copy(b,c)
	if type(b)~='table'then return b end;if c and c[b]then return c[b]end;local d=c or{}
	local e=setmetatable({},getmetatable(b))d[b]=e;for f,g in pairs(b)do e[copy(f,d)]=copy(g,d)end;return e
end
----------------------------------------------------------------------------------------------------
local function UpdateToolTip(ctrl,ttip,ttipLeft,ttipRight,ttipHeader,ttipLeftDiv)
	--ctrl=TimTbarWindowInfo23, ttip=TimTbarTooltipMount
	local left,right={},{}
	local c
	ttb.charList={}
	local i=1
	for k,v in pairs(ttb.dbA.charList) do
		if k==nil then return end; ttb.charList[i]=copy(v) i=i+1
	end
	table.sort(ttb.charList,function(a,b) return a.sort<b.sort end)
	for k,v in pairs(ttb.charList) do
		c=(ttb.charList[k].name==ttb.charName) and "ffffcc" or "999999"
		if ttip==TimTbarTooltipMount and (ttb.charList[k].trackMount==nil or ttb.charList[k].trackMount) then
			table.insert(right, "|c"..c..ttb.charList[k].name.."|r")
			table.insert(left, GetStableTooltip (tostring(ttb.charList[k].name), 22,22))
		elseif ttip==TimTbarTooltipStill and ttb.charList[k].trackStiller then
			table.insert(right, "|c"..c..ttb.charList[k].name.."|r")
			table.insert(left, GetSilent (false,tostring(ttb.charList[k].name), 23,23))
		elseif ttip==TimTbarTooltipWrits and ttb.charList[k].trackWrit then
			table.insert(right, "|c"..c..ttb.charList[k].name.."|r")
			table.insert(left, GetWrits	(false,tostring(ttb.charList[k].name), 26,23))
		end
	end
	-- d("ttipLeft="..tostring(ttip:GetNamedChild(ttip:GetName().."Left"))) --nil NIL NILNILNIL
	ttipLeft:SetText(table.concat(left,"\n"))
	ttipRight:SetText(table.concat(right,"\n"))
	ttip:SetHeight(ttipRight:GetHeight()+ttipHeader:GetHeight()+ttipLeftDiv:GetHeight()+10)
	ttip:SetWidth(ttipLeft:GetWidth()+ttipRight:GetWidth()+20)
	ttip:SetAnchor(TOP,ctrl,BOTTOM,0,20)
end
----------------------------------------------------------------------------------------------------
local function UpdateToolTipLogin()
	local left,mid,right={},{},{}
	local c,ch
	ttb.accList={}
	local i=1
	for k,v in pairs(ttb.dbP.accList) do
		if k==nil then return end; ttb.accList[i]=copy(v) i=i+1
	end
	table.sort(ttb.accList,function(a,b) return a.sort<b.sort end)
	for k,v in pairs(ttb.accList) do
		local srv=string.sub(ttb.accList[k].name,1,2)
		ch=(srv=="EU") and "|c999999" or "|c666666"	--make a small difference between server
		c=(ttb.accList[k].name==ttb.accSrvName) and "|cFFFFCC" or ch --current login acc 
		table.insert(left, GetDlyLoginTooltip (tostring(ttb.accList[k].name),22,22))
		table.insert(mid, c..string.sub(ttb.accList[k].name,1,2).."|r")
		table.insert(right, c..string.sub(ttb.accList[k].name,3).."|r")
	end
	TimTbarTooltipLoginLeft:SetText(table.concat(left,"\n"))
	TimTbarTooltipLoginMiddle:SetText(table.concat(mid,"\n"))
	TimTbarTooltipLoginRight:SetText(table.concat(right,"\n"))
	TimTbarTooltipLogin:SetHeight(TimTbarTooltipLoginRight:GetHeight()+TimTbarTooltipLoginHeader:GetHeight()+TimTbarTooltipLoginDivider:GetHeight()+10)
	TimTbarTooltipLogin:SetWidth(TimTbarTooltipLoginLeft:GetWidth()+TimTbarTooltipLoginMiddle:GetWidth()+TimTbarTooltipLoginRight:GetWidth()+30)
	TimTbarTooltipLogin:SetAnchor(TOP,TimTbarWindowInfo22,BOTTOM,0,20)
end
----------------------------------------------------------------------------------------------------
local function OnLootUpdated(eventCode)
	EVENT_MANAGER:UnregisterForEvent(ttb.name, EVENT_LOOT_UPDATED)
	LOOT_SHARED:LootAllItems()
end
----------------------------------------------------------------------------------------------------
local function OnOutlawlootReceived(eventCode,receivedBy,itemName,quantity,soundCategory,lootType,self,isPickpocketLoot,questItemIcon,itemId,isStolen)
	if self~=true then return end --not mine
	--itemId=itemId or GetItemLinkItemId(itemName)
	local hasSet,setName,_, _, _,setId=GetItemLinkSetInfo(itemName,false)
	if (hasSet==true and setId==245) or --Sithis' Touch
	   (itemId==79675  or				--Toxin Satchel / möglich:Vergiftetes Blut
		itemId==79677  or				--Assa Potion Kit
		itemId==71779  or				--Kopfgeld 500
		itemId==73754  or				--Kopfgeld 2k
		itemId==79504  or				--Unmarked Sack / enthält:"Monk's Disguise"
		itemId==121058 or				--Kerzen der Stille
		itemId==119938 or				--Licht und Schattn
		itemId==119952					--Sacrifi Heart
	   ) then
		local mNpcName="Remains-Silent"
		local myLang=GetCVar("language.2")
		if     myLang=='de' then mNpcName="Schweigt-still"
		elseif myLang=='ru' then mNpcName="Хранит-Молчание"
		elseif myLang=='fr' then mNpcName="Garde-le-Silence"
		end
		CHAT_SYSTEM:AddMessage(string.format("|c666666[%s]|r |c9B30FF\"%s\" -> Cooldown restarted.|r",GetTimeString(),mNpcName))
		ttb.dbA.charList[ttb.charName].stiller=GetTimeStamp()-- +(20*60*60)--cd=20h
		ttb.doReadSilent=true
		if ttb.dbA.showSilent==true then GetSilent	(TimTbarWindowInfo24, ttb.charName, 27,27) end
		--autoloot container
		if itemId==79675 or itemId==79677 or itemId==79504 then
			EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_LOOT_UPDATED, OnLootUpdated)
			zo_callLater(function() 
				for slot_id=0,GetBagSize(BAG_BACKPACK) do
					local id=GetItemId(BAG_BACKPACK,slot_id)
					if id==itemId then
						if IsProtectedFunction("UseItem") then CallSecureProtected("UseItem",BAG_BACKPACK,slot_id) else UseItem(BAG_BACKPACK,slot_id) end
					end
				end
			end,500)
		end
	elseif itemId==79332 then --"Monk's Disguise" from container |H1:item:79332:5:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h
		if ttb.dbA.charList[ttb.charName].destroyMonk==true then
			for slot_id=0,GetBagSize(BAG_BACKPACK) do
				local id=GetItemId(BAG_BACKPACK,slot_id)
				if id==79332 then
					EquipItem(BAG_BACKPACK,slot_id,EQUIP_SLOT_COSTUME)
					zo_callLater(function()UnequipItem(EQUIP_SLOT_COSTUME)end,1500)
					return
				end
			end
		end
	end
end
----------------------------------------------------------------------------------------------------
local function OnOutlawChatterBegin(eventCode,optionCount)
	local _,NPCname=GetGameCameraInteractableActionInfo()
	--d("NPCname = ["..tostring(NPCname).."]")
	--sometimes we just get nil instead of a remainssilent-name? :(
	if NPCname==nil or NPCname=="" or isRemainsSilent[NPCname] then
		EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_CHATTER_END, function()
			EVENT_MANAGER:UnregisterForEvent(ttb.name, EVENT_CHATTER_END)
			--EVENT_MANAGER:UnregisterForEvent(ttb.name, EVENT_LOOT_RECEIVED) //now in PlayerActivated because of "Monk's Disguise"
		end)
		EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_LOOT_RECEIVED, OnOutlawlootReceived)
			EVENT_MANAGER:AddFilterForEvent(ttb.name, EVENT_LOOT_RECEIVED, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
			EVENT_MANAGER:AddFilterForEvent(ttb.name, EVENT_LOOT_RECEIVED, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DEFAULT)
			EVENT_MANAGER:AddFilterForEvent(ttb.name, EVENT_LOOT_RECEIVED, REGISTER_FILTER_IS_NEW_ITEM, true)
	end
end
----------------------------------------------------------------------------------------------------
local function OnDragonGuardLootReceived(eventCode,receivedBy,itemName,quantity,soundCategory,lootType,self,isPickpocketLoot,questItemIcon,itemId,isStolen)
	if self~=true then return end --not mine
	itemId=itemId or GetItemLinkItemId(itemName) --GetValidItemStyleId(81)--new moon
	if itemId>=156609 and itemId<=156622 then --new moon
		ttb.dbA.newMoon=GetTimeStamp()+(24*60*60)--cd=24h
		if ttb.dbA.showDragon==true then GetDraguard (TimTbarWindowInfo26) end
	end
end
----------------------------------------------------------------------------------------------------
local function OnDragonGuardInteract(_,result,targetname)
	if result~=CLIENT_INTERACT_RESULT_SUCCESS then return end
	if targetname=="Drachengarde-Vorratstruhe^f" or targetname=="Dragonguard Supply Chest" then
		ttb.dbA.dragonGuard=GetTimeStamp()
		if ttb.dbA.showDragon==true then GetDraguard (TimTbarWindowInfo26) end
	end
end
----------------------------------------------------------------------------------------------------
--[[
local function OnDeadlandPortalLootReceived(eventCode,receivedBy,itemName,quantity,soundCategory,lootType,self,isPickpocketLoot,questItemIcon,itemId,isStolen)
	if self~=true then return end --not mine
	itemId=itemId or GetItemLinkItemId(itemName)
	if itemId>=178528 and itemId<=178542 then --annihil
		--ttb.dbA.annihil=GetTimeStamp()+(24*60*60)--cd=20h
		ttb.dbA.annihil=GetTimeStamp()
		if ttb.dbA.showDeadland==true then GetAnnihil (TimTbarWindowInfo27) end
	end
end
]]
----------------------------------------------------------------------------------------------------
local function OnSewersLootReceived(eventCode,receivedBy,itemName,quantity,soundCategory,lootType,self,isPickpocketLoot,questItemIcon,itemId,isStolen)
	if self~=true then return end --not mine
	itemId=itemId or GetItemLinkItemId(itemName)
	if itemId==151939 then --|H1:item:151939:5:50:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h	[Meriten der Belagerung von Cyrodiil]
		ttb.dbA.meritenIC=GetTimeStamp()+(20*60*60)--cd=24h (?)
		if ttb.dbA.showIC==true then GetMeriIC   (TimTbarWindowInfo28) end
	end
end
----------------------------------------------------------------------------------------------------
local function OnQuestComplete(eventCode,questName,level,previousExperience,currentExperience,championPoints,questType,instanceDisplayType)
	--soll keine wissenschaft werden, nur ein icon rot oder grau färben wenn man heute eine davon gemacht hat
	if questType==QUEST_TYPE_CRAFTING then
		if  questName=="Schneiderschrieb"	or questName=="Schmiedeschrieb"    or questName=="Schreinerschrieb" or questName=="Schmuckhandwerksschrieb" or
			questName=="Verzaubererschrieb"	or questName=="Alchemistenschrieb" or questName=="Versorgerschrieb" or
			questName=="Clothier Writ"		or questName=="Blacksmith Writ"    or questName=="Woodworker Writ"  or questName=="Jewelry Crafting Writ"   or
			questName=="Enchanter Writ"		or questName=="Alchemist Writ"     or questName=="Provisioner Writ" 
		    --add french and russian here if someone complains ^^
		then
			--no matter which one, icon should be gray as soon as you finished one of them
			ttb.dbA.charList[ttb.charName].writsDone=GetTimeStamp()
			GetWrits	(TimTbarWindowInfo23, ttb.charName, 29,26)
		end
	end
end
----------------------------------------------------------------------------------------------------
local function OnMountFeed(eventCode,ridingSkillType,previous,current,source)
	local myInv,maxInv,myStam,maxStam,myV,maxV=GetRidingStats()
	if myInv==60 and myStam==60 and myV==60 then
		ttb.dbA.charList[ttb.charName].mountFeed=1
	else
		ttb.dbA.charList[ttb.charName].mountFeed=GetTimeStamp()-- +(20*60*60)--cd=20h
	end
	GetStable(TimTbarWindowInfo25)
end
----------------------------------------------------------------------------------------------------
local function OnSkillLineAddded(eventCode,skillType,skillIndex,advised)
	--CHAT_SYSTEM:AddMessage("|c666666[Tbar]|r skill line addded") --werewolf/vamp
	ttb.GetStaticInfos(TimTbarWindowInfo02, TimTbarWindowAllianzL, TimTbarWindowAllianzR)
end
----------------------------------------------------------------------------------------------------
local function OnRewardAvail(eventCode)
	CHAT_SYSTEM:AddMessage("|c666666[Tbar]|r new daily loginreward available")
	GetDlyLogin (TimTbarWindowInfo22)
end
----------------------------------------------------------------------------------------------------
local function OnLoginClaimed(eventCode)
	if string.sub(ttb.accSrvName,1,2)~="PT" then ttb.dbP.accList[ttb.accSrvName].claimed=GetTimeStamp() end
	GetDlyLogin (TimTbarWindowInfo22)
end
----------------------------------------------------------------------------------------------------
local function OnCurrencyUpdate(event,currencyType,currencyLocation,newAmount,oldAmount,reason)
	if currencyType==CURT_MONEY then
		GetMyCurr(TimTbarWindowInfo07, currencyType, 17,17)
	elseif currencyType==CURT_ALLIANCE_POINTS then
		GetMyCurr(TimTbarWindowInfo08, currencyType, 23, 0)
	elseif currencyType==CURT_WRIT_VOUCHERS then
		GetMyCurr(TimTbarWindowInfo10, currencyType, 21,21)
	elseif currencyType==CURT_CHAOTIC_CREATIA then
		GetMyCurr(TimTbarWindowInfo12, currencyType, 18,18)
	elseif currencyType==CURT_UNDAUNTED_KEYS then
		GetMyCurr(TimTbarWindowInfo13, currencyType, 21,21)
	elseif currencyType==CURT_EVENT_TICKETS then
		GetMyCurr(TimTbarWindowInfo11, currencyType, 21,21)
	elseif currencyType==CURT_ENDEAVOR_SEALS then
		GetMyCurr(TimTbarWindowInfo14, currencyType, 21,19)
		GetEndeas(TimTbarWindowInfo15)
	elseif currencyType==CURT_TELVAR_STONES then
		GetMyCurr(TimTbarWindowInfo09, currencyType, 21,21)
	elseif currencyType==CURT_ENDLESS_DUNGEON then
		GetMyCurr(TimTbarWindowInfo16, currencyType, 19,19)
	end
end
----------------------------------------------------------------------------------------------------
local function ShowToolTipWrits() UpdateToolTip(TimTbarWindowInfo23,TimTbarTooltipWrits,TimTbarTooltipWritsLeft,TimTbarTooltipWritsRight,TimTbarTooltipWritsHeader,TimTbarTooltipWritsDivider) TimTbarTooltipWrits:SetHidden(false) end
aTim99_Tbar.ShowToolTipWrits = ShowToolTipWrits
local function HideTooltipWrits() TimTbarTooltipWrits:SetHidden(true) end
aTim99_Tbar.HideTooltipWrits = HideTooltipWrits
local function ShowToolTipStill() UpdateToolTip(TimTbarWindowInfo24,TimTbarTooltipStill,TimTbarTooltipStillLeft,TimTbarTooltipStillRight,TimTbarTooltipStillHeader,TimTbarTooltipStillDivider) TimTbarTooltipStill:SetHidden(false) end
aTim99_Tbar.ShowToolTipStill = ShowToolTipStill
local function HideTooltipStill() TimTbarTooltipStill:SetHidden(true) end
aTim99_Tbar.HideTooltipStill = HideTooltipStill
local function ShowToolTipMount() UpdateToolTip(TimTbarWindowInfo25,TimTbarTooltipMount,TimTbarTooltipMountLeft,TimTbarTooltipMountRight,TimTbarTooltipMountHeader,TimTbarTooltipMountDivider) TimTbarTooltipMount:SetHidden(false) end
aTim99_Tbar.ShowToolTipMount = ShowToolTipMount
local function HideTooltipMount() TimTbarTooltipMount:SetHidden(true) end
aTim99_Tbar.HideTooltipMount = HideTooltipMount
local function ShowToolTipLogin() UpdateToolTipLogin() TimTbarTooltipLogin:SetHidden(false) end
aTim99_Tbar.ShowToolTipLogin = ShowToolTipLogin
local function HideTooltipLogin() TimTbarTooltipLogin:SetHidden(true) end
aTim99_Tbar.HideTooltipLogin = HideTooltipLogin
----------------------------------------------------------------------------------------------------
local function SendData()
	local myStr=""
	local myPre="/p "..ttb.prefix
	if ttb.toggleShare==false then 
		myStr=table.concat(ttb.allSvData1,",") 
	else 
		myStr=table.concat(ttb.allSvData2,",") 
	end
	--myStr=myStr:gsub("%EU@", "E@")
	--myStr=myStr:gsub("%NA@", "N@")
	if string.len(myStr)>0 and string.len(myStr)<=343 then --343 max?
		CHAT_SYSTEM:AddMessage(string.format("|c00ff55 sending... message len = %s / 343|r", string.len(myStr))) 
		StartChatInput(myPre..myStr)
	else
		CHAT_SYSTEM:AddMessage(string.format("|cFF5050 not sent: message len to long ( %s / 343 )|r", string.len(myStr)))
	end
end
----------------------------------------------------------------------------------------------------
local function ShareLoginClData(self,button,upInside,ctrlkey,alt,shiftkey)
	--[[
	--for playing on different pcs
	if button==MOUSE_BUTTON_INDEX_RIGHT and upInside==true then
		if IsUnitGrouped("player") then
			if GetGroupSize()==2 then
				local myStr=""
				local myStrLen,allStrLen1,allStrLen2=0,4,4
				ttb.allSvData1={}
				ttb.allSvData2={}
				for k,v in pairs(ttb.dbP.accList) do
					--two should be enough, so just toogle
					myStr=string.format("%s=%s", ttb.dbP.accList[k].name, ttb.dbP.accList[k].claimed)
					myStrLen=string.len(myStr)+1
					if allStrLen1+myStrLen < 343 then
						table.insert(ttb.allSvData1, myStr)
						allStrLen1=allStrLen1+myStrLen
					elseif allStrLen2+myStrLen < 343 then
						table.insert(ttb.allSvData2, myStr)
						allStrLen2=allStrLen2+myStrLen
					else
						--if this really happens, we need sth.completely different 
						CHAT_SYSTEM:AddMessage("|cff0000I'm not prepared for this sh***...|r")
						return
					end
				end
				ttb.toggleShare=false
				SendData()
			else
				CHAT_SYSTEM:AddMessage("|cff0000 only share in a group of 2...|r")
			end
		else
			CHAT_SYSTEM:AddMessage("|cff0000 not in a group, can not share...|r")
		end
	]]
	if button==MOUSE_BUTTON_INDEX_LEFT and upInside==true then
		local sumGeholt = GetDailyLoginNumRewardsClaimedInMonth() --5
		local sumMonth = GetNumRewardsInCurrentDailyLoginMonth() --31
		local sumInsgStillPossible = GetNumClaimableDailyLoginRewardsInCurrentMonth() --30
		local sumVerpasst = sumMonth-sumInsgStillPossible
		local sumLeft = sumMonth-sumGeholt-sumVerpasst --25
		local isClaimedToday =(GetDailyLoginClaimableRewardIndex()==nil and true) or false
		local function getData(id,cnt)
			local isCurr=false
			local icon=""
			local rwdCurr=GetAddCurrencyRewardInfo(id)
			if rwdCurr==CURT_MONEY or rwdCurr==CURT_TELVAR_STONES or rwdCurr==CURT_ALLIANCE_POINTS then
				isCurr=true
				icon=ZO_Currency_FormatPlatform(rwdCurr,cnt,ZO_CURRENCY_FORMAT_AMOUNT_ICON)
			end
			return isCurr,icon
		end
		if isClaimedToday==false then
			local mDay=GetDailyLoginClaimableRewardIndex()
			ClaimCurrentDailyLoginReward()
			local rewardId,quantity,isMilestone=GetDailyLoginRewardInfoForCurrentMonth(mDay)
			local isCurr,icon=getData(rewardId,quantity)
			if isCurr==true then
				CHAT_SYSTEM:AddMessage(string.format("|c666666[%s]|r |c9B30FF[Tbar] has claimed|r %s.",GetTimeString(),icon)) --quantity
			else
				CHAT_SYSTEM:AddMessage(string.format("|c666666[%s]|r |c9B30FF[Tbar] has claimed the daily login reward (|rsome crap|c9B30FF).|r",GetTimeString()))
			end
		else
			SCENE_MANAGER:Show('dailyLoginRewards')
		end
		--CHAT_SYSTEM:AddMessage(string.format("|c9B30FF[Tbar] Stats: Month (you) [|r%s|c9B30FF] - Month (all) [|r%s|c9B30FF] - Missed [|r%s|c9B30FF] - Left [|r%s|c9B30FF]|r",tostring(sumGeholt),tostring(sumMonth),tostring(sumVerpasst),tostring(sumLeft)))
		for i=1,sumMonth do
			local rewardId,quantity,isMilestone=GetDailyLoginRewardInfoForCurrentMonth(i)
			if isMilestone==true then
				local isCurr,icon=getData(rewardId,quantity)
				if isCurr==true and (sumLeft+sumGeholt)>=i and (i-sumGeholt)>0 then
					CHAT_SYSTEM:AddMessage(string.format("|c9B30FF[Tbar]|r The %s in day %s are still possible! (%sx todo)",icon,i,(i-sumGeholt)))
				end
			end
		end
	end
end
aTim99_Tbar.ShareLoginClData = ShareLoginClData
----------------------------------------------------------------------------------------------------
local function OnChatMessageChannel(eventCode,channelType,fromName,text,isCustomerService,fromDisplayName)
	if channelType==CHAT_CHANNEL_PARTY and ttb.dbP.trusted[fromDisplayName] and string.sub(text,1,string.len(ttb.prefix))==ttb.prefix then
		if fromDisplayName==ttb.displayName then
			--sender
			if ttb.toggleShare==false then ttb.toggleShare=true SendData() end return 
		else
			--receiver
			local newMsg=string.sub(text,string.len(ttb.prefix)+1) --remove ttb.prefix
			local mSkip=0
			for str in string.gmatch(newMsg, "([^,]+)") do --split on comma
				local myPosDiv=string.find(str, "=")
				local accName=string.sub(str,1,myPosDiv-1) --prefix till equal sign
				--accName=accName:gsub("%E@","EU@")
				--accName=accName:gsub("%N@","NA@")
				local myTimeStamp=string.sub(str,myPosDiv+1) --suffix from equal sign
				if tonumber(myTimeStamp)==nil then CHAT_SYSTEM:AddMessage("error in tonumber") return else myTimeStamp=tonumber(myTimeStamp) end
				if ttb.dbP.accList[accName] then
					--entry exists, update if new value is younger
					if myTimeStamp>ttb.dbP.accList[accName].claimed then
						ttb.dbP.accList[accName].claimed=myTimeStamp
						CHAT_SYSTEM:AddMessage(string.format("|c00ff55-> update: %s [%s]|r",accName,myTimeStamp))
					else
						mSkip=mSkip+1
					end
				else
					--entry not exists, insert
					ttb.dbP.accList[accName]={}
					ttb.dbP.accList[accName].name=accName
					ttb.dbP.accList[accName].claimed=tonumber(myTimeStamp)
					ttb.dbP.accList[accName].sort=99
					CHAT_SYSTEM:AddMessage(string.format("|c3399FF-> insert: %s [%s]|r",accName,myTimeStamp))
				end
			end
			if mSkip>0 then CHAT_SYSTEM:AddMessage(string.format("|cFF5050-> skipped (old): # %s|r",tostring(mSkip))) end
		end
	end
end				
----------------------------------------------------------------------------------------------------
local function isInTrustedParty()
	local isInTrustedPartyof2=false
	local members=GetGroupSize()
	if members==2 then --maybe extend?
		for i=1,members do
			local unitTag=GetGroupUnitTagByIndex(i)
			if unitTag and string.sub(unitTag,0,5)=="group" then
				local accName=GetUnitDisplayName(unitTag)	
				if accName~=ttb.displayName and ttb.dbP.trusted[accName] then
					isInTrustedPartyof2=true
				end
			end
		end
	end
	return isInTrustedPartyof2
end
----------------------------------------------------------------------------------------------------
local function OnGroupMemberJoined(eventCode,memberCharacterName,memberDisplayName,isLocalPlayer)
	if isInTrustedParty()==true and not ttb.isRegistered3 then
		--d("|c9B30FFOnGroupMemberJoined, trusted  -  würde listener starten|r")
		--EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_CHAT_MESSAGE_CHANNEL, OnChatMessageChannel)
		ttb.isRegistered3=true
	elseif isInTrustedParty()==false and ttb.isRegistered3 then
		--d("|c9B30FFOnGroupMemberJoined, not trusted or too much  -  würde listener stoppen|r")
		--EVENT_MANAGER:UnregisterForEvent(ttb.name, EVENT_CHAT_MESSAGE_CHANNEL)
		ttb.isRegistered3=false
	end
end
----------------------------------------------------------------------------------------------------
local function OnGroupMemberLeft(eventCode,memberCharacterName,reason,isLocalPlayer,isLeader,memberDisplayName,actionRequiredVote)
	if ttb.isRegistered3 then --no checks, just stop
		--d("|c9B30FFOnGroupMemberLeft  -  würde listener stoppen|r") 
		--EVENT_MANAGER:UnregisterForEvent(ttb.name, EVENT_CHAT_MESSAGE_CHANNEL)
		ttb.isRegistered3=false
	end
end
----------------------------------------------------------------------------------------------------
--[[
local function OnCampaignSelectionDataChanged()
	local newLowPopEP,newLowPopDC,newLowPopAD
	QueryCampaignSelectionData()
	QueryCampaignLeaderboardData()
	local cId=GetAssignedCampaignId()
	local cName=GetCampaignName(cId)
	
	local newLowPopEP=IsUnderpopBonusEnabled(cId,ALLIANCE_EBONHEART_PACT)
	d("LowPop ALLIANCE_EBONHEART_PACT = "..tostring(newLowPopEP))
	if ttb.lowPopEP~=newLowPopEP then 
		if newLowPopEP==true then 
			CHAT_SYSTEM:AddMessage(string.format("|c666666[toolbar] [%s]|r |c9B30FF LowPop EP in %s !|r",GetTimeString(),cName))
		else
			CHAT_SYSTEM:AddMessage(string.format("|c666666[toolbar] [%s]|r |c9B30FF EP lost LowPop in %s !|r",GetTimeString(),cName))
		end
	end
	ttb.lowPopEP=newLowPopEP
	
	local newLowPopDC=IsUnderpopBonusEnabled(cId,ALLIANCE_DAGGERFALL_COVENANT)
	d("LowPop ALLIANCE_DAGGERFALL_COVENANT = "..tostring(newLowPopDC))
	if ttb.lowPopDC~=newLowPopDC then 
		if newLowPopDC==true then 
			CHAT_SYSTEM:AddMessage(string.format("|c666666[toolbar] [%s]|r |c9B30FF LowPop DC in %s !|r",GetTimeString(),cName))
		else
			CHAT_SYSTEM:AddMessage(string.format("|c666666[toolbar] [%s]|r |c9B30FF DC lost LowPop in %s !|r",GetTimeString(),cName))
		end
	end
	ttb.lowPopDC=newLowPopDC

	local newLowPopAD=IsUnderpopBonusEnabled(cId,ALLIANCE_ALDMERI_DOMINION)
	d("LowPop ALLIANCE_ALDMERI_DOMINION = "..tostring(newLowPopAD))
	if ttb.lowPopAD~=newLowPopAD then 
		if newLowPopAD==true then 
			CHAT_SYSTEM:AddMessage(string.format("|c666666[toolbar] [%s]|r |c9B30FF LowPop AD in %s !|r",GetTimeString(),cName))
		else
			CHAT_SYSTEM:AddMessage(string.format("|c666666[toolbar] [%s]|r |c9B30FF AD lost LowPop in %s !|r",GetTimeString(),cName))
		end
	end
	ttb.lowPopAD=newLowPopAD

end
--]]
----------------------------------------------------------------------------------------------------
function ttb.setOffset(fragment,offset,show)
	local label=WINDOW_MANAGER:GetControlByName(fragment)
	if label then
		local relTo=select(3,label:GetAnchor(0))
		if show then
			label:SetHidden(false)
			label:ClearAnchors()
			label:SetAnchor(TOPLEFT,relTo,TOPRIGHT,offset,0)
			label:SetAnchor(BOTTOMLEFT,relTo,BOTTOMRIGHT,offset,0)
		else
			label:SetHidden(true)
			label:ClearAnchors()
			label:SetAnchor(TOPLEFT,relTo,TOPRIGHT,0,0)
			label:SetAnchor(BOTTOMLEFT,relTo,BOTTOMRIGHT,0,0)
			label:SetText("")
		end
	end
end
----------------------------------------------------------------------------------------------------
function ttb.playerActivated()
	--just once (login/reload)
	if ttb.firstRun == 0 then
		ttb.firstRun = 1
		local refreshSeconds = ttb.dbA.refreshTime * 1000
		zo_callLater(function()
			--compass and targetframe
			ZO_CompassFrame:ClearAnchors()
			ZO_CompassFrame:SetAnchor(TOP, GuiRoot, TOP,0, (TimTbarWindow:GetTop()+60))
			local ZO_Func = COMPASS_FRAME['ApplyStyle']
			COMPASS_FRAME['ApplyStyle']=function(self)
				local result = ZO_Func(self)
				local frame = _G['ZO_CompassFrame']
				frame:ClearAnchors()
				frame:SetAnchor(TOP, GuiRoot, TOP, 0, (TimTbarWindow:GetTop()+60))
				return result
			end
			ZO_TargetUnitFramereticleover:ClearAnchors()
			ZO_TargetUnitFramereticleover:SetAnchor(TOP, ZO_CompassFrame, BOTTOM, 0, 30)
			--vanilla game bar
			ZO_MainMenu:ClearAnchors()
			ZO_MainMenu:SetAnchor (TOP,GuiRoot,TOP,0,30)
			ZO_MainMenuCategoryBarButton1RemainingCrowns:ClearAnchors()	--(Symbol, ESO PLUS, Kronen)
			ZO_MainMenuCategoryBarButton1RemainingCrowns:SetAnchor (RIGHT,ZO_MainMenuCategoryBarButton1,LEFT,-20,7)
			ZO_MainMenuCategoryBarButton1Membership:ClearAnchors()		--(Symbol, ESP PLUS)
			ZO_MainMenuCategoryBarButton1Membership:SetAnchor (BOTTOMRIGHT,ZO_MainMenuCategoryBarButton1RemainingCrowns,TOPRIGHT,0,3)
			ZO_MainMenuCategoryBarButton1Image:ClearAnchors()			--image Kronenshop
			ZO_MainMenuCategoryBarButton1Image:SetAnchor (CENTER,ZO_MainMenuCategoryBarButton1,CENTER,0,5)
			ZO_MainMenuCategoryBarButton2Image:ClearAnchors()			--image Kronenkisten
			ZO_MainMenuCategoryBarButton2Image:SetAnchor (CENTER,ZO_MainMenuCategoryBarButton2,CENTER,0,5)
			--static stats
			ttb.GetStaticInfos	(TimTbarWindowInfo02, TimTbarWindowAllianzL, TimTbarWindowAllianzR)
			GetDlyLogin (TimTbarWindowInfo22)
			if ttb.dbA.hideTheTruth==false then RedirectTexture("esoui/art/mappins/ava_largekeep_aldmeri.dds","aTim99_Tbar/img/keep.dds") end
			if ttb.dbA.dragonGuard and ttb.dbA.dragonGuard <= 1 then ttb.dbA.dragonGuard = select(5,GetCollectibleInfo(6920)) and 0 or 1 end 	--still not?
			if ttb.dbA.annihil and ttb.dbA.annihil <= 1 then ttb.dbA.annihil = select(5,GetCollectibleInfo(9365)) and 0 or 1 end 				--still not?
			if ttb.dbA.charList[ttb.charName].stiller and ttb.dbA.charList[ttb.charName].stiller<=1 then ttb.dbA.charList[ttb.charName].stiller = select(6,GetSkillAbilityInfo(5,2,4)) and 0 or 1 end --still not?
			--check listener for login reward sharing
			if isInTrustedParty()==true and not ttb.isRegistered3 then
				--d("|c9B30FFplayerActivatedInGroup, trusted  -  würde listener starten|r")
				--EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_CHAT_MESSAGE_CHANNEL, OnChatMessageChannel)
				ttb.isRegistered3=true
			end
			--Set offset
			ttb.setOffset("TimTbarWindowInfo20", ttb.offsets.skull, ttb.dbA.showSkull)
			ttb.setOffset("TimTbarWindowInfo24", ttb.offsets.silent, ttb.dbA.showSilent)
			ttb.setOffset("TimTbarWindowInfo26", ttb.offsets.dragon, ttb.dbA.showDragon)
			--ttb.setOffset("TimTbarWindowInfo27", ttb.offsets.deadlands, ttb.dbA.showDeadland)
			ttb.setOffset("TimTbarWindowInfo28", ttb.offsets.ic, ttb.dbA.showIC)
			ttb.setOffset("TimTbarWindowInfo30", ttb.offsets.research1, ttb.dbA.charList[ttb.charName].showResearch)
			ttb.setOffset("TimTbarWindowInfo31", ttb.offsets.research23, ttb.dbA.charList[ttb.charName].showResearch)
			ttb.setOffset("TimTbarWindowInfo32", ttb.offsets.research23, ttb.dbA.charList[ttb.charName].showResearch)
			ttb.setOffset("TimTbarWindowInfo33", ttb.offsets.research4, ttb.dbA.charList[ttb.charName].showResearch)
			
			--Update timer starten
			ttb.Toolbar_Update()
			EVENT_MANAGER:RegisterForUpdate("Toolbar_Update", refreshSeconds, ttb.Toolbar_Update)
			--OnCampaignSelectionDataChanged()
			--QueryCampaignSelectionData()
			--QueryCampaignLeaderboardData()
			--EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_CAMPAIGN_SELECTION_DATA_CHANGED, OnCampaignSelectionDataChanged)
			--CAMPAIGN_BROWSER_MANAGER:RegisterCallback("OnCampaignDataUpdated", OnCampaignSelectionDataChanged)
			--EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_RANK_POINT_UPDATE, QueryCampaignLeaderboardData)
			--EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_CAMPAIGN_LEADERBOARD_DATA_CHANGED, QueryCampaignLeaderboardData)
			--EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_CAMPAIGN_SCORE_DATA_CHANGED, QueryCampaignLeaderboardData)
		end, 1000)
	end

	--immer (login/reload/zonenwechsel etc)
	local ZoneId = GetZoneId(GetCurrentMapZoneIndex())
	if IsInOutlawZone() then
		if not ttb.isRegistered then
			EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_CHATTER_BEGIN, OnOutlawChatterBegin)
			ttb.isRegistered=true
		end
	else
		if ttb.isRegistered then
			EVENT_MANAGER:UnregisterForEvent(ttb.name, EVENT_CHATTER_BEGIN)
			EVENT_MANAGER:UnregisterForEvent(ttb.name, EVENT_LOOT_RECEIVED)
			ttb.isRegistered=false
		end
	end
	if ZoneId==1146 then --Gezeiteninsel
		if not ttb.isRegistered2 then
			EVENT_MANAGER:RegisterForEvent("aTim99_Tbar_DG", EVENT_LOOT_RECEIVED, OnDragonGuardLootReceived)
			EVENT_MANAGER:AddFilterForEvent("aTim99_Tbar_DG", EVENT_LOOT_RECEIVED, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
			EVENT_MANAGER:AddFilterForEvent("aTim99_Tbar_DG", EVENT_LOOT_RECEIVED, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DEFAULT)
			EVENT_MANAGER:AddFilterForEvent("aTim99_Tbar_DG", EVENT_LOOT_RECEIVED, REGISTER_FILTER_IS_NEW_ITEM, true)
			EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_CLIENT_INTERACT_RESULT, OnDragonGuardInteract)
			ttb.isRegistered2=true
		end
	else
		if ttb.isRegistered2 then
			EVENT_MANAGER:UnregisterForEvent("aTim99_Tbar_DG", EVENT_LOOT_RECEIVED)
			EVENT_MANAGER:UnregisterForEvent(ttb.name, EVENT_CLIENT_INTERACT_RESULT)
			ttb.isRegistered2=false
		end
	end
	if ZoneId==643 or ZoneId==643 or ZoneId==643 then --Imperial City Sewers
	    --you need to be there when opening coffer, but i dont want to check millions of loot outside due to performance?
		if not ttb.isRegistered4 then
			EVENT_MANAGER:RegisterForEvent("aTim99_Tbar_IC", EVENT_LOOT_RECEIVED, OnSewersLootReceived)
			EVENT_MANAGER:AddFilterForEvent("aTim99_Tbar_IC", EVENT_LOOT_RECEIVED, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
			EVENT_MANAGER:AddFilterForEvent("aTim99_Tbar_IC", EVENT_LOOT_RECEIVED, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DEFAULT)
			EVENT_MANAGER:AddFilterForEvent("aTim99_Tbar_IC", EVENT_LOOT_RECEIVED, REGISTER_FILTER_IS_NEW_ITEM, true)
			ttb.isRegistered4=true
		end
	else
		if ttb.isRegistered4 then
			EVENT_MANAGER:UnregisterForEvent("aTim99_Tbar_IC", EVENT_LOOT_RECEIVED)
			ttb.isRegistered4=false
		end
	end
	--[[
	if ZoneId==1261 then --Deadlands Portal
		if not ttb.isRegistered5 then
			EVENT_MANAGER:RegisterForEvent("aTim99_Tbar_DP", EVENT_LOOT_RECEIVED, OnDeadlandPortalLootReceived)
			EVENT_MANAGER:AddFilterForEvent("aTim99_Tbar_DP", EVENT_LOOT_RECEIVED, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
			EVENT_MANAGER:AddFilterForEvent("aTim99_Tbar_DP", EVENT_LOOT_RECEIVED, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DEFAULT)
			EVENT_MANAGER:AddFilterForEvent("aTim99_Tbar_DP", EVENT_LOOT_RECEIVED, REGISTER_FILTER_IS_NEW_ITEM, true)
			ttb.isRegistered5=true
		end
	else
		if ttb.isRegistered5 then
			EVENT_MANAGER:UnregisterForEvent("aTim99_Tbar_DP", EVENT_LOOT_RECEIVED)
			ttb.isRegistered5=false
		end
	end
	]]
end
----------------------------------------------------------------------------------------------------
function ttb.addonLoaded(event, addonName)
	if addonName ~= ttb.name then return end
	EVENT_MANAGER:UnregisterForEvent(ttb.name, EVENT_ADD_ON_LOADED)
	EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_PLAYER_ACTIVATED, ttb.playerActivated)
	
	ttb.dbA = ZO_SavedVars:NewAccountWide("TimTbarSettings", 1, nil, ttb.svDefAcc, GetWorldName())
	ttb.dbP = ZO_SavedVars:NewAccountWide("LieberBreitAlsWide", 1, "¥CharacterWide", ttb.svDefPc, "ŁComputerWide", "€ServerWide")
	if ttb.displayName=="@dmin666" then ttb.dbP.accList["EU@tïm'99"]=nil ttb.dbP.accList["NA@tïm'99"]=nil end
	if ttb.displayName=="@tïm'99" then ttb.dbP.accList["EU@dmin666"]=nil ttb.dbP.accList["NA@dmin666"]=nil end
	ttb.dbP.trusted[ttb.displayName]=true
	
	ttb.initMenu()
	
	EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_QUEST_COMPLETE, OnQuestComplete)                  --crafting daily
	EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_RIDING_SKILL_IMPROVEMENT, OnMountFeed)            --mount upgrade
	EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_SKILL_LINE_ADDED, OnSkillLineAddded)              --werewolf/vamp icon
	EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_NEW_DAILY_LOGIN_REWARD_AVAILABLE, OnRewardAvail)  --login reward reset
	EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_DAILY_LOGIN_REWARDS_CLAIMED, OnLoginClaimed)      --login reward claimed
	EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_CURRENCY_UPDATE, OnCurrencyUpdate)

	if ttb.dbA.upOrDown ~= 1 then
		if TimTbarWindow and TimTbarWindow~=nil then
			TimTbarWindow:ClearAnchors()
			TimTbarWindow:SetAnchor(ttb.dbA.upOrDown, GUI_ROOT, ttb.dbA.upOrDown, 0, 0)
		end
	end
	
	--need more testing
	--EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_GROUP_MEMBER_JOINED, OnGroupMemberJoined)
	--EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_GROUP_MEMBER_LEFT, OnGroupMemberLeft)
	
	--[[  seems not to work
	EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_CAMPAIGN_UNDERPOP_BONUS_CHANGE_NOTIFICATION, function(eventCode, campaignId)
		--d("GetAssignedCampaignId "..GetAssignedCampaignId())								--102
		--d("GetCampaignName "..GetCampaignName(102))										--Graue Schar
		--d("GetSecsUntilCampaignEnd "..GetSecondsUntilCampaignEnd(102))					--0, nach öffnen richtig
		--d("GetSecsUntilUnderdogReeva "..GetSecondsUntilCampaignUnderdogReevaluation(102))	--?, nach öffnen: 98
		--d("GetPlayerCampaignRewardTierInfo "..GetPlayerCampaignRewardTierInfo(102))		--?, nach öffnen: 25000
		--d("IsUnderpopBonusEnabled "..IsUnderpopBonusEnabled(102, 2))						--?, nach öffnen: false
		local col=(campaignId==GetAssignedCampaignId()) and '00FF00' or 'FF0000'
		d("EVENT_CAMPAIGN_UNDERPOP_BONUS_CHANGE_NOTIFICATION in |c"..col..GetCampaignName(campaignId).."|r")
	end)
	--]]
	
	--Slash Commands
	SLASH_COMMANDS['/tbar']=function(n)
		if n==nil or n=="" or n==" " then
			CHAT_SYSTEM:AddMessage('|c9B30FF*******************************|r')
			CHAT_SYSTEM:AddMessage('|c9B30FF [TimTbar]  Usage-Help:|r')
			CHAT_SYSTEM:AddMessage('|c9B30FF 1)|r   |cFFFFFF/tbar|r SEC |c666666=(e.g:|r |cFFFFFF/tbar 3|r|c666666) frequency of updating toolbar|r')
			CHAT_SYSTEM:AddMessage('|c9B30FF 2)|r   |cFFFFFF/tbar on|r |c666666= switch on toolbar|r')
			CHAT_SYSTEM:AddMessage('|c9B30FF 3)|r   |cFFFFFF/tbar off|r |c666666= switch off toolbar|r')
			CHAT_SYSTEM:AddMessage('|c9B30FF 4)|r   |cFFFFFF/tbar silent|r |c666666= shows time for supplier|r')
			CHAT_SYSTEM:AddMessage('|c9B30FF 5)|r   |cFFFFFF/tbar mount|r |c666666= shows time for mount-feed|r')
			CHAT_SYSTEM:AddMessage('|c9B30FF 6)|r   |cFFFFFF/tbar motif|r |c666666= shows time for newmoon|r')
			CHAT_SYSTEM:AddMessage('|c9B30FF 7)|r   |cFFFFFF/tbar buff|r |c666666= shows mundus and curses|r')
			CHAT_SYSTEM:AddMessage('|c9B30FF*******************************|r')
			CHAT_SYSTEM:AddMessage(string.format("|c666666[%s]|r |c9B30FF[TimTbar]|r  current reload-time in sec = |cFFFFFF%s|r",GetTimeString(),ttb.dbA.refreshTime))
		elseif n=="on" then EVENT_MANAGER:RegisterForUpdate("Toolbar_Update", refreshSeconds, ttb.Toolbar_Update); CHAT_SYSTEM:AddMessage("Tbar switched on")
		elseif n=="off" then EVENT_MANAGER:UnregisterForUpdate("Toolbar_Update"); CHAT_SYSTEM:AddMessage("Tbar switched off")
		elseif n=="silent" then if ttb.dbA.charList[ttb.charName].stiller>1 then CHAT_SYSTEM:AddMessage(string.format("|c666666[%s]|r |c9B30FF[TimTbar]|r  shadowy supplier lootable at:  |cFFFFFF%s|r",GetTimeString(),GetNiceTime(ttb.dbA.charList[ttb.charName].stiller)))end
		elseif n=="mount" then if ttb.dbA.charList[ttb.charName].mountFeed>1 then CHAT_SYSTEM:AddMessage(string.format("|c666666[%s]|r |c9B30FF[TimTbar]|r  mount feedable at:  |cFFFFFF%s|r",GetTimeString(),GetNiceTime(ttb.dbA.charList[ttb.charName].mountFeed)))end
		elseif n=="motif" then if ttb.dbA.dragonGuard>1 then CHAT_SYSTEM:AddMessage(string.format("|c666666[%s]|r |c9B30FF[TimTbar]|r  dragonguard-chest looted at:  |cFFFFFF%s|r",GetTimeString(),GetNiceTime(ttb.dbA.dragonGuard)))end; if ttb.dbA.newMoon>1 then CHAT_SYSTEM:AddMessage(string.format("|c666666[%s]|r |c9B30FF[TimTbar]|r  new-moon cooldown till:  |cFFFFFF%s|r",GetTimeString(),GetNiceTime(ttb.dbA.newMoon)))end
		elseif n=="buff" then local PRE local numBuffs=GetNumBuffs("player") for i = 1, numBuffs do local buffName,_,_,_,_,iconFilename,buffType,effectType,abilityType,_,abilityId,_,_=GetUnitBuffInfo("player",i) if abilityId==13974 or abilityId==13975 or abilityId==13976 or abilityId==13977 or abilityId==13978 or abilityId==13979 or abilityId==13980 or abilityId==13981 or abilityId==13982 or abilityId==13984 or abilityId==13985 or abilityId==13940 or abilityId==13943 then PRE="Mundus" --[[ABILITY_TYPE_BONUS=5]]	elseif abilityId==135397 or abilityId==135399 or abilityId==135400 or abilityId==135402 then PRE="Vampire" --[[ABILITY_TYPE_VAMPIRE=45]] elseif abilityId==35658 or abilityId==40521 or abilityId==40525 then  PRE="Werewolf" --[[ABILITY_TYPE_BONUS=5]] else PRE=false end if PRE then CHAT_SYSTEM:AddMessage(zo_strformat('<<1>> |c9B30FF<<2>>:|r |cFFFFFF<<3>>|r |c666666[typ <<4>>; id <<5>>]|r',zo_iconFormat(iconFilename,20,20),PRE,buffName,abilityType,abilityId)) end end
		elseif n=="xp" then if not IsUnitChampion('player') then CHAT_SYSTEM:AddMessage("not working mate. try to be better...") return end local totalSumXP=0 local myCP = GetPlayerChampionPointsEarned() for i=0,myCP-1 do totalSumXP=totalSumXP+GetNumChampionXPInChampionPoint(i) end local myXpinCurrCP=GetPlayerChampionXP() totalSumXP=totalSumXP+myXpinCurrCP CHAT_SYSTEM:AddMessage(string.format("|c666666[%s]|r |c9B30FFtotal xp sum for:|r%s|cC9BC0Fcp|r|cFFFFCC%s|r:  |c00ffff%s|r %s",GetTimeString(),zo_iconFormat("/esoui/art/mainmenu/menubar_champion_up.dds",27,27),myCP,zo_strformat(SI_NUMBER_FORMAT,totalSumXP),zo_iconFormat("/esoui/art/icons/icon_experience.dds",17,17)))
		elseif type(n)=='number' then
			ttb.dbA.refreshTime=n;
			CHAT_SYSTEM:AddMessage(string.format("|c666666[%s]|r |c9B30FF[TimTbar]|r  current reload-time in sec = |cFFFFFF%s|r",GetTimeString(),ttb.dbA.refreshTime))
		else
			CHAT_SYSTEM:AddMessage(string.format("|c666666[%s]|r |c9B30FF[TimTbar]|r  WTF is |cFFFFFF%s|r ???",GetTimeString(),tostring(n)))
		end
	end
	SLASH_COMMANDS['/tbar_hide_the_truth']=function() CHAT_SYSTEM:AddMessage("|c666666[Tbar]|r |c9B30FFOk, the truth will be hidden, but deep in your heart you still know it ;)") ttb.dbA.hideTheTruth=true ttb.GetStaticInfos(TimTbarWindowInfo02, TimTbarWindowAllianzL, TimTbarWindowAllianzR) end
	SLASH_COMMANDS['/tbar_show_the_truth']=function() CHAT_SYSTEM:AddMessage("|c666666[Tbar]|r |c9B30FFHere we go. The other option is just like lying to yourself.") ttb.dbA.hideTheTruth=false ttb.GetStaticInfos(TimTbarWindowInfo02, TimTbarWindowAllianzL, TimTbarWindowAllianzR) end
	SLASH_COMMANDS['/tbar_move_up']=function() ttb.dbA.upOrDown=1 TimTbarWindow:ClearAnchors() TimTbarWindow:SetAnchor(1,GUI_ROOT,1,0,0) CHAT_SYSTEM:AddMessage("|c666666[Tbar]|r |c9B30FF Yay!") end
	SLASH_COMMANDS['/tbar_move_down']=function() ttb.dbA.upOrDown=4 TimTbarWindow:ClearAnchors() TimTbarWindow:SetAnchor(4,GUI_ROOT,4,0,0) CHAT_SYSTEM:AddMessage("|c666666[Tbar]|r |c9B30FF Pooh!") end
	
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(ttb.name, EVENT_ADD_ON_LOADED, ttb.addonLoaded)
