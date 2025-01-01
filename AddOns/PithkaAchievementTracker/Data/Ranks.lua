-- Initialize File
PITHKA = PITHKA or {}
PITHKA.Data = PITHKA.Data or {}
PITHKA.Data.Ranks = {}


------------------------------------------------------------------------------------------------------------------
-- LOGIC FUNCTIONS
------------------------------------------------------------------------------------------------------------------
-- returns true if account has atleast n complete from arr
local function ANY(arr, n)
	local count = 0
	n = n or 1
	for _, aid in ipairs(arr) do
		if IsAchievementComplete(aid) then
			count = count + 1
		end
	end
	return count >= n
end

-- returns true if account has all complete from arr
local function ALL(arr)
	for _, aid in ipairs(arr) do 
		if not IsAchievementComplete(aid) then
			return false
		end
	end
	return true
end

local function COUNT(arr)
	local c = 0
	for _, aid in ipairs(arr) do
		if IsAchievementComplete(aid) then
			c = c +1
		end
	end
	return c
end


-- concats two tables using ipairs
local function CONCAT(t1, t2)
    for _,r in ipairs(t2) do t1[#t1+1] = r end
    return t1
end

------------------------------------------------------------------------------------------------------------------
-- CONVENIENCE LOOKUPS
------------------------------------------------------------------------------------------------------------------
-- shortcut
local _DBF = PITHKA.Data.Achievements.DBFilter

-- individual
local vHRC   = _DBF({ABBV='HRC'}, 'VET')
local vHRCHM = _DBF({ABBV='HRC'}, 'HM')

local vAA    = _DBF({ABBV='AA'}, 'VET')
local vAAHM  = _DBF({ABBV='AA'}, 'HM')

local vSO    = _DBF({ABBV='SO'}, 'VET')
local vSOHM  = _DBF({ABBV='SO'}, 'HM')

local vMOL   = _DBF({ABBV='MOL'}, 'VET')
local vMOLHM = _DBF({ABBV='MOL'}, 'HM')

local vHOF   = _DBF({ABBV='HOF'}, 'VET')
local vHOFHM = _DBF({ABBV='HOF'}, 'HM')

local vSS    = _DBF({ABBV='SS'}, 'VET')
local vSSa   = _DBF({ABBV='SS'}, 'PHM1')
local vSSb   = _DBF({ABBV='SS'}, 'PHM2')
local vSSHM  = _DBF({ABBV='SS'}, 'HM')

local vKA    = _DBF({ABBV='KA'}, 'VET')
local vKAa   = _DBF({ABBV='KA'}, 'PHM1')
local vKAb   = _DBF({ABBV='KA'}, 'PHM2')
local vKAHM  = _DBF({ABBV='KA'}, 'HM')

local vRG    = _DBF({ABBV='RG'}, 'VET')
local vRGa   = _DBF({ABBV='RG'}, 'PHM1')
local vRGb   = _DBF({ABBV='RG'}, 'PHM2')
local vRGHM  = _DBF({ABBV='RG'}, 'HM')

local vCR    = _DBF({ABBV='CR'}, 'VET')
local vCR1   = _DBF({ABBV='CR'}, 'PHM1')
local vCR2   = _DBF({ABBV='CR'}, 'PHM2')
local vCR3   = _DBF({ABBV='CR'}, 'HM')

local vAS    = _DBF({ABBV='AS'}, 'VET')
local vAS1a  = _DBF({ABBV='AS'}, 'PHM1')
local vAS1b  = _DBF({ABBV='AS'}, 'PHM2')
local vAS2   = _DBF({ABBV='AS'}, 'HM')


-- trial lists 
local tVET = _DBF({TYPE='trial'}, 'VET')
local tHM  = _DBF({TYPE='trial'}, 'HM')
local tTRI = _DBF({TYPE='trial'}, 'TRI')
local tPHM = CONCAT(_DBF({TYPE='trial'}, 'PHM1'), _DBF({TYPE='trial'}, 'PHM2'))

-- dlc filtersonly
local tVETDLC = _DBF({TYPE='trial', DLC=true}, 'VET')
local tHMDLC  = _DBF({TYPE='trial', DLC=true}, 'HM')
local tHMNOTDLC = _DBF({TYPE='trial', DLC=false}, 'HM')

-- 4 man lists
local UNCHAINED	 = _DBF({ABBV='BRP', TYPE='arena'}, 'TRI')
local dVET = _DBF({TYPE='dungeon'}, 'VET')
local dHM  = _DBF({TYPE='dungeon'}, 'HM')
local dCHA = _DBF({TYPE='dungeon'}, 'CHA')
local dTRI = _DBF({TYPE='dungeon'}, 'TRI')
local aTRI = _DBF({TYPE='arena'}, 'TRI')

-- arena list
local vMA = _DBF({ABBV='MSA'}, 'VET')
local vVH = _DBF({ABBV='VSA'}, 'VET')


------------------------------------------------------------------------------------------------------------------
-- SUMMARIES
------------------------------------------------------------------------------------------------------------------

-- given t of [idx] = {'RANKNAME', fn}
function PITHKA.Data.Ranks.summaryCalc(prefix, t)
	local best
	for _, row in ipairs(t) do
		local rank = row[1]
		local fn = row[2]
		if fn() then
			best = rank
		else
			return '|H1:guild:680699|h'.. prefix ..'|h '.. best
		end
	end
	return '|H1:guild:680699|h'.. prefix ..'|h '.. best
end


PITHKA.Data.Ranks.summaries = {
	['~ Trial Summary ~'] = {
		text = function() return 
			COUNT(tVET)  .. ' of ' .. #tVET .. ' Veterans  ||  ' ..
			COUNT(tHM)   .. ' of ' .. #tHM  .. ' Hard Modes  ||  ' ..
			COUNT(tTRI)  .. ' of ' .. #tTRI .. ' Trial Trifectas  '
			end,
		tt = function() return nil end,
	},

	['One More Pull'] = {
		text = function() return PITHKA.Data.Ranks.summaryCalc('One More Pull', {
		    {'Beginner'     , function() return true end},
		    {'Greenhorn'    , function() return ALL({vCR1}) end}, --ANY(tVETDLC,3) and ALL({vCR1}) and ANY({vAS1a, vAS1b}, 1) end},
		    {'Journeyman'   , function() return ANY(tHMDLC, 2) and ALL({vCR2}) end},
		    {'Veteran'      , function() return ANY(tHMDLC, 5) and ALL({vAS2, vCR3}) end},
		    {'Master'       , function() return ALL(tHM) end},
		    {'Perfectionist', function() return ALL(tTRI) end},
			}) end,
		tt = function() return 'RANKS\n\n'..
            'Beginner       starting rank\n'..
            'Greenhorn      vCR+1, vAS+1, and 3 Vets\n'..
            'Journeyman     vCR+2, and 2 HMs\n'..
            'Veteran        vCR+3, vAS+2, and 3 HMs\n'..
            'Master         all HMs\n' ..
            'Perfectionist  all Trifectas\n' ..
            '\n**only DLC trials count for ranking'
        	end,
		},

    ['The Grand Alliance'] = {
		text = function() return PITHKA.Data.Ranks.summaryCalc('The Grand Alliance', {
			{'Craglornian'     , function() return true end},
		    {'Appentice'       , function() return ANY(tHM, 3) end},
			{'Tier 3'          , function() return ANY(tHM, 6) end},
		    {'Tier 2'          , function() return ANY(tHM, 8) end},
		    {'Tier 1'          , function() return ANY(tHM, 9) and ANY(tTRI,2) end},
			{'The Hallowed'	   , function() return ANY(tTRI,5) end},
			}) end,
		tt = function() return 'RANKS\n\n'..
            'Craglornian       starting rank\n' ..
            'Apprentice        3 HMs\n' ..
            'Tier 3            6 HMs\n' ..
            'Tier 2            8 HMs\n' ..
            'Tier 1            9 HMs and 2 Tris\n'  ..
            'The Hallowed      5 Trifectas'
        	end
		},

	['Evolve'] = {
		text = function() return PITHKA.Data.Ranks.summaryCalc('Evolve', {
			{'Initiate', function() return true end},
			{'Adept'   , function() return ANY(tVETDLC, 4) end},
			{'Raider'  , function() return ANY(tVETDLC, 5) and ANY(tHMDLC, 1) end},
			{'Knight'  , function() return ANY(tVETDLC, 6) and ANY(tHMDLC, 3) end},
			{'Champion', function() return ANY(tVETDLC, 7) and ANY(tHMDLC, 5) end},
			{'Hero'    , function() return ANY(tVETDLC, 8) and ANY(tHMDLC, 6) and ANY(tTRI, 1) end},
			{'Legend'  , function() return ANY(tVETDLC, 8) and ANY(tHMDLC, 6) and ANY(tTRI, 4) end},
			{'Mythic'  , function() return ANY(tVETDLC, 8) and ANY(tHMDLC, 8) and ANY(tTRI, 6) end},
			{'Godlike' , function() return ANY(tVETDLC, 8) and ANY(tHMDLC, 8) and ANY(tTRI, 8) end},
			}) end,
		tt = function() return 'RANKS\n\n'..
			'Initiate - Starting Rank\n'..
			'Adept    4 vDLC\n'..
			'Raider   5 vDLC + 1 vDLC HM\n'..
			'Knight   6 vDLC + 3 vDLC HM\n'..
			'Champion 7 vDLC + 5 vDLC HM\n'..
			'Hero     8 vDLC + 6 vDLC HM + 1 Tri\n'..
			'Legend   8 vDLC + 7 vDLC HM + 4 Tri\n'..
			'Mythic   8 vDLC + 8 vDLC HM + 6 Tri\n'..
			'Godlike  8 vDLC + 8 vDLC HM + 8 Tri\n'
		end
		},

	['The Ashen Guard'] = {
		text = function() return PITHKA.Data.Ranks.summaryCalc('The Ashen Guard', {
			{'Civilian'     , function() return true end},
			{'Page'         , function() return ANY(tVET, 3) end},
			{'Squire'       , function() return ANY(CONCAT(tVETDLC, tPHM), 4) end},
			{'Knight'       , function() return ANY(tVET, 9) and ANY(tPHM, 2) end},
			{'Royal Knight' , function() return ANY(tHM, 9) end},
			}) end,
		tt = function() return 'RANKS\n\n'..
			'Civilian      starting rank\n'..
			'Page          3 Vet\n'..
			'Squire        4 DLC Vet or Partial HM\n'..
			'Knight        All Vet** & 2 Partial HM\n' ..
			'Royal Knight  All HMs**\n' ..
			'\n** RG not req' 
			end
	},

-- GM ASKED TO REMOVE GUILD
-- 	['Rose ESO'] = {
-- 		text = function()
-- 			-- very weird custom list logic
-- 			local listCount = COUNT{vMOLHM, vHOFHM, vAS2, vCR2, vKAHM}
-- 			listCount = listCount + (ALL{vSSa, vSSb} and 1 or 0)
-- 			listCount = listCount + (ALL{vRGa, vRGb} and 1 or 0)
-- 			-- standard logic
-- 			return PITHKA.Data.Ranks.summaryCalc('Rose ESO', {
-- 			{'Beginner'     , function() return true end},
-- 			{'Intermediate' , function() return ANY(tHMNOTDLC, 2) end},
-- 			{'Advanced'     , function() return ANY(tVETDLC, 6) end},
-- 			{'Expert'       , function() return listCount >= 3 end},
-- 			{'Legendary'    , function() return listCount >= 5 end},
-- 			}) end,
-- 		tt = function() return 'RANKS\n\n'..
-- 			'Beginner      starting rank\n'..
-- 			'Intermediate  2 of 3 Craglorn HM\n'..
-- 			'Advanced      and 6 DLC Vets\n'..
-- 			'Expert        and 3 from List\n' ..
-- 			'Legendary     and 5 from List\n' ..
-- 			'\nList:' ..
-- 			'\n* vMoL HM' ..
-- 			'\n* vHof HM' ..
-- 			'\n* vAS+2' ..
-- 			'\n* vCR+2' ..
-- 			'\n* vKA HM' ..
-- 			'\n* vSS (both Lokke & Yolna req)' ..
-- 			'\n* vRG (both Oaxil & Bahsei req)'
-- 			end
-- 	},
		
	['The Union of Disorder'] = {
		text = function() return PITHKA.Data.Ranks.summaryCalc('The Union of Disorder', {
			{'Vestige'	    , function() return true end},
			{'Summer Child' , function() return ALL{vHRC, vAA, vSO} end},
			{'Grunt'		, function() return ALL{vHRCHM, vAAHM, vSOHM, vMOL, vCR1, vSS} and ANY({vAS1a, vAS1b}, 1) end},
			{'Veteran'		, function() return ALL{vHOFHM, vCR2, vKA, vRG}end},
			{'Legend'		, function() return ALL(tHM) end},
			{'Mythic'  		, function() return ALL(tTRI)end},
			}) end,
		tt = function() return 'RANKS\n\n'..
			'Vestige      - starting rank\n'..
			'Summer Child - Craglorn Vets \n'..
			'Grunt        - Craglorn HMs, vMoL, vSS\n               vAS/vCR +1s\n'..
			'Veteran      - vHoF HM, vCR+2, vKA, vRG\n'..
			'Legend       - all HMs\n'..
			'Mythic       - all Trifectas (+DD)'
			end
	},


	['Heart of Tamriel'] = {
		text = function() return '|H1:guild:720805|hHeart of Tamriel|h '  ..
			COUNT(tVET)  .. ' of ' .. #tVET .. ' Veterans  ||  ' ..
			COUNT(tHM)   .. ' of ' .. #tHM  .. ' Hard Modes  ||  ' ..
			COUNT(tTRI)  .. ' of ' .. #tTRI .. ' Trial Trifectas  '
			end,
		tt = function() return nil end,
	},

	['ESO Runs'] = {
		guildId = function() return 810705 end,
		text = function() return 'ESO Runs' end,
		tt = function() return nil end,
		tFont = '$(HANDWRITTEN_FONT)|26',

	},


	['Aedra'] = {
		text = function() return PITHKA.Data.Ranks.summaryCalc('Aedra', {
			{'Initiate'	    , function() return true end},
			{'Raider' 		, function() return ANY({vHRCHM, vAAHM, vSOHM, vMOL, vHOF, vAS, vSS, vCR, vKA, vRG}, 3) end},
			{'Veteran'		, function() return ALL(tVET) end},
			{'Experienced'	, function() return ALL{vHOFHM, vMOLHM, vAS1a, vAS1b, vCR1, vCR2, vSSa, vSSb, vKAa, vKAb} end},
			{'Heroic'		, function() return ALL(tHM) end},
			{'Epic'  		, function() return ANY(tTRI, 3) end},
			{'Legendary'	, function() return ALL(tTRI) end},
			}) end,
		tt = function() return 'RANKS\n\n'..
			'Initiate    - Starting rank\n'..
			'Raider      - 3x Crag HMs or Vet DLC\n'..
			'Veteran     - All Vets\n'..
			'Experienced - vHoF HM, vMol HM\n'..
			'			   & All partial HM*\n'..
			'Heroic      - All HMs*\n'..
			'Epic        - 3x Trifectas\n'..
			'Legendary   - All Trifectas*'
			end
	},


	['Black Dragon Defenders'] = {
		text = function() return PITHKA.Data.Ranks.summaryCalc('Black Dragon Defenders', {
			{'Hatchlign'	, function() return true end},
			{'Drake' 		, function() return ALL({vHRC, vAA, vSO}) and ANY(tVETDLC, 2) end},
			{'Dragon'		, function() return ALL(tVET) and ALL({vHRCHM, vSOHM,vAAHM}) end},
			{'Elder Dragon'	, function() return ALL(tVETDLC) and ANY(tHMDLC, 3) end},
			}) end,
		tt = function() return 'RANKS\n\n'..
			'Hatchling    - Starting rank\n'..
			'Drake        - All Vet Crag + 2 Vet DLC\n'..
			'Dragon       - All Vet DLC + All Crag HM\n'..
			'Elder Dragon - All Vet DLC +  3 DLC HM'
			end
	},


	['Seas of Oblivion'] = {
		text = function() return PITHKA.Data.Ranks.summaryCalc('Seas of Oblivion', {
			{'Seahorse'	, function() return true end},
			{'Remora'	, function() return ALL({vHRC, vAA, vSO}) or (ANY({vHRC, vAA, vSO},2) and ANY({vMA, vVH}, 1)) end},
			{'Jellyfish', function() return ALL(tVET) and ALL({vMA, vVH}) end},
			{'Orca'		, function() return ANY(tHMDLC, 5) end},
			}) end,
		tt = function() return 'RANKS\n\n'..
			'Seahorse  - Starting rank\n'..
			'Remora    - 3 Vet Crag or\n'..
			'            2 Vet Crag + 1 of vMA / vVH\n'..
			'Jellyfish - All Vet + vMA + vVH\n'..
			'Orca      - 5+ Vet DLC HM'
			end
	},

	-- DUNGEON SUMMARIES ------------------------------------------------------------------

	['~ Dungeon Summary ~'] = {
		text = function() return 
			COUNT(dVET)  .. ' of ' .. #dVET .. ' Vets  ||  ' ..
			COUNT(dHM)   .. ' of ' .. #dHM  .. ' HMs  ||  ' ..
			COUNT(dTRI)  .. ' of ' .. #dTRI .. ' Tris'
			end,
		tt = function() return nil end,
	},

	['The Four Musketeers'] = {
		text = function() 
			return PITHKA.Data.Ranks.summaryCalc('The Four Musketeers', {
			{'Cadet'		, function() return true end},
			{'Corporal'		, function() return ANY(dCHA, 4) end},
			{'Sergeant'		, function() return ANY(dCHA, 8) end},
			{'Lieutenant'	, function() return ANY(dCHA, 14) end},
			{'Major'		, function() return ALL(dCHA) end},
			{'Colonel' 		, function() return ANY(dTRI, 5) end},
			{'General'		, function() return ANY(dTRI, 8) end},
			{'Musketeer'	, function() return ANY(dTRI, 14) end},
			{'Completionist', function() return ALL(dTRI) end},
			}) end,
		tt = function() return 'RANKS\n\n'..
			'Cadet           starting rank\n'..
			'Corporal        4 Challengers\n'..
			'Sergeant        8 Challengers\n'..
			'Lieutenant     14 Challengers\n'..
			'Major         All Challengers\n'..
			'Colonel         5 Trifectas\n'..
			'General         8 Trifectas\n'..
			'Musketeer      14 Trifectas\n'..
			'Completionist All Trifectas'
			end,
	},

	['Hard Dungeoneers'] = {
		guildId = function() return 694135 end,
		text = function() 
			local dungeonNoTri = {1132, 1511,1529,1942,1941}        -- dunegeon without tri			
			local PointsDungeonNoTri = ALL(dungeonNoTri) and 1 or 0 -- 1 point if you have all non-tri dunegons
			local PointsCha = COUNT(dCHA) - COUNT(dungeonNoTri)     -- 1 point for each cha (for dungeon w tri)
			local PointsTri = 3*(COUNT(dTRI) - COUNT({2368}))       -- 3 points for each TRI, exclude BRP
			local PointsBRP = 5*COUNT({2368})						-- 5 points for BRP
			local score = PointsDungeonNoTri + PointsCha + PointsTri + PointsBRP

			return PITHKA.Data.Ranks.summaryCalc('Hard Dungeoneers', {
			{'Recruit  ||  '	.. score .. ' points', function() return true end},
			{'Knight  ||  '	    .. score .. ' points', function() return score >= 4 end}, 
			{'Baron  ||  '	    .. score .. ' points', function() return score >= 18 end},
			{'Warlord  ||  '	.. score .. ' points', function() return score >= 33 end},
			{'Undying  ||  '	.. score .. ' points', function() return score >= 50 end},
			{'Immortal  ||  '	.. score .. ' points', function() return score >= 65 end},
			{'Exitium  ||  '	.. score .. ' points', function() return score >= 83 end},
			{'Amaranth || '     .. score .. ' points', function() return score >= 102 end},
			}) end,
		tt = function() return 'RANKS\n\n'..
			'Recruit       starting rank\n'..
			'Knight         4 points\n'..
			'Baron         18 points\n'..
			'Warlord       33 points\n'..
			'Undying       50 points\n'..
			'Immortal      65 points\n'..
			'Exitium       83 points\n'..
			'Amaranth     102 points\n\n'..
			'** 1 pt per Challenger\n'..
			'** 3 pt per Trifecta\n'..
			'** 5 pt for Unchained\n' .. 
			'** 1 pt for IC+ROM+COS+FH+BRF\n'
		end
	},


	['EZ HM'] = {
		text = function() 
			local tris_wo_new_dungeons = {2102,1983,2159,2168,2267,2276,2431,2422,2546,2555,2701,2710,2838,2847,3023,3032}
			return PITHKA.Data.Ranks.summaryCalc('EZ HM', {
			{'Newbie'    , function() return true end},
			{'Normal'    , function() return ALL(dVET) end},
			{'Fine'		 , function() return ALL(dVET) and ANY(dHM, 10) end},
			{'Superior'	 , function() return ALL(dHM) end},
			{'Epic'		 , function() return ALL(dHM) and ANY(dTRI,10) end},
			{'Legendary' , function() return ALL(tris_wo_new_dungeons) end}
			}) end,
		tt = function() return 'RANKS\n\n'..
			'Newbie     starting rank\n'..
			'Normal     all Vets\n'..
			'Fine       all Vets + 10 HMs\n'..
			'Superior   all HMs\n'..
			'Epic       all HMs + 10 Tris\n'..
			'Legendary  all Tris (w/o new dungeons)\n'
			end,
	},

	['Random Daily Guild'] = {
		text = function()
			return PITHKA.Data.Ranks.summaryCalc('Random Daily Guild', {
			{'Dungeoneer'    , function() return true end},
			{'Conqueror'     , function() return ANY(dVET, 15) and ANY(dHM, 10) end},
			{'Challenger'	 , function() return ANY(dCHA, 10) and ANY(dHM, 20) end},
			{'Trident'		 , function() return ANY(dTRI, 3)  and ANY(dCHA, 15) end},
			{'Mythic Slayer' , function() return ANY(dTRI, 15)  end},
			{'Dungeon Master', function() return ANY(dTRI, #dTRI-1)  end} -- hacky way to exclude BRP
			}) end,
		tt = function() return 'RANKS\n\n'..
			'Dungeoneer     starting rank\n'..
			'Conqueror      15 Vets, 10 HMs\n'..
			'Challenger     10 Chgs, 20 HMs\n'..
			'Trident         3 Tris, 15 Chgs\n'..
			'Mythic Slayer  15 Tris\n'..
			'Dungeon Master all Tris (not BRP)\n'
			end,
	},

	['TEAM MATES'] = {
		text = function() 
			local summary = COUNT(dHM)   .. ' HMs  ||  ' ..
							COUNT(dTRI)  .. ' Tris'

			return PITHKA.Data.Ranks.summaryCalc('TEAM MATES', {
			{'Newbie  ||  '  .. summary, function() return true end},
			{'Fine  ||  '    .. summary, function() return ANY(dTRI,3) end},
			{'Super  ||  '   .. summary, function() return ANY(dTRI,6) end},
			{'Epic  ||  '    .. summary, function() return ANY(dTRI,9) end},
			{'Legend  ||  '  .. summary, function() return ANY(dTRI,12) end},
			{'Mythic  ||  '  .. summary, function() return ANY(dTRI,15) end},
			{'Mythic+  ||  ' .. summary, function() return ANY(dTRI,18) end},
			{'Devine   ||  ' .. summary, function() return ALL(dTRI) end},
			}) end,
		tt = function() return 'RANKS\n\n'..
			'Normal      starting rank\n'..
			'Fine        3+ Trifectas\n'..
			'Super       6+ Trifectas\n'..
			'Epic        9+ Trifectas\n'..
			'Legend     12+ Trifectas\n'..
			'Mythic     15+ Trifectas\n'..
			'Mythic+    18+ Trifectas\n'..
			'Divine     ALL Trifectas'
			end,
	},

	-- TRIFECTA SUMMARIES ------------------------------------------------------------------
	
	['~ Trifecta Summary ~'] = {
		text = function() return 
			COUNT(dTRI)  .. ' of ' .. #dTRI .. ' Dungeons  ||  ' ..
			COUNT(aTRI)  .. ' of ' .. #aTRI  .. ' Arenas  ||  ' ..
			COUNT(tTRI)  .. ' of ' .. #tTRI .. ' Trials  '
			end,
		tt = function() return nil end,
	},

}



PITHKA.Data.Ranks.icons = {
	['ESO Runs'] = {
		texture = "/PithkaAchievementTracker/Assets/esoruns.dds",
		anchor = BOTTOMLEFT,
		xOffset = 150,
		yOffset = 0,
	},
}
