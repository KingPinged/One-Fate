local Knit = require(game:GetService("ReplicatedStorage"):WaitForChild("Knit"))
local combatHandlerService = Knit.GetService("combatHandlerService")

--local Remote = script:WaitForChild("Combat")
--local ScreenR = game.ReplicatedStorage:WaitForChild("ScreenShake")

local Player = game.Players.LocalPlayer

local UIS = game:GetService("UserInputService")


game.ReplicatedStorage.workspace.knitReady.Changed:Wait()

print("WOW TEST COMPLETE! DOGOO WOOOOOW")
--combatHandlerService.handleMove:Fire()
--Remote:FireServer()

local Blocking = false

local RunService = game:GetService("RunService")

wait(1)

UIS.InputBegan:Connect(function(Input,IsTyping)
	if IsTyping then return end

	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        --Remote:FireServer("NormalPunch")
        combatHandlerService.handleMove:Fire("NormalPunch")
			
    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
        combatHandlerService.handleMove:Fire("HeavyPunch")
		--Remote:FireServer("HeavyPunch")
	end	
end)

combatHandlerService.screenR:Connect(function(Action)
	local Hum = Player.Character:WaitForChild("Humanoid")
	if Action == "Last" then
		for i = 1, 12 do
			local x = math.random(-20,20)/100
			local y = math.random(-20,20)/100
			local z = math.random(-20,20)/100

			Hum.CameraOffset = Vector3.new(x,y,z)
			wait()
		end
		Hum.CameraOffset = Vector3.new(0,0,0)
	else
		for i = 1, 5 do
			local x = math.random(-15,15)/100
			local y = math.random(-15,15)/100
			local z = math.random(-15,15)/100

			Hum.CameraOffset = Vector3.new(x,y,z)
			wait()
		end

		Hum.CameraOffset = Vector3.new(0,0,0)
	end	
end)

RunService.RenderStepped:Connect(function()
	local Char = Player.Character or Player.CharacterAdded:Wait()

	if UIS:IsKeyDown(Enum.KeyCode.F) then
		--print("pressed")
			if Blocking == false then
                Blocking = true
                combatHandlerService.handleMove:Fire("Block",true)
			--Remote:FireServer("Block",true)
			end	
	else
		if Blocking == true then
            Blocking = false
            combatHandlerService.handleMove:Fire("Block",false)
			--Remote:FireServer("Block",false)
		end
	end
end)	