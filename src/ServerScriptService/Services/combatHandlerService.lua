local Knit = require(game:GetService("ReplicatedStorage").Knit)

local combatHandlerService = Knit.CreateService {
    Name = "combatHandlerService";
    Client = {};
}
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
combatHandlerService.Client.handleMove = RemoteSignal.new()
combatHandlerService.Client.screenR = RemoteSignal.new()


function combatHandlerService:KnitStart()
    
end



function combatHandlerService:KnitInit()
    self.Client.handleMove:Connect(function(Player, Action, Bool)
        local PunchDebounce = false
local CanUseSkill = true
local HeavyDebounce = false
local DashDebounce = false
local BlockingDebounce = false
local CanDoAnything = true

local DoingCombo = 0
local Combo = 1
local Block = false
local IsPunching = false
local isBlocking = false

	local Char = Player.Character
	local Hum = Char:WaitForChild("Humanoid")
	local HumRP = Char:WaitForChild("HumanoidRootPart")
    local TweenService = game:GetService("TweenService")

	local Anims = script:WaitForChild("Anims")
	local Sounds = script:WaitForChild("Sounds")
	local FX = script:WaitForChild("FX")
	local HitAnims = script:WaitForChild("HitAnims")

	local Punch1 = Hum:LoadAnimation(Anims:WaitForChild("Combo1"))
	local Punch2 = Hum:LoadAnimation(Anims:WaitForChild("Combo2"))
	local Punch3 = Hum:LoadAnimation(Anims:WaitForChild("Combo3"))
	local Punch4 = Hum:LoadAnimation(Anims:WaitForChild("Combo4"))
	local BlockAnim = Hum:LoadAnimation(Anims:WaitForChild("Block"))

	local Dmg1 = 5
	local Dmg2 = 5
	local Dmg3 = 7
	local Dmg4 = 10

	local InsertDisabled = function(Target,Time)
		local Disabled = Instance.new("BoolValue",Target)
		Disabled.Name = "Disabled"
		game.Debris:AddItem(Disabled,Time)
	end

	local HiteffectBall = function(Target,Pos)
		local ClonedBall = FX.Thing:Clone()
		ClonedBall.Parent = Target
		ClonedBall.CFrame = Pos
		ClonedBall.CFrame = CFrame.new(ClonedBall.Position, Target.Position)
		game.Debris:AddItem(ClonedBall,1)

		if DoingCombo == 4 then
			ClonedBall.BrickColor = BrickColor.new("Neon orange")
		end

		TweenService:Create(ClonedBall,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{CFrame = ClonedBall.CFrame + ClonedBall.CFrame.lookVector * -7,Transparency = 1,Size = Vector3.new(0.087, 0.08, 3.35)}):Play()
	end

	local DmgVisual = function(Target)
		local BillBoard = FX:WaitForChild("DmgVisuals"):Clone()
		BillBoard.Parent = Target

		local Goal = {}
		Goal.StudsOffset = Vector3.new(0,4,0)
		local Info = TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut)
		local Tween = TweenService:Create(BillBoard,Info,Goal)
		Tween:Play()

		game.Debris:AddItem(BillBoard,1)

		if DoingCombo == 1 then
			BillBoard.Text.Text = Dmg1.."!"

		elseif DoingCombo == 2 then
			BillBoard.Text.Text = Dmg2.."!"

		elseif DoingCombo == 3 then
			BillBoard.Text.Text = Dmg3.."!"

		elseif DoingCombo == 4 then
			BillBoard.Text.Text = Dmg4.."!"

		end
	end

	local HitDmg = function(Target,Action2)
		if Action2 == "Blocking" then
			if DoingCombo == 1 then
				Target:TakeDamage(Dmg1 - 3)
			elseif DoingCombo == 2 then
				Target:TakeDamage(Dmg2 - 3)
			elseif DoingCombo == 3 then
				Target:TakeDamage(Dmg3 - 4)
			elseif DoingCombo == 4 then
				Target:TakeDamage(Dmg4 - 5)
			end
		else
			if DoingCombo == 1 then
				Target:TakeDamage(Dmg1)
			elseif DoingCombo == 2 then
				Target:TakeDamage(Dmg2)
			elseif DoingCombo == 3 then
				Target:TakeDamage(Dmg3)
			elseif DoingCombo == 4 then
				Target:TakeDamage(Dmg4)
			end
		end
	end

	local Hiteffect3 = function(Target)

		local Count = 0
		repeat
			Count = Count + 1
			HiteffectBall(Target,Target.CFrame * CFrame.new(math.random(-1,1),math.random(-1,1),math.random(-1,1)))
		until Count >= 5

		if DoingCombo == 4 then

			local Sound = Sounds.Hitkick:Clone()
			Sound.Parent = Target
			Sound.PlaybackSpeed = math.random(93,107)/100
			Sound:Play()
			game.Debris:AddItem(Sound,1.5)
		else
			local Sound = Sounds.Punch1:Clone()
			Sound.Parent = HumRP
			Sound.PlaybackSpeed = math.random(93,107)/100
			Sound:Play()
			game.Debris:AddItem(Sound,0.4)	
		end

		local GoreFX = FX.Gore:Clone()
		GoreFX.Parent = Target
		GoreFX:Emit(1)
		game.Debris:AddItem(GoreFX,1)
	end

	if Action == "NormalPunch" then
		if Char:FindFirstChild("Disabled") == nil and CanUseSkill == true and PunchDebounce == false and Char:FindFirstChild("Blocking") == nil then
			PunchDebounce = true

			local LatestWalkSpeed = 16

			Hum.WalkSpeed = 12

			CanUseSkill = false
			delay(0.4,function()
				CanUseSkill = true
			end)

			PunchDebounce = true

			delay(0.4,function()
				Hum.WalkSpeed = LatestWalkSpeed
				IsPunching = false
				if DoingCombo == 4 then
					wait(0.8)
					PunchDebounce = false
				else
					PunchDebounce = false
				end
			end)

			IsPunching = true

			if Combo == 1 then
				Punch1:Play()


				DoingCombo = 1
				Combo = 2
				delay(1,function()
					if Combo == 2 then
						Combo = 1
					end
				end)
			elseif Combo == 2 then
				Punch2:Play()

				DoingCombo = 2
				Combo = 3
				delay(1,function()
					if Combo == 3 then
						Combo = 1
					end
				end)
			elseif Combo == 3 then
				Punch3:Play()

				DoingCombo = 3
				Combo = 4
				delay(1,function()
					if Combo == 4 then
						Combo = 1
					end
				end)	
			elseif Combo == 4 then
				Punch4:Play()

				DoingCombo = 4
				Combo = 1
			end	

			local folder = Instance.new("Folder",workspace)
			folder.Name = Player.Name.." FX"
			game.Debris:AddItem(folder,0.4)

			delay(0.13,function()

				local hitbox = script.PunchHitbox:Clone()
				hitbox.Anchored = false
				hitbox.CanCollide= false
				hitbox.Massless = true
				if DoingCombo == 2 or DoingCombo == 3 then
					hitbox.CFrame = Char["Left Arm"].CFrame
				elseif DoingCombo == 1 then
					hitbox.CFrame = Char["Right Arm"].CFrame
				elseif DoingCombo == 4 then
					hitbox.CFrame = Char["Left Leg"].CFrame
				end
				hitbox.Parent = folder

				local weld = Instance.new("ManualWeld")
				if DoingCombo == 2 or DoingCombo == 3 then
					weld.Part0 = Char["Left Arm"]
				elseif DoingCombo == 1 then
					weld.Part0 = Char["Right Arm"]
				elseif DoingCombo == 4 then
					weld.Part0 = Char["Left Leg"]
				end
				weld.Part1 = hitbox
				if DoingCombo == 2 or DoingCombo == 3 then
					weld.C0 = hitbox.CFrame:inverse() * Char["Left Arm"].CFrame
				elseif DoingCombo == 1 then
					weld.C0 = hitbox.CFrame:inverse() * Char["Right Arm"].CFrame
				elseif DoingCombo == 4 then
					weld.C0 = hitbox.CFrame:inverse() * Char["Left Leg"].CFrame
				end
				weld.Parent = hitbox

				hitbox.Touched:Connect(function(Hit)
					if Hit.Parent ~= Char and Char:FindFirstChild("Disabled") == nil then
						local EHum = Hit.Parent:FindFirstChild("Humanoid")
						local EHumRP = Hit.Parent:FindFirstChild("HumanoidRootPart")
						if EHum and EHumRP then
							if EHum.Parent:FindFirstChild("Blocking") then
								folder:Destroy()
								HitDmg(EHum,"Blocking")

                                self.Client.screenR:Fire(Player)
								--ScreenR:FireClient(Player)

								EHum.WalkSpeed = 2
								delay(0.65,function()
									EHum.WalkSpeed = 16
								end)

								InsertDisabled(EHumRP.Parent,0.7)

								local BlockSound = Sounds.BlockPunch:Clone()
								BlockSound.Parent = EHumRP
								BlockSound.PlaybackSpeed = math.random(93,107)/100
								BlockSound:Play()
								game.Debris:AddItem(BlockSound,0.4)	

								local BlockParticle = FX.Block:Clone()
								BlockParticle.Parent = EHumRP
								BlockParticle:Emit(1)
								game.Debris:AddItem(BlockParticle,1)
							else
								hitbox:Destroy()
								HitDmg(EHum)

								local FindBV = EHum.Parent:FindFirstChild("BodyVelocity")
								if FindBV then
									FindBV:Destroy()
								end

								if DoingCombo == 4 then
									local Pos = HumRP.CFrame*CFrame.new(0,4,-20)

									local BP = Instance.new("BodyPosition",EHumRP)
									BP.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
									BP.D = 80
									BP.P = 400
									BP.Position = Pos.p
									game.Debris:AddItem(BP,0.4)
								end	

								if DoingCombo == 1 then
									local FirstHit = EHum:LoadAnimation(HitAnims.First)
									FirstHit:Play()

								elseif DoingCombo == 2 then
									local SecondHit = EHum:LoadAnimation(HitAnims.Second)
									SecondHit:Play()

								elseif DoingCombo == 3 then
									local ThirdHit = EHum:LoadAnimation(HitAnims.Third)
									ThirdHit:Play()

								elseif DoingCombo == 4 then
									local FourthHit = EHum:LoadAnimation(HitAnims.Fourth)
									FourthHit:Play()

								end

                                self.Client.screenR:Fire(Player)
								--ScreenR:FireClient(Player)

								EHum.WalkSpeed = 2
								delay(0.6,function()
									EHum.WalkSpeed = 16
								end)

								InsertDisabled(EHumRP.Parent,0.7)

								Hiteffect3(EHumRP)
							end
						end

					end
				end)
			end)	
		end
	elseif Action == "Block" then
		if Bool == false and isBlocking == true then
			BlockingDebounce = true
			delay(.65,function()
				BlockingDebounce = false
			end)

			isBlocking = false

			delay(0.4,function()
				CanDoAnything = true
			end)

			local AnimationTracks = Hum:GetPlayingAnimationTracks()
			for i, track in pairs (AnimationTracks) do
				track:Stop()
			end

			Hum.JumpPower = 50
			Hum.WalkSpeed = 16

			local Value = Char:FindFirstChild("Blocking")
			if Value then
				Value:Destroy()
			end
		elseif Char:FindFirstChild("Disabled") == nil and CanDoAnything == true and Bool == true and BlockingDebounce == false and isBlocking == false then
			isBlocking = true
			CanDoAnything = false

			Hum.JumpPower = 0

			BlockAnim:Play()

			Hum.WalkSpeed = 5

			local Value = Instance.new("BoolValue",Char)
			Value.Name = "Blocking"
		end	
	end
    end)

end


return combatHandlerService