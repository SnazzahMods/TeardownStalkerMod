moddataPrefix = "savegame.mod.stalkerMod"
currentDataVersion = 2

function migrateData()
	dataVersion = GetInt(moddataPrefix .. "Version")

	-- Migrate Data
	if dataVersion < 1 then
		SetBool(moddataPrefix .. "Invisible", false)
		SetBool(moddataPrefix .. "Silent", false)
		SetBool(moddataPrefix .. "Destructive", false)
		SetBool(moddataPrefix .. "BadFog", false)
		SetBool(moddataPrefix .. "HalfTime", false)
		SetBool(moddataPrefix .. "MoreSpeed", false)
		SetString(moddataPrefix .. "Sprite", "default")
		SetString(moddataPrefix .. "SoundLoop", "whisper")
	end

	if dataVersion < 2 then
		SetBool(moddataPrefix .. "BGMusic", true)
		SetBool(moddataPrefix .. "RenderFog", true)
	end

	SetInt(moddataPrefix .. "Version", currentDataVersion)
	dataVersion = currentDataVersion
end

function dataInit()
	migrateData()

	figureVisible = not GetBool(moddataPrefix .. "Invisible")
	figureSilent = GetBool(moddataPrefix .. "Silent")
	figureDestructive = GetBool(moddataPrefix .. "Destructive")
	fogDifficult = GetBool(moddataPrefix .. "BadFog")
	timeHalf = GetBool(moddataPrefix .. "HalfTime")
	figureMoreSpeed = GetBool(moddataPrefix .. "MoreSpeed")
	figureSpriteFile = GetString(moddataPrefix .. "Sprite")
	figureSoundFile = GetString(moddataPrefix .. "SoundLoop")
	playBGMusic = GetBool(moddataPrefix .. "BGMusic")
	renderFog = GetBool(moddataPrefix .. "RenderFog")

	-- Apply Data
	figureSpritePath = "MOD/sprites/stalkers/" .. figureSpriteFile .. ".png"
	figureSoundPath = "MOD/sfx/stalker/" .. figureSoundFile .. ".ogg"
	if timeHalf then
		ttsDefault = 5
		timeTillSpawn = 5
	end

	if figureMoreSpeed then
		baseWalkSpeed = 5.5
	end
end

--#region Vector Util
	function VecDirection(a, b)
		return VecNormalize(VecSub(b, a))
	end

	function VecDistance(a, b)
		local directionVector = VecSub(b, a)
		local distance = VecMag(directionVector)
		return distance
	end

	function VecMag(a)
		return math.sqrt(a[1]^2 + a[2]^2 + a[3]^2)
	end

	function VecToString(vec)
		return ToFixed(vec[1], 2) .. ", " .. ToFixed(vec[2], 2) .. ", " .. ToFixed(vec[3], 2)
	end
--#endregion

 --#region Draw Util
	function fixedWidthText(txt, width)
		if txt == "" then
			return 0
		else
			UiPush()
				local w, h = UiGetTextSize(txt)
				local scale = width / w
				UiScale(scale)
				UiText(txt)
			UiPop()
			return h * scale
		end
	end

	function fixedWidth(txt, width)
		if txt == "" then
			return 0
		else
			UiPush()
				local w, h = UiGetTextSize(txt)
				local scale = width / w
			UiPop()
			return h * scale
		end
	end
--#endregion

-- http://stackoverflow.com/questions/1426954/ddg#7615129
function splitString(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function stringLeftPad(str, len, char)
	if char == nil then char = ' ' end
	return str .. string.rep(char, len - #str)
end

function ToFixed(a, points)
	local pow = math.pow(10, points)
	return math.floor(a * pow)/pow
end

function tableToText(inputTable, loopThroughTables)
	loopThroughTables = loopThroughTables or true

	local returnString = "{ "
	for key, value in pairs(inputTable) do
		if type(value) == "string" or type(value) == "number" then
			returnString = returnString .. key .." = " .. value .. ", "
		elseif type(value) == "table" and loopThroughTables then
			returnString = returnString .. key .. " = " .. tableToText(value) .. ", "
		else
			returnString = returnString .. key .. " = " .. tostring(value) .. ", "
		end
	end
	returnString = returnString .. "}"

	return returnString
end
