SetCollectionColoredLibrary = SetCollectionColoredLibrary or {}
local a = SetCollectionColoredLibrary
a={
	name	= "SetCollectionColoredLibrary",
	author	= "tim99",
	version	= 1,
	dbVar   = {},
	dbDef   = {known="66ff66", unknown="ff6666"}
}
-------------------------------------------------------------------------------------------
function a:GetTextColor()
	local b,c,d,e=self.normalColor:UnpackRGBA()
	if self.selected then return b,c,d,0.4 elseif self.mouseover then return b,c,d,0.7 end
	return b,c,d,e 
end;
function a.addonLoaded(f,g)
	if g~=a.name then return end
	EVENT_MANAGER:UnregisterForEvent(a.name,EVENT_ADD_ON_LOADED)
	a.dbVar=ZO_SavedVars:NewAccountWide("SetCollectColorSV",1,nil,a.dbDef,GetWorldName())
	a.c_red=ZO_ColorDef:New(a.dbVar.unknown)
	a.c_grn=ZO_ColorDef:New(a.dbVar.known)
	SecurePostHook(ITEM_SET_COLLECTIONS_BOOK_KEYBOARD.categoryTree.templateInfo.ZO_TreeStatusLabelSubCategory,"setupFunction",function(h,i,j,k,l,m)
		local o,p=j:GetNumUnlockedAndTotalPieces()
		local n=o==p and a.c_grn or a.c_red
		ZO_SelectableLabel_SetNormalColor(i,n)
		if i.GetTextColor~=a.GetTextColor then i.GetTextColor=a.GetTextColor end
		i:RefreshTextColor()
	end)
end
-------------------------------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(a.name,EVENT_ADD_ON_LOADED,a.addonLoaded)
