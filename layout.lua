--[[ oUF_PredatorSimple
	This is a layout for the incredibly awesome oUF by haste.
	
	PLEASE NOTE that this layout comes with no warranty and "as it is". It was created to fit my very own
	needs, so please understand, that I'll not put any effort in "fixing" something for you, "adding" something
	for you or make any changes to this.
	Anyway, when you read this, you've already downloaded my layout, so please, feel free to modify it to your
	own needs.
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local oUF = ns.oUF or oUF
assert(oUF, "oUF_PredatorSimple was unable to locate oUF install.")
local oUF_PredatorSimple = CreateFrame('Frame')

local settings = ns.settings							-- get the settings
local lib = ns.lib										-- get the library
-- local menu = ns.menu									-- get the menu
local core = ns.core									-- get the core

-- *****************************************************

	--[[ Styling of the player-frame
		This contains only player-specific layout-components.
	]]
	local function PredatorSimple_player(self, unit, isSingle)
		-- lib.debugging('entering PredatorSimple_player()')

		local _, playerclass = UnitClass('player')

		-- self:SetAttribute('initial-height', 30)
		-- self:SetAttribute('initial-width', settings.options.playerframe_width)
		self:SetSize(settings.options.playerframe_width, 30)

	-- ***** HEALTH *****
		self.Health = core.CreateHealthBar(self, 22)

	-- ***** POWER *****
		self.Power = core.CreatePowerBar(self, 8)

	-- ***** AllFrames *****
		core.AllFrames(self, 15)

	-- ***** Text-stuff *****
		self.Health.value = lib.CreateFontObject(self.Health, 10, settings.src.fonts['Ebrima'])
		self.Health.value:SetPoint('RIGHT', self.Health, 'RIGHT', -4, -2)

		self.Power.value = lib.CreateFontObject(self.Health, 9, settings.src.fonts['Ebrima'])
		self.Power.value:SetPoint('LEFT', self.Health, 'LEFT', 4, -11)
		
	-- ***** RAIDICON *****
		self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
		self.RaidIcon:SetPoint('CENTER', self, 'BOTTOMRIGHT', 0, 0)
		self.RaidIcon:SetWidth(18)
		self.RaidIcon:SetHeight(18)

	-- ***** RESTING *****
		self.Resting = self.Health:CreateTexture(nil, 'OVERLAY')
		self.Resting:SetPoint("CENTER", self, 'BOTTOMLEFT', 0, 0)
		self.Resting:SetWidth(24)
		self.Resting:SetHeight(24)
		self.Resting:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
		self.Resting:SetTexCoord(.5, 0, 0, .421875)

	-- ***** BUFFS / DEBUFFS *****
		self.Buffs = CreateFrame('Frame', nil, self)
		self.Buffs:SetHeight(24)
		self.Buffs:SetWidth(24 * 9)
		self.Buffs.size = 24
		self.Buffs.spacing = 7
		self.Buffs.num = 7
		self.Buffs:SetPoint('TOP', self, 'BOTTOM', 0, -10)
		self.Buffs.CreateIcon = lib.CreateAuraIcon
		self.Buffs.CustomFilter = core.FilterBuffs_player
		self.Debuffs = CreateFrame('Frame', nil, self)
		self.Debuffs:SetHeight(24)
		self.Debuffs:SetWidth(24 * 9)
		self.Debuffs.size = 24
		self.Debuffs.spacing = 7
		self.Debuffs.num = 7
		self.Debuffs:SetPoint('BOTTOM', self, 'TOP', 0, 10)
		self.Debuffs.CreateIcon = lib.CreateAuraIcon
		self.Debuffs.CustomFilter = core.FilterDebuffs_player

	-- ***** CASTBAR *****
		self.Castbar = core.CreateCastbar(self)
		self.Castbar:SetPoint('TOPLEFT', UIParent, 'CENTER', -(settings.options.playercastbar_width/2), settings.options.playercastbar_ypos)
		self.Castbar:SetPoint('BOTTOMRIGHT', UIParent, 'CENTER', (settings.options.playercastbar_width/2), settings.options.playercastbar_ypos - settings.options.playercastbar_height)
		self.Castbar.Border = CreateFrame('Frame', nil, self.Castbar)
		self.Castbar.Border:SetAllPoints(self.Castbar)
		self.Castbar.Border:SetFrameLevel(self.Castbar:GetFrameLevel() + 5)
		lib.CreateBorder(self.Castbar.Border, 10)

	-- ***** RUNES (Deathknight) ***** (player only)
		if (playerclass == 'DEATHKNIGHT') then
			self.Runes = core.CreateRuneFrame(self)
			self.Runes:SetPoint('BOTTOM', self, 'TOP', 0, 10)
			self.Debuffs:SetPoint('BOTTOM', self.Runes, 'TOP', 0, 10)
		end

	-- ***** HOLY POWER (Paladin) ***** (player only)
		if (playerclass == 'PALADIN') then
			self.HolyPower = core.CreateHolyPowerFrame(self)
			self.HolyPower:SetPoint('BOTTOM', self, 'TOP', 0, 10)
			self.Debuffs:SetPoint('BOTTOM', self.HolyPower, 'TOP', 0, 10)
		end
		
	-- ***** ECLIPSE (Druid) ***** (player only)
		if (playerclass == 'DRUID') then
			self.EclipseBar = core.CreateEclipseBar(self)
			self.EclipseBar:SetPoint('BOTTOM', self, 'TOP', 0, 10)
			self.EclipseBar.PostUpdateVisibility = core.UpdateEclipseBarVisibility
			self.Debuffs:SetPoint('BOTTOM', self.EclipseBar, 'TOP', 0, 10)
		end

	-- ***** SOUL SHARDS (Warlock) ***** (player only)
		if (playerclass == 'WARLOCK') then
			self.SoulShards = core.CreateSoulShardFrame(self)
			self.SoulShards:SetPoint('BOTTOM', self, 'TOP', 0, 10)
			self.Debuffs:SetPoint('BOTTOM', self.SoulShards, 'TOP', 0, 10)
		end

	-- ***** TOTEMS (Shaman) ***** (player only)
		if (playerclass == 'SHAMAN') then
			if (IsAddOnLoaded('oUF_boring_totembar')) then
				self.TotemBar = core.CreateTotemBar(self)
				self.TotemBar:SetPoint('BOTTOM', self, 'TOP', 0, 10)
				self.Debuffs:SetPoint('BOTTOM', self.TotemBar, 'TOP', 0, 10)
			end
		end

	-- ***** oUF-plugins *****
		core.ApplyPlugins(self)

	-- ***** ENGINES *****
		self.Health.PostUpdate = core.UpdateHealth_player
		self.Power.PostUpdate = core.UpdatePower
		self.UNIT_NAME_UPDATE = core.UpdateName_dummy

	end

	local function PredatorSimple_target(self)
		-- lib.debugging('entering PredatorSimple_target()')

		local _, playerclass = UnitClass('player')

		-- self:SetAttribute('initial-height', 30)
		-- self:SetAttribute('initial-width', settings.options.targetframe_width)
		self:SetSize(settings.options.targetframe_width, 30)

	-- ***** HEALTH *****
		self.Health = core.CreateHealthBar(self, 22)

	-- ***** POWER *****
		self.Power = core.CreatePowerBar(self, 8)

	-- ***** AllFrames *****
		core.AllFrames(self, 15)

	-- ***** Text-stuff *****
		self.Name = lib.CreateFontObject(self.Health, 20, settings.src.fonts['BloodCrow'])
		self.Name:SetTextColor(0.8, 0.8, 0.8)
		self.Name:SetPoint('BOTTOMLEFT', self.Health, 'LEFT', 5, 5)

		self.Health.value = lib.CreateFontObject(self.Health, 10, settings.src.fonts['Ebrima'])
		self.Health.value:SetPoint('RIGHT', self.Health, 'RIGHT', -4, -2)

		self.Power.value = lib.CreateFontObject(self.Health, 9, settings.src.fonts['Ebrima'])
		self.Power.value:SetPoint('LEFT', self.Health, 'LEFT', 4, -11)

	-- ***** COMBO POINTS ***** (target only)
		self.CPoints = core.CreateComboPointFrame(self)
		self.CPoints:SetPoint('BOTTOM', self, 'TOP', 0, 15)
		self.CPoints.Override = core.ComboPointUpdate

	-- ***** RAIDICON *****
		self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
		self.RaidIcon:SetPoint('CENTER', self, 'BOTTOMLEFT', 0, 0)
		self.RaidIcon:SetWidth(18)
		self.RaidIcon:SetHeight(18)

	-- ***** BUFFS / DEBUFFS *****
		self.Buffs = CreateFrame('Frame', nil, self)
		self.Buffs:SetHeight(24)
		self.Buffs:SetWidth(24 * 9)
		self.Buffs.size = 24
		self.Buffs.spacing = 7
		self.Buffs.num = 7
		self.Buffs:SetPoint('TOP', self, 'BOTTOM', 0, -10)
		self.Buffs.CreateIcon = lib.CreateAuraIcon
		self.Buffs.CustomFilter = core.FilterBuffs
		self.Buffs.PostUpdateIcon = core.PostUpdateIcon
		self.Debuffs = CreateFrame('Frame', nil, self)
		self.Debuffs:SetHeight(24)
		self.Debuffs:SetWidth(24 * 9)
		self.Debuffs.size = 24
		self.Debuffs.spacing = 7
		self.Debuffs.num = 7
		self.Debuffs:SetPoint('BOTTOM', self, 'TOP', 0, 15)
		self.Debuffs.CreateIcon = lib.CreateAuraIcon
		self.Debuffs.CustomFilter = core.FilterDebuffs
		self.Debuffs.PostUpdateIcon = core.PostUpdateIcon

	-- ***** CASTBAR *****
		self.Castbar = core.CreateCastbar(self)

	-- ***** oUF-plugins *****
		core.ApplyPlugins(self)

	-- ***** ENGINES *****
		self.Health.PostUpdate = core.UpdateHealth_min_percent
		self.Power.PostUpdate = core.UpdatePower
		self.UNIT_NAME_UPDATE = core.UpdateName_target

	end

	local function PredatorSimple_pet(self)
		-- lib.debugging('entering PredatorSimple_pet()')

		-- self:SetAttribute('initial-height', 30)
		-- self:SetAttribute('initial-width', settings.options.petframe_width)
		self:SetSize(settings.options.petframe_width, 30)

	-- ***** HEALTH *****
		self.Health = core.CreateHealthBar(self, 22)

	-- ***** POWER *****
		self.Power = core.CreatePowerBar(self, 8)
		self.Power.colorDisconnected = false
		self.Power.colorClass = false
		self.Power.colorReaction = false

	-- ***** AllFrames *****
		core.AllFrames(self, 15)

	-- ***** Text-stuff *****
		self.Health.value = lib.CreateFontObject(self.Health, 10, settings.src.fonts['Ebrima'])
		self.Health.value:SetPoint('RIGHT', self.Health, 'RIGHT', -4, -2)

	-- ***** RAIDICON *****
		self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
		self.RaidIcon:SetPoint('CENTER', self, 'BOTTOMLEFT', 0, 0)
		self.RaidIcon:SetWidth(18)
		self.RaidIcon:SetHeight(18)

	-- ***** oUF-plugins *****
		core.ApplyPlugins(self)

	-- ***** ENGINES *****
		self.Health.PostUpdate = core.UpdateHealth_min
		self.UNIT_NAME_UPDATE = core.UpdateName_dummy

	end

	local function PredatorSimple_targettarget(self)
		-- lib.debugging('entering PredatorSimple_targettarget()')

		-- self:SetAttribute('initial-height', 30)
		-- self:SetAttribute('initial-width', settings.options.targettarget_width)
		self:SetSize(settings.options.targettarget_width, 30)

	-- ***** HEALTH *****
		self.Health = core.CreateHealthBar(self, 30)

	-- ***** AllFrames *****
		core.AllFrames(self, 15)

	-- ***** Text-stuff *****
		self.Name = lib.CreateFontObject(self.Health, 16, settings.src.fonts['BloodCrow'])
		self.Name:SetTextColor(0.8, 0.8, 0.8)
		self.Name:SetPoint('CENTER', self, 'CENTER', 3, 0)

		self.Health.value = lib.CreateFontObject(self.Health, 10, settings.src.fonts['Ebrima'])
		self.Health.value:SetPoint('RIGHT', self.Health, 'RIGHT', -2, 0)

	-- ***** RAIDICON *****
		self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
		self.RaidIcon:SetPoint('CENTER', self, 'BOTTOMLEFT', 0, 0)
		self.RaidIcon:SetWidth(18)
		self.RaidIcon:SetHeight(18)

	-- ***** oUF-plugins *****
		core.ApplyPlugins(self)

	-- ***** ENGINES *****
		self.Health.PostUpdate = core.UpdateHealth_percent_name
		self.UNIT_NAME_UPDATE = core.UpdateName_6

	end

	local function PredatorSimple_focus(self)
		-- lib.debugging('entering PredatorSimple_focus()')

		-- self:SetAttribute('initial-height', 25)
		-- self:SetAttribute('initial-width', settings.options.focusframe_width)
		self:SetSize(settings.options.focusframe_width, 25)

	-- ***** HEALTH *****
		self.Health = core.CreateHealthBar(self, 25)

	-- ***** AllFrames *****
		core.AllFrames(self, 15)

	-- ***** Text-stuff *****
		self.Name = lib.CreateFontObject(self.Health, 16, settings.src.fonts['BloodCrow'])
		self.Name:SetTextColor(0.8, 0.8, 0.8)
		self.Name:SetPoint('BOTTOMLEFT', self.Health, 'LEFT', 5, 6)

		self.Health.value = lib.CreateFontObject(self.Health, 10, settings.src.fonts['Ebrima'])
		self.Health.value:SetPoint('RIGHT', self.Health, 'RIGHT', -2, 0)

	-- ***** RAIDICON *****
		self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
		self.RaidIcon:SetPoint('CENTER', self, 'BOTTOMLEFT', 0, 0)
		self.RaidIcon:SetWidth(18)
		self.RaidIcon:SetHeight(18)

	-- ***** BUFFS / DEBUFFS *****
		self.Buffs = CreateFrame('Frame', nil, self)
		self.Buffs:SetHeight(24)
		self.Buffs:SetWidth(24 * 4)
		self.Buffs.size = 24
		self.Buffs.spacing = 7
		self.Buffs.num = 3
		self.Buffs.initialAnchor = 'LEFT'
		self.Buffs['growth-x'] = 'RIGHT'
		self.Buffs:SetPoint('LEFT', self, 'RIGHT', 10, 0)
		self.Buffs.CreateIcon = lib.CreateAuraIcon
		self.Buffs.CustomFilter = core.FilterBuffs
		self.Buffs.PostUpdateIcon = core.PostUpdateIcon
		self.Debuffs = CreateFrame('Frame', nil, self)
		self.Debuffs:SetHeight(24)
		self.Debuffs:SetWidth(24 * 4)
		self.Debuffs.size = 24
		self.Debuffs.spacing = 7
		self.Debuffs.num = 3
		self.Debuffs.initialAnchor = 'RIGHT'
		self.Debuffs['growth-x'] = 'LEFT'
		self.Debuffs:SetPoint('RIGHT', self, 'LEFT', -10, 0)
		self.Debuffs.CreateIcon = lib.CreateAuraIcon
		self.Debuffs.CustomFilter = core.FilterDebuffs
		-- self.Debuffs.PostUpdateIcon = core.PostUpdateIcon

	-- ***** CASTBAR *****
		self.Castbar = core.CreateCastbar(self)

	-- ***** oUF-plugins *****
		core.ApplyPlugins(self)

	-- ***** ENGINES *****
		if (settings.options.healermode) then
			self.Health.PostUpdate = core.UpdateHealth_deficit
		else
			self.Health.PostUpdate = core.UpdateHealth_min
		end
		self.UNIT_NAME_UPDATE = core.UpdateName_16

	end

	local function PredatorSimple_party(self)
		-- lib.debugging('entering PredatorSimple_party()')

		-- self:SetAttribute('initial-height', 25)
		-- self:SetAttribute('initial-width', settings.options.partyframe_width)
		self:SetSize(settings.options.partyframe_width, 25)

	-- ***** HEALTH *****
		self.Health = core.CreateHealthBar(self, 22)

	-- ***** POWER *****
		self.Power = core.CreatePowerBar(self, 3)

	-- ***** AllFrames *****
		core.AllFrames(self, 10)

	-- ***** Text-stuff *****
		self.Name = lib.CreateFontObject(self.Health, 16, settings.src.fonts['BloodCrow'])
		self.Name:SetTextColor(0.8, 0.8, 0.8)
		self.Name:SetPoint('BOTTOMLEFT', self.Health, 'LEFT', 9, 6)

		self.Health.value = lib.CreateFontObject(self.Health, 10, settings.src.fonts['Ebrima'])
		self.Health.value:SetPoint('RIGHT', self.Health, 'RIGHT', -2, -2)

	-- ***** RAIDICON *****
		self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
		self.RaidIcon:SetPoint('CENTER', self, 'BOTTOMLEFT', 0, 0)
		self.RaidIcon:SetWidth(18)
		self.RaidIcon:SetHeight(18)

	-- ***** Fade out, if out-of-range *****
		self.Range = {}
		self.Range.outsideAlpha = 0.4
		self.Range.insideAlpha = 1.0

	-- ***** LFD *****
		if ( settings.options.dungeon_role ) then
			self.LFDRole = self.Health:CreateTexture(nil, 'OVERLAY')
			self.LFDRole:SetPoint('CENTER', self, 'TOPLEFT', 0, 0)
			self.LFDRole:SetWidth(14)
			self.LFDRole:SetHeight(14)
		end

	-- ***** oUF-plugins *****
		core.ApplyPlugins(self)

	-- ***** ENGINES *****
		if (settings.options.healermode) then
			self.Health.PostUpdate = core.UpdateHealth_deficit
		else
			self.Health.PostUpdate = core.UpdateHealth_min
		end
		self.UNIT_NAME_UPDATE = core.UpdateName_10

	end

	local function PredatorSimple_raid(self)
		-- lib.debugging('entering PredatorSimple_raid()')

		-- self:SetAttribute('initial-height', 20)
		if (settings.options.healermode) then
			-- self:SetAttribute('initial-width', settings.options.raidhealer_width)
			self:SetSize(settings.options.raidhealer_width, 20)
		else
			-- self:SetAttribute('initial-width', settings.options.raidframe_width)
			self:SetSize(settings.options.raidframe_width, 20)
		end

	-- ***** HEALTH *****
		self.Health = core.CreateHealthBar(self, 17)

	-- ***** POWER *****
		self.Power = core.CreatePowerBar(self, 3)

	-- ***** AllFrames *****
		core.AllFrames(self, 10)

	-- ***** Text-stuff *****
		self.Name = lib.CreateFontObject(self.Health, 14, settings.src.fonts['BloodCrow'])
		self.Name:SetTextColor(0.8, 0.8, 0.8)
		self.Name:SetPoint('CENTER', self, 'CENTER', 3, 2)

		self.Health.value = lib.CreateFontObject(self.Health, 10, settings.src.fonts['Ebrima'])
		self.Health.value:SetPoint('RIGHT', self.Health, 'RIGHT', -2, 0)

	-- ***** RAIDICON *****
		self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
		self.RaidIcon:SetWidth(15)
		self.RaidIcon:SetHeight(15)
		self.RaidIcon:SetPoint('CENTER', self, 'LEFT', 0, 0)

	-- ***** Fade out, if out-of-range *****
		self.Range = {}
		self.Range.outsideAlpha = 0.4
		self.Range.insideAlpha = 1.0

	-- ***** oUF-plugins *****
		core.ApplyPlugins(self)

	-- ***** ENGINES *****
		if (settings.options.healermode) then
			self.Health.PostUpdate = core.UpdateHealth_deficit_name
		else
			self.Health.PostUpdate = core.UpdateHealth_percent_name
		end
		self.UNIT_NAME_UPDATE = core.UpdateName_4

	end
	
-- *****************************************************
-- ***** ADDON_LOADED **********************************
-- *****************************************************
oUF_PredatorSimple:RegisterEvent('ADDON_LOADED')
oUF_PredatorSimple:SetScript('OnEvent', function(self, event, addon)
	if addon ~= ADDON_NAME then return end				-- jump out, if it's not our addon
	
	local k, v
	
	-- ***** Loading the SavedVars *************************
	
	--[[ Positions
		Check, if our positions in the SavedVars are present and set them to default, if not!
	]]
	if not PredatorSimplePositions then
		PredatorSimplePositions = {}
	end
	for k, v in pairs(settings.positions) do
		if type(v) ~= type(PredatorSimplePositions[k]) then
			PredatorSimplePositions[k] = v
		end
	end
	settings.positions = PredatorSimplePositions
	self.positions = settings.positions
	
	--[[ Options
		Check, if our options in the SavedVars are present and set them to default, if not!
	]]
	if not PredatorSimpleOptions then
		PredatorSimpleOptions = {}
	end
	for k, v in pairs(settings.options) do
		if type(v) ~= type(PredatorSimpleOptions[k]) then
			PredatorSimpleOptions[k] = v
		end
	end
	settings.options = PredatorSimpleOptions
	self.options = settings.options

	if not PredatorSimpleAuraList then
		PredatorSimpleAuraList = {}
		PredatorSimpleAuraList['locale'] = GetLocale()
	end

	-- ***** Spawning the Frames ***************************
    oUF:RegisterStyle('oUF_PredatorSimple_player', PredatorSimple_player)
    oUF:SetActiveStyle('oUF_PredatorSimple_player')
    oUF:Spawn('player', 'oUF_PredatorSimple_player'):SetPoint(settings.positions.playerframe.anchorPoint, settings.positions.playerframe.anchorToFrame, settings.positions.playerframe.anchorToPoint, settings.positions.playerframe.x, settings.positions.playerframe.y)
	-- *****************************************************
    oUF:RegisterStyle('oUF_PredatorSimple_pet', PredatorSimple_pet)
    oUF:SetActiveStyle('oUF_PredatorSimple_pet')
	oUF:Spawn('pet', 'oUF_PredatorSimple_pet'):SetPoint(settings.positions.petframe.anchorPoint, settings.positions.petframe.anchorToFrame, settings.positions.petframe.anchorToPoint, settings.positions.petframe.x, settings.positions.petframe.y)
	-- *****************************************************
    oUF:RegisterStyle('oUF_PredatorSimple_target', PredatorSimple_target)
    oUF:SetActiveStyle('oUF_PredatorSimple_target')
	oUF:Spawn('target', 'oUF_PredatorSimple_target'):SetPoint(settings.positions.targetframe.anchorPoint, settings.positions.targetframe.anchorToFrame, settings.positions.targetframe.anchorToPoint, settings.positions.targetframe.x, settings.positions.targetframe.y)
	-- *****************************************************
    oUF:RegisterStyle('oUF_PredatorSimple_targettarget', PredatorSimple_targettarget)
    oUF:SetActiveStyle('oUF_PredatorSimple_targettarget')
	oUF:Spawn('targettarget', 'oUF_PredatorSimple_targettarget'):SetPoint(settings.positions.targettarget.anchorPoint, settings.positions.targettarget.anchorToFrame, settings.positions.targettarget.anchorToPoint, settings.positions.targettarget.x, settings.positions.targettarget.y)
	-- *****************************************************
    oUF:RegisterStyle('oUF_PredatorSimple_focus', PredatorSimple_focus)
    oUF:SetActiveStyle('oUF_PredatorSimple_focus')
	oUF:Spawn('focus', 'oUF_PredatorSimple_focus'):SetPoint(settings.positions.focusframe.anchorPoint, settings.positions.focusframe.anchorToFrame, settings.positions.focusframe.anchorToPoint, settings.positions.focusframe.x, settings.positions.focusframe.y)
	-- *****************************************************
    oUF:RegisterStyle('oUF_PredatorSimple_party', PredatorSimple_party)
    oUF:SetActiveStyle('oUF_PredatorSimple_party')
	local party = oUF:SpawnHeader('oUF_PredatorSimple_party', 
									nil, 
									'party', 
									'showParty', true, 
									'yOffset', -15, 
									'xOffset', -20, 
									'showPlayer', true)
	if (settings.options.healermode) then
		party:SetPoint(settings.positions.partyframe_healer.anchorPoint, settings.positions.partyframe_healer.anchorToFrame, settings.positions.partyframe_healer.anchorToPoint, settings.positions.partyframe_healer.x, settings.positions.partyframe_healer.y)
	else
		party:SetPoint(settings.positions.partyframe.anchorPoint, settings.positions.partyframe.anchorToFrame, settings.positions.partyframe.anchorToPoint, settings.positions.partyframe.x, settings.positions.partyframe.y)
	end
	-- *****************************************************
    oUF:RegisterStyle('oUF_PredatorSimple_raid', PredatorSimple_raid)
    oUF:SetActiveStyle('oUF_PredatorSimple_raid')
	local raid = oUF:SpawnHeader('oUF_PredatorSimple_raid1', nil, nil, 'showRaid', true, 'yOffset', -10, 'xOffset', 5, 'groupFilter', 1)
	if (settings.options.healermode) then
		raid:SetPoint(settings.positions.raidframe_healer.anchorPoint, settings.positions.raidframe_healer.anchorToFrame, settings.positions.raidframe_healer.anchorToPoint, settings.positions.raidframe_healer.x, settings.positions.raidframe_healer.y)
	else
		raid:SetPoint(settings.positions.raidframe.anchorPoint, settings.positions.raidframe.anchorToFrame, settings.positions.raidframe.anchorToPoint, settings.positions.raidframe.x, settings.positions.raidframe.y)
	end
	raid = oUF:SpawnHeader('oUF_PredatorSimple_raid2', nil, 'raid', 'showRaid', true, 'yOffset', -10, 'xOffset', 5, 'groupFilter', 2)
	raid:SetPoint('TOPLEFT', 'oUF_PredatorSimple_raid1', 'TOPRIGHT', 10, 0)	
	raid = oUF:SpawnHeader('oUF_PredatorSimple_raid3', nil, 'raid', 'showRaid', true, 'yOffset', -10, 'xOffset', 5, 'groupFilter', 3)
	raid:SetPoint('TOPLEFT', 'oUF_PredatorSimple_raid2', 'TOPRIGHT', 10, 0)	
	raid = oUF:SpawnHeader('oUF_PredatorSimple_raid4', nil, 'raid', 'showRaid', true, 'yOffset', -10, 'xOffset', 5, 'groupFilter', 4)
	raid:SetPoint('TOPLEFT', 'oUF_PredatorSimple_raid3', 'TOPRIGHT', 10, 0)	
	raid = oUF:SpawnHeader('oUF_PredatorSimple_raid5', nil, 'raid', 'showRaid', true, 'yOffset', -10, 'xOffset', 5, 'groupFilter', 5)
	raid:SetPoint('TOPLEFT', 'oUF_PredatorSimple_raid4', 'TOPRIGHT', 10, 0)
	-- *****************************************************
    oUF:RegisterStyle('oUF_PredatorSimple_MT', PredatorSimple_focus)
    oUF:SetActiveStyle('oUF_PredatorSimple_MT')
	local maintank = oUF:SpawnHeader('oUF_PredatorSimple_MT', nil, 'raid', 'showRaid', true, 'yOffset', -15, 'groupFilter', 'MAINTANK')
	if (settings.options.healermode) then
		maintank:SetPoint(settings.positions.mtframe_healer.anchorPoint, settings.positions.mtframe_healer.anchorToFrame, settings.positions.mtframe_healer.anchorToPoint, settings.positions.mtframe_healer.x, settings.positions.mtframe_healer.y)
	else
		maintank:SetPoint(settings.positions.mtframe.anchorPoint, settings.positions.mtframe.anchorToFrame, settings.positions.mtframe.anchorToPoint, settings.positions.mtframe.x, settings.positions.mtframe.y)
	end

end)

-- Handling, wheather the Raid- or the Party-frame is shown
-- FIX: Quick'n'dirty fix until the oUF-conditions work again
local partyToggle = CreateFrame('Frame')        
partyToggle:RegisterEvent('PLAYER_LOGIN')
partyToggle:RegisterEvent('RAID_ROSTER_UPDATE')
partyToggle:RegisterEvent('PARTY_LEADER_CHANGED')
partyToggle:RegisterEvent('PARTY_MEMBERS_CHANGED')
partyToggle:SetScript('OnEvent', function(self)
	if(InCombatLockdown()) then
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
		-- this results in the following behaviour: If you're in a raid, the party frame will be hidden, no mather how many members
		-- your raid already has. This means, the party will be hidden, if the party leader clicks the button to create a raid.
		-- if you want to switch to raid view later (meaning, if the members not longer fit into the party frame), you may change the following line accordingly.
		if(GetNumRaidMembers() > 0) then
			_G['oUF_PredatorSimple_party']:Hide()
			_G['oUF_PredatorSimple_raid1']:Show()
			_G['oUF_PredatorSimple_raid2']:Show()
			_G['oUF_PredatorSimple_raid3']:Show()
			_G['oUF_PredatorSimple_raid4']:Show()
			_G['oUF_PredatorSimple_raid5']:Show()
		else
			_G['oUF_PredatorSimple_party']:Show()
			_G['oUF_PredatorSimple_raid1']:Hide()
			_G['oUF_PredatorSimple_raid2']:Hide()
			_G['oUF_PredatorSimple_raid3']:Hide()
			_G['oUF_PredatorSimple_raid4']:Hide()
			_G['oUF_PredatorSimple_raid5']:Hide()
		end
	end
end)