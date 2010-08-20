--[[ oUF_PredatorSimple
	This is a layout for the incredibly awesome oUF by haste.
	
	PLEASE NOTE that this layout comes with no warranty and "as it is". It was created to fit my very own
	needs, so please understand, that I'll not put any effort in "fixing" something for you, "adding" something
	for you or make any changes to this.
	Anyway, when you read this, you've already downloaded my layout, so please, feel free to modify it to your
	own needs.
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local menu = {}
PredatorSimpleMenuFunctions = {}

local settings = ns.settings							-- get the settings
local lib = ns.lib										-- get the library

menu.PanelNames = {
	['GeneralOptions'] = 'PredatorSimpleGeneralPanel',
	['Positions'] = 'PredatorSimplePositionPanel',
}

menu.UnitNamesLookup = {
	['forward'] = {
		['playerframe'] = 'oUF_PredatorSimple_player',
		['petframe'] = 'oUF_PredatorSimple_pet',
		['targetframe'] = 'oUF_PredatorSimple_target', 
		['targettarget'] = 'oUF_PredatorSimple_targettarget',
		['focusframe'] = 'oUF_PredatorSimple_focus',
		['partyframe'] = 'oUF_PredatorSimple_party', 
		['partyframe_healer'] = 'oUF_PredatorSimple_party - Healer',
		['raidframe'] = 'oUF_PredatorSimple_raid', 
		['raidframe_healer'] = 'oUF_PredatorSimple_raid - Healer',
		['mtframe'] = 'oUF_PredatorSimple_MT', 
		['mtframe_healer'] = 'oUF_PredatorSimple_MT - Healer',
	},
	['backward'] = {
		['oUF_PredatorSimple_player'] = 'oUF_PredatorSimple_player',
		['oUF_PredatorSimple_pet'] = 'oUF_PredatorSimple_pet',
		['oUF_PredatorSimple_target'] = 'oUF_PredatorSimple_target', 
		['oUF_PredatorSimple_targettarget'] = 'oUF_PredatorSimple_targettarget',
		['oUF_PredatorSimple_focus'] = 'oUF_PredatorSimple_focus',
		['oUF_PredatorSimple_party'] = 'oUF_PredatorSimple_party', 
		['oUF_PredatorSimple_party - Healer'] = 'oUF_PredatorSimple_party',
		['oUF_PredatorSimple_raid'] = 'oUF_PredatorSimple_raid', 
		['oUF_PredatorSimple_raid - Healer'] = 'oUF_PredatorSimple_raid',
		['oUF_PredatorSimple_MT'] = 'oUF_PredatorSimple_MT', 
		['oUF_PredatorSimple_MT - Healer'] = 'oUF_PredatorSimple_MT',
	}
}

menu.UnitFrameList = {}

-- *****************************************************

	--[[
	
	]]
	menu.GeneralPanelOnShow = function()
		lib.debugging('GeneralPanelOnShow()')
		local temp

		CreateFrame('Frame', 'PredatorSimplePositionPanel', menu.panel, 'PredatorSimplePositionPanelTemplate')

		menu.panel:SetScript('OnShow', nil)
	end

	--[[
	
	]]
	menu.PositionPanelApplyItemValues = function(frame, item)
		_G[frame..'UFName']:SetText(menu.UnitNamesLookup['forward'][item['name']])
		_G[frame..'XPos']:SetText(item['values']['x'])
		_G[frame..'YPos']:SetText(item['values']['y'])
		_G[frame..'AnchorPoint']:SetText(item['values']['anchorPoint'])
		_G[frame..'AnchorToPoint']:SetText(item['values']['anchorToPoint'])
		_G[frame..'AnchorToFrame']:SetText(item['values']['anchorToFrame'])
	end


-- *****************************************************

	--[[
	
	]]
	PredatorSimpleMenuFunctions.GeneralPanelOnLoad = function()
		lib.debugging('GeneralPanelOnLoad()')
		local modify
		menu.panel = _G[menu.PanelNames['GeneralOptions']]
		menu.panel.name = 'oUF_PredatorSimple'

		-- Set the SubCaption
		modify = _G[menu.PanelNames['GeneralOptions']..'SubCaption']
		modify:SetText('General Options')

		menu.panel:SetScript('OnShow', menu.GeneralPanelOnShow)
		InterfaceOptions_AddCategory(menu.panel)
		menu.panel:SetScript('OnLoad', nil)
	end

	--[[
	
	]]
	PredatorSimpleMenuFunctions.PositionPanelOnLoad = function()
		-- lib.debugging('PositionPanelOnLoad()')
		local modify, i
		menu.posPanel = _G[menu.PanelNames['Positions']]
		menu.posPanel.name = 'Positions'
		menu.posPanel.parent = menu.panel.name

		-- Set the SubCaption
		modify = _G[menu.PanelNames['Positions']..'SubCaption']
		modify:SetText('Positions')

		-- Build the UnitFrame-list
		i = 1
		for k, v in pairs(settings.positions) do
			menu.UnitFrameList[i] = {
				['name'] = k,
				['values']  = v,
			}
			i = i + 1
		end

		InterfaceOptions_AddCategory(menu.posPanel)
		menu.posPanel:SetScript('OnLoad', nil)
	end

	--[[
	
	]]
	PredatorSimpleMenuFunctions.UpdatePositionScrollFrame = function()
		-- lib.debugging('UpdatePositionScrollFrame()')
		local scrollbar = _G[menu.PanelNames['Positions']..'ScrollBar']
		local line, lineOffset, item
		FauxScrollFrame_Update(scrollbar, #menu.UnitFrameList, 2, 178)
		for line = 1, 2 do
			lineOffset = line + FauxScrollFrame_GetOffset(scrollbar)
			item = _G[menu.PanelNames['Positions']..'ScrollBarItem'..line]
			if ( lineOffset < #menu.UnitFrameList ) then
				menu.PositionPanelApplyItemValues(menu.PanelNames['Positions']..'ScrollBarItem'..line, menu.UnitFrameList[lineOffset])
				item.currentFrame = menu.UnitFrameList[lineOffset]['name']
				item:Show()
			else
				item.currentFrame = nil
				item:Hide()
			end
		end
	end

	--[[
	
	]]
	PredatorSimpleMenuFunctions.SaveFramePosition = function(frame)
		lib.debugging(frame.currentFrame)
		-- lib.debugging(_G[frame:GetName()..'XPos']:GetText())
		settings.positions[frame.currentFrame]['x'] = _G[frame:GetName()..'XPos']:GetText()
		settings.positions[frame.currentFrame]['y'] = _G[frame:GetName()..'YPos']:GetText()
		settings.positions[frame.currentFrame]['anchorPoint'] = _G[frame:GetName()..'AnchorPoint']:GetText()
		settings.positions[frame.currentFrame]['anchorToPoint'] = _G[frame:GetName()..'AnchorToPoint']:GetText()
		settings.positions[frame.currentFrame]['anchorToFrame'] = _G[frame:GetName()..'AnchorToFrame']:GetText()
		_G[menu.UnitNamesLookup['backward'][_G[frame:GetName()..'UFName']:GetText()]]:SetPoint(settings.positions.playerframe.anchorPoint, settings.positions.playerframe.anchorToFrame, settings.positions.playerframe.anchorToPoint, settings.positions.playerframe.x, settings.positions.playerframe.y)
	end

-- *****************************************************
ns.menu = menu											-- handover of the core-functions to the namespace