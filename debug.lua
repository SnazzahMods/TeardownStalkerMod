#include "util.lua"

local debugMenuEnabled = false
local mouseActive = false

function debugTick()
	if mouseActive then
		UiMakeInteractive()
	end

	checkDebugMenuToggles()
end

function debugDraw()
	if debugMenuEnabled then
		debugFlip = true
		drawDebugMenu()
	end
end

function checkDebugMenuToggles()
	if debugMenuEnabled and InputPressed("h") then
		mouseActive = not mouseActive
	end

	if InputDown("ctrl") and InputPressed("h") then
		debugMenuEnabled = not debugMenuEnabled

		if not debugMenuEnabled then
			mouseActive = false
		end
	end
end

function drawDebugMenu()
	UiPush()
		UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
		UiWordWrap(300)

		UiAlign("bottom right")
		UiTranslate(UiWidth(), UiHeight())

		UiFont("bold.ttf", 26)
		UiColor(0, 0, 0, 0.75)
		UiRect(300, 500)

		local textHeight = fixedWidth("STALKER Debug Menu", 300)
		UiTranslate(-150, -500 - textHeight)
		UiAlign("top center")

		local h
		UiColor(1, 0.25, 0.25)
		UiTextShadow(0, 0, 0, 0.5, 2.0)
		h = fixedWidthText("STALKER Debug Menu", 300)
		UiTranslate(0, h)
		UiFont("regular.ttf", 26)

		UiTranslate(0, 5)
		UiColor(1, 1, 1, 1)
		UiText("Press H to toggle mouse input.")

		UiTranslate(0, 30)
		local pauseText = "Pause Stalker/Timer"
		if figurePaused then
			pauseText = "Resume Stalker/Timer"
		end
		if UiTextButton(pauseText, 220, 30) then
			figurePaused = not figurePaused
		end

		UiTranslate(0, 40)
		local timerText = "Reset Timer"
		if UiTextButton(timerText, 220, 30) then
			timeTillSpawn = ttsDefault
		end

		UiTranslate(0, 40)
		local fogText = "Stop Fog Rendering"
		if not renderFog then
			fogText = "Render Fog"
		end
		if UiTextButton(fogText, 220, 30) then
			renderFog = not renderFog
		end

		if timeTillSpawn > 0 and not figureSpawned then
			UiTranslate(0, 40)
			local spawnText = "Spawn Stalker"
			if UiTextButton(spawnText, 220, 30) then
				timeTillSpawn = 0
			end
		end

		UiAlign("top left")
		UiTranslate(-150, 60)
		UiFont("bold.ttf", 26)
		UiText("Global Variables")


		UiFont("regular.ttf", 20)
		UiTranslate(0, 30)
		UiText("Distance: " .. distance)

		UiTranslate(0, 20)
		UiText("Time Till Spawn: " .. timeTillSpawn)

		UiTranslate(0, 20)
		UiText("Figure Position: " .. VecToString(figurePos))

		UiTranslate(0, 20)
		UiText("Killed: " .. tostring(killed))

		UiTranslate(0, 20)
		UiText("Figure Spawned: " .. tostring(figureSpawned))

		UiTranslate(0, 20)
		UiText("Figure Visible: " .. tostring(figureVisible))

		UiTranslate(0, 20)
		UiText("Figure Walkspeed: " .. tostring(walkSpeed))
	UiPop()
end