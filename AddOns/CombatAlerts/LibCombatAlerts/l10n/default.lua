local Register = LibCodesCommonCode.RegisterString

Register("SI_LCA_INCOMING" , zo_strformat("<<C:1>>", GetString(SI_INTERFACE_OPTIONS_COMBAT_SCT_INCOMING_ENABLED)))
Register("SI_LCA_ACTIVE"   , zo_strformat("<<C:1>>", GetString(SI_MARKET_SUBSCRIPTION_PAGE_SUBSCRIPTION_STATUS_ACTIVE)))
Register("SI_LCA_SUCCESS"  , zo_strformat("<<C:1>>", GetString("SI_UPDATEGUILDMETADATARESPONSE", UPDATE_GUILD_META_DATA_SUCCESS)))
Register("SI_LCA_FAIL"     , zo_strformat("<<C:1>>", GetString("SI_UPDATEGUILDMETADATARESPONSE", UPDATE_GUILD_META_DATA_FAIL)))
