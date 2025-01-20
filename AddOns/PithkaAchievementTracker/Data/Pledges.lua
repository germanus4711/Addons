-- support /pledges
-- support /pq
-- support /regroup


PITHKA = PITHKA or {}
PITHKA.Data = PITHKA.Data or {}
PITHKA.Data.Pledges = {}


local DailyPledges={
	[1]={	--Maj
		{en="Elden Hollow II",		},
		{en="Wayrest Sewers I",		},
		{en="Spindleclutch II",		},
		{en="Banished Cells I",		},
		{en="Fungal Grotto II",		},
		{en="Spindleclutch I",		},
		{en="Darkshade Caverns II",	},
		{en="Elden Hollow I",		},
		{en="Wayrest Sewers II",	},
		{en="Fungal Grotto I",		},
		{en="Banished Cells II",	},
		{en="Darkshade Caverns I",	},
		shift=0
	},
	[2]={	--Glirion
		{en="Volenfell",			},
		{en="Blessed Crucible I",	},
		{en="Direfrost Keep I",		},
		{en="Vaults of Madness",	},
		{en="Crypt of Hearts II",	},
		{en="City of Ash I",		},
		{en="Tempest Island",		},
		{en="Blackheart Haven",		},
		{en="Arx Corinium",		    },
		{en="Selene's Web",		    },
		{en="City of Ash II",		},
		{en="Crypt of Hearts I",	},
		shift=0
	},
	[3]={	--Urgarlag
		{en="Imperial City Prison",	},
		{en="Ruins of Mazzatun",	},
		{en="White-Gold Tower",		},
		{en="Cradle of Shadows",	},
		{en="Bloodroot Forge",		},
		{en="Falkreath Hold",		},
		{en="Fang Lair",			},
		{en="Scalecaller Peak",		},
		{en="Moon Hunter Keep",		},
		{en="March of Sacrifices",	},
		{en="Depths of Malatar",	},
		{en="Frostvault",			},
		{en="Moongrave Fane",		},
		{en="Lair of Maarselok",	},
		{en="Icereach",			    },
		{en="Unhallowed Grave",		},
		{en="Stone Garden",		    },
		{en="Castle Thorn",		    },
		{en="Black Drake Villa",	},
		{en="The Cauldron",		    },
		{en="Red Petal Bastion",	},
		{en="The Dread Cellar",		},
		{en="Coral Aerie",			},
		{en="Shipwright's Regret",  },
		{en="Earthen Root Enclave",	},
		{en="Graven Deep",		    },
		{en="Bal Sunnar",           },
		{en="Scrivener's Hall",		},
		{en="Oathsworn Pit",        },
		{en="Bedlam Veil",		    },
        shift=13
	},
}

-- Conditionally add new dungeons based on API version
if GetAPIVersion() >= 101045 then
    table.insert(DailyPledges[3], {en = "Exiled Redoubt"})
    table.insert(DailyPledges[3], {en = "Lep Seclusa"})
    DailyPledges[3].shift = 27
end

function PITHKA.Data.Pledges.GetGoalPledges()
	local Pledges,haveQuest={},false
	for i=1,MAX_JOURNAL_QUESTS do
		local name,_,_,stepType,_,completed,_,_,_,questType,instanceType=GetJournalQuestInfo(i)
		if name and name~="" and not completed and questType==QUEST_TYPE_UNDAUNTED_PLEDGE and instanceType==INSTANCE_TYPE_GROUP and name:match(".*:%s*(.*)") then
			local text=string.format("%s",name:gsub(".*:%s*",""):gsub(" "," "):gsub("%s+"," "):lower())
            local number=string.match(text,"%sii$")
            text=string.match(text,"[^%s]+")..(number or "")
			Pledges[text]=stepType~=QUEST_STEP_TYPE_AND
			if stepType==QUEST_STEP_TYPE_AND then haveQuest=true end
--			if BUI.Vars.DeveloperMode then d(zo_strformat("QuestName: \"<<1>>\" Dungeon: \"<<2>>\" Step: <<3>>",name,text,stepType)) end
		end
	end
	return Pledges,haveQuest
end

function PITHKA.Data.Pledges.DailyPledges()
	local Pledges=PITHKA.Data.Pledges.GetGoalPledges()
	local day=math.floor(GetDiffBetweenTimeStamps(GetTimeStamp(),1517464800)/86400)
	d("Daily pledges:")
	for npc=1,3 do
		local dp=DailyPledges[npc]
		local n=1+(day+dp.shift)%#dp
		local pledge=dp[n].en

		local quest=""
		if pledge then
			local text=pledge:lower()
			local number=string.match(text,"%sii$")
			text=string.match(text,"[^%s]+")..(number or "")
			if Pledges[text]==false then quest=" |c3388EE- ".. "active quest" .. "|r" end
		end

		d("["..npc.."] "..tostring(pledge)..quest)
	end
end
