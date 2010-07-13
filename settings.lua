--[[ oUF_PredatorSimple
	This is a layout for the incredibly awesome oUF by haste.
	
	PLEASE NOTE that this layout comes with no warranty and "as it is". It was created to fit my very own
	needs, so please understand, that I'll not put any effort in "fixing" something for you, "adding" something
	for you or make any changes to this.
	Anyway, when you read this, you've already downloaded my layout, so please, feel free to modify it to your
	own needs.
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = CreateFrame('Frame')

--[[ SETTINGS
	We'll set some basic settings here, which are used throughout the layout.
	Furthermore you can find the default-values of the SavedVars in here
]]

	--[[ 
	
	]]
	settings.src = {
		['fonts'] = {
			['BloodCrow'] = [[Interface\AddOns\oUF_PredatorSimple\media\bloodcrow.ttf]],
			['Ebrima'] = [[Interface\AddOns\oUF_PredatorSimple\media\ebrimabd.ttf]],
		},
		['textures'] = {
			['bartexture'] = [[Interface\AddOns\oUF_PredatorSimple\media\bar]],
			['bordertexture'] = [[Interface\AddOns\oUF_PredatorSimple\media\border]],
		},
		['threatColors'] = {
			[0] = { 0.5, 0.5, 0.5 },
			[1] = { 1, 1, 0 },
			[2] = { 1, 1, 0 },
			[3] = { 1, 0.3, 0.3 },
		},
		['backdrop'] = {
			bgFile = [[Interface\AddOns\oUF_PredatorSimple\media\solid]], tile = true, tileSize = 16,
			edgeFile = [[Interface\AddOns\oUF_PredatorSimple\media\solid]], edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1 },
		}
	}

	--[[ Positions-array (will be overridden by SavedVariables)
		Please note, that this positions are only used on the first load of the layout. You may alter the 
		positions by editing your character specific SavedVars file.
	]]
	settings.positions = { 
		['playerframe'] = {
			['x'] = -100,
			['y'] = -300,
			['anchorPoint'] = 'TOPRIGHT',
			['anchorToPoint'] = 'CENTER',
			['anchorToFrame'] = 'UIParent',
		},
		['petframe'] = {
			['x'] = -15, 
			['y'] = 0,
			['anchorPoint'] = 'TOPRIGHT',
			['anchorToPoint'] = 'TOPLEFT',
			['anchorToFrame'] = 'oUF_PredatorSimple_player',
		},
		['targetframe'] = {
			['x'] = 100,
			['y'] = -300,
			['anchorPoint'] = 'TOPLEFT',
			['anchorToPoint'] = 'CENTER',
			['anchorToFrame'] = 'UIParent',
		},
		['targettarget'] = {
			['x'] = 15,
			['y'] = 0,
			['anchorPoint'] = 'TOPLEFT',
			['anchorToPoint'] = 'TOPRIGHT',
			['anchorToFrame'] = 'oUF_PredatorSimple_target',
		},
		['focusframe'] = {
			['x'] = 15,
			['y'] = 30,
			['anchorPoint'] = 'BOTTOMLEFT',
			['anchorToPoint'] = 'TOPRIGHT',
			['anchorToFrame'] = 'oUF_PredatorSimple_target',
		},
		['partyframe'] = {
			['x'] = 30,
			['y'] = 420,
			['anchorPoint'] = 'TOPLEFT',
			['anchorToPoint'] = 'BOTTOMLEFT',
			['anchorToFrame'] = 'UIParent',
		},
		['partyframe_healer'] = {
			['x'] = 200,
			['y'] = 100,
			['anchorPoint'] = 'TOPLEFT',
			['anchorToPoint'] = 'CENTER',
			['anchorToFrame'] = 'UIParent',
		},
		['raidframe'] = {
			['x'] = 30,
			['y'] = 460,
			['anchorPoint'] = 'TOPLEFT',
			['anchorToPoint'] = 'BOTTOMLEFT',
			['anchorToFrame'] = 'UIParent',
		},
		['raidframe_healer'] = {
			['x'] = 200,
			['y'] = 100,
			['anchorPoint'] = 'TOPLEFT',
			['anchorToPoint'] = 'CENTER',
			['anchorToFrame'] = 'UIParent',
		},
		['mtframe'] = {
			['x'] = 0,
			['y'] = 150,
			['anchorPoint'] = 'TOPLEFT',
			['anchorToPoint'] = 'TOPLEFT', 
			['anchorToFrame'] = 'oUF_PredatorSimple_focus',
		},
		['mtframe_healer'] = {
			['x'] = 0,
			['y'] = 150,
			['anchorPoint'] = 'TOPLEFT',
			['anchorToPoint'] = 'TOPLEFT', 
			['anchorToFrame'] = 'oUF_PredatorSimple_focus',
		},
	}
	
	--[[ Options-array (will be overridden by SavedVariables)
		Please note, that this options are only used on the first load of the layout. You may alter the 
		options by editing your character specific SavedVars file.
	]]
	settings.options = {
		['strings'] = {
			['dead'] = 'dead',
			['ghost'] = 'ghost',
			['offline'] = 'off',
		},
		['playerframe_width'] = 225,
		['petframe_width'] = 75,
		['targetframe_width'] = 225,
		['targettarget_width'] = 75,
		['focusframe_width'] = 150,
		['partyframe_width'] = 100,
		['partytarget_width'] = 50,
		['raidframe_width'] = 50,
		['raidhealer_width'] = 75,
		['bordersize'] = 10,
		['playercastbar_width'] = 300,
		['playercastbar_height'] = 20,
		['playercastbar_ypos'] = -150,
		['healermode'] = false,
		['playerBuffs'] = {
			['mode'] = 'blacklist',
			['list'] = {},
		},
		['playerDebuffs'] = {
			['mode'] = 'blacklist',
			['list'] = {},
		},
		['friendsBuffs'] = {
			['mode'] = 'blacklist',
			['list'] = {},
		},
		['friendsDebuffs'] = {
			['mode'] = 'blacklist',
			['list'] = {},
		},
		['enemyBuffs'] = {
			['mode'] = 'blacklist',
			['list'] = {},
		},
		['enemyDebuffs'] = {
			['mode'] = 'blacklist',
			['list'] = {},
		},
	}


-- *****************************************************
ns.settings = settings									-- handover of the settings to the namespace