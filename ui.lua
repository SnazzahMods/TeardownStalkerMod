#include "util.lua"

function drawEffectsText()
	UiPush()
		UiAlign("top left")
		UiTranslate(20, 20)
		if string.find(GetString("game.levelid"), "hub") then
			UiTranslate(0, 40)
		end
		UiTextShadow(0, 0, 0, 0.25, 2.0)
		UiFont("MOD/ui/stranger.ttf", 50)
		UiColor(1, 0.25, 0.25, 0.75)
		UiText("Stalker Mod")
		UiTranslate(0, 20)

		UiColor(1, 0.25, 0.25, 0.75)
		UiFont("regular.ttf", 20)
		UiTextShadow(0, 0, 0, 0.1, 1.0)

		if not renderFog then
			UiTranslate(0, 20)
			UiText("Fog Disabled")
		end

		UiColor(1, 1, 1, 0.75)

		if not figureVisible then
			UiTranslate(0, 20)
			UiText("Invisible")
		end

		if figureSilent then
			UiTranslate(0, 20)
			UiText("Silent")
		end

		if figureDestructive then
			UiTranslate(0, 20)
			UiText("Destructive")
		end

		if fogDifficult and renderFog then
			UiTranslate(0, 20)
			UiText("Terrible Fog")
		end

		if timeHalf then
			UiTranslate(0, 20)
			UiText("Rushed Out")
		end

		if figureMoreSpeed then
			UiTranslate(0, 20)
			UiText("Swift Killer")
		end

		if debugFlip then
			UiColor(1, 1, 1, 0.1)
			UiTranslate(0, 20)
			UiText("Debug")
		end
	UiPop()
end

uiTimerHeight = 65
uiTimerHeightAdd = 0
uiTimerAnimStarted = false
uiTimerMayhemAnimStarted = false

function drawTimer()
	if timeTillSpawn >= 0 and not figureSpawned then
		UiPush()
			UiFont("MOD/ui/darkmage.ttf", 32)
			UiPush()
				-- Handle Timer FX
				local shakeX = 0
				local shakeY = 0
				local warnAmount = 0
				if timeTillSpawn < 6 then
					warnAmount = (6 - timeTillSpawn) / 6
					local shakeDist = 5
					shakeX = math.random(-(shakeDist * warnAmount), (shakeDist * warnAmount))
					shakeY = math.random(-(shakeDist * warnAmount), (shakeDist * warnAmount))
				end

				UiTranslate(UiCenter() + shakeX, uiTimerHeight + uiTimerHeightAdd + shakeY)
				UiAlign("center")
				UiTextOutline(0, 0, 0, 2)
				local colorDist = 0.5 + (warnAmount * 0.5)
				UiColor(colorDist, 0, 0)
				UiScale(2.0)
				if timeTillSpawn <= 60 then
					local decSplit = splitString(tostring(timeTillSpawn), '.')
					local decimals = '00'
					if decSplit[2] ~= nil then
						decimals = stringLeftPad(string.sub(decSplit[2], 0, 2), 2, '0')
					end
					UiText(decSplit[1] .. '.' .. decimals)
				else
					local t = math.ceil(timeTillSpawn)
					local m = math.floor(t/60)
					local s = math.ceil(t-m*60)
					if s < 10 then
						UiText(m .. ":0" .. s)
					else
						UiText(m .. ":" .. s)
					end
				end
			UiPop()
		UiPop()
	end
end

function drawSpawnFX()
	if uiShowSpawnFX and uiSpawnFXTime > 0 then
		UiPush()
			UiFont("MOD/ui/darkmage.ttf", 32)
			UiPush()
				-- Don't draw over alarm
				local uiHeight = 70
				if GetBool("level.alarm") then
					uiHeight = 130
				end

				local shakeX = math.random(-10, 10)
				local shakeY = math.random(-10, 10)

				UiTranslate(UiCenter() + shakeX, uiTimerHeight + uiTimerHeightAdd + shakeY)
				UiAlign("center")
				UiColor(1, 0, 0, uiSpawnFXTime)
				UiScale(3.0)
				UiText('RUN')

				uiSpawnFXTime = uiSpawnFXTime - (GetTimeStep() / 3)
			UiPop()
		UiPop()
	end
end

function uiTick()
	-- Make sure not to overlay HUD
	local id = GetString("game.levelid")
	local mayhem = string.find(id,  "_mayhem")
	if GetBool("level.alarm") or mayhem and GetTime() > 3.3 then
		local h = 0
		if mayhem then h = 40 end
		if not uiTimerAnimStarted then
			SetValue("uiTimerHeightAdd", 60 + h, "linear", 0.5)
			uiTimerAnimStarted = true
		end
	end
	if mayhem and GetTime() > 7 then
		if not uiTimerMayhemAnimStarted then
			SetValue("uiTimerHeightAdd", 60, "linear", 0.5)
			uiTimerMayhemAnimStarted = true
		end
	end
end