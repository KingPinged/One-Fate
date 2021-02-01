local combatPlayer = {}
combatPlayer.__index = combatPlayer

function combatPlayer.new(player,combatRay, event)
    local self = setmetatable({}, combatPlayer)
    self.TweenService = game:GetService("TweenService")
	self.player = player
	local Char = player.Character
	local Hum = Char.Humanoid
	local HumRP = Char.HumanoidRootPart


			
	self.folder = player.FX


    self.PunchDebounce = false
    self.CanUseSkill = true
    self.HeavyDebounce = false
    self.DashDebounce = false
    self.BlockingDebounce = false
    self.CanDoAnything = true

    self.Anims = game.ServerStorage.Storage.combat:WaitForChild("Anims")
	self.Sounds = game.ServerStorage.Storage.combat:WaitForChild("Sounds")
	self.FX = game.ServerStorage.Storage.combat:WaitForChild("FX")
	self.HitAnims = game.ServerStorage.Storage.combat:WaitForChild("HitAnims")

	local cloned = game.ServerStorage.Storage.combat:WaitForChild("PunchHitbox"):Clone()
	cloned.Parent = player.Character
	cloned.CFrame = Char["Right Arm"].CFrame

	local weld = Instance.new("ManualWeld")
	weld.Part0 = Char["Right Arm"]
	weld.Part1 = cloned
	weld.C0 = cloned.CFrame:inverse() * Char["Right Arm"].CFrame
	weld.Parent = cloned

	self.PunchHitbox = cloned
	--self.PunchHitbox.Parent = self.folder
	self.newHitbox = combatRay:Initialize(cloned, {Char})
	local newHitbox = self.newHitbox
				newHitbox:HitStop()

				newHitbox.OnHit:Connect(function(Hit, EHum)
					if  Char:FindFirstChild("Disabled") == nil then
						local EHumRP = Hit.Parent:FindFirstChild("HumanoidRootPart")
						if EHum and EHumRP then
							newHitbox:HitStop()
							--self.PunchHitbox:ClearAllChildren()
							if EHum.Parent:FindFirstChild("Blocking") then
								--self.folder:ClearAllChildren()
								self:HitDmg(EHum,"Blocking")

								event:Fire(player)
                                --self.Client.screenR:Fire(self.player)
								--ScreenR:FireClient(Player)

								EHum.WalkSpeed = 2
								delay(0.65,function()
									EHum.WalkSpeed = 16
								end)

								self.InsertDisabled(EHumRP.Parent,0.7)

								local BlockSound = self.Sounds.BlockPunch:Clone()
								BlockSound.Parent = EHumRP
								BlockSound.PlaybackSpeed = math.random(93,107)/100
								BlockSound:Play()
								--game.Debris:AddItem(BlockSound,0.4)	

								local BlockParticle = self.FX.Block:Clone()
								BlockParticle.Parent = EHumRP
								BlockParticle:Emit(1)
								--game.Debris:AddItem(BlockParticle,1)
							else
								--hitbox:Destroy()
								self:HitDmg(EHum)

								local FindBV = EHum.Parent:FindFirstChild("BodyVelocity")
								if FindBV then
									FindBV:Destroy()
								end

								if self.DoingCombo == 4 then
									local Pos = HumRP.CFrame*CFrame.new(0,4,-20)

									local BP = Instance.new("BodyPosition",EHumRP)
									BP.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
									BP.D = 80
									BP.P = 400
									BP.Position = Pos.p
									game.Debris:AddItem(BP,0.4)
								end	

								if self.DoingCombo == 1 then
									local FirstHit = EHum:LoadAnimation(self.HitAnims.First)
									FirstHit:Play()

								elseif self.DoingCombo == 2 then
									local SecondHit = EHum:LoadAnimation(self.HitAnims.Second)
									SecondHit:Play()

								elseif self.DoingCombo == 3 then
									local ThirdHit = EHum:LoadAnimation(self.HitAnims.Third)
									ThirdHit:Play()

								elseif self.DoingCombo == 4 then
									local FourthHit = EHum:LoadAnimation(self.HitAnims.Fourth)
									FourthHit:Play()

								end

								event:Fire(player)

								EHum.WalkSpeed = 2
								delay(0.6,function()
									EHum.WalkSpeed = 16
								end)

								self.InsertDisabled(EHumRP.Parent,0.7)

								self:Hiteffect3(EHumRP)
							end
						end

					end
				end)
    

	self.Punch1 = Hum:LoadAnimation(self.Anims:WaitForChild("Combo1"))
	self.Punch2 = Hum:LoadAnimation(self.Anims:WaitForChild("Combo2"))
	self.Punch3 = Hum:LoadAnimation(self.Anims:WaitForChild("Combo3"))
	self.Punch4 = Hum:LoadAnimation(self.Anims:WaitForChild("Combo4"))
    self.BlockAnim = Hum:LoadAnimation(self.Anims:WaitForChild("Block"))
    
    self.damages = {
        Dmg1 = 5,
        Dmg2 = 5,
        Dmg3 = 7,
        Dmg4 = 10
    }
    
    self.DoingCombo = 0
    self.Combo = 1
    self.Block = false
    self.IsPunching = false
    self.isBlocking = false
    return self
end

function combatPlayer.InsertDisabled(Target, Time)
    local Disabled = Instance.new("BoolValue",Target)
    Disabled.Name = "Disabled"
    --game.Debris:AddItem(Disabled,Time)
end

function combatPlayer:HiteffectBall(Target, Pos)
	local ClonedBall = self.FX.Thing:Clone()
		ClonedBall.Parent = Target
		ClonedBall.CFrame = Pos
		ClonedBall.CFrame = CFrame.new(ClonedBall.Position, Target.Position)
	--	game.Debris:AddItem(ClonedBall,1)

		if self.DoingCombo == 4 then
			ClonedBall.BrickColor = BrickColor.new("Neon orange")
		end

		self.TweenService:Create(ClonedBall,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{CFrame = ClonedBall.CFrame + ClonedBall.CFrame.lookVector * -7,Transparency = 1,Size = Vector3.new(0.087, 0.08, 3.35)}):Play()
end

function combatPlayer:DmgVisual(Target)
    local BillBoard = self.FX:WaitForChild("DmgVisuals"):Clone()
    BillBoard.Parent = Target

    local Goal = {}
    Goal.StudsOffset = Vector3.new(0,4,0)
    local Info = TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut)
    local Tween = self.TweenService:Create(BillBoard,Info,Goal)
    Tween:Play()

   -- game.Debris:AddItem(BillBoard,1)

    if self.DoingCombo == 1 then
        BillBoard.Text.Text = self.damages.Dmg1.."!"

    elseif self.DoingCombo == 2 then
        BillBoard.Text.Text = self.damages.Dmg2.."!"

    elseif self.DoingCombo == 3 then
        BillBoard.Text.Text = self.damages.Dmg3.."!"

    elseif self.DoingCombo == 4 then
        BillBoard.Text.Text = self.damages.Dmg4.."!"

    end
end

function combatPlayer:HitDmg(Target,Action2)
    if Action2 == "Blocking" then
        if self.DoingCombo == 1 then
            Target:TakeDamage(self.damages.Dmg1 - 3)
        elseif self.DoingCombo == 2 then
            Target:TakeDamage(self.damages.Dmg2 - 3)
        elseif self.DoingCombo == 3 then
            Target:TakeDamage(self.damages.Dmg3 - 4)
        elseif self.DoingCombo == 4 then
            Target:TakeDamage(self.damages.Dmg4 - 5)
        end
    else
        if self.DoingCombo == 1 then
            Target:TakeDamage(self.damages.Dmg1)
        elseif self.DoingCombo == 2 then
            Target:TakeDamage(self.damages.Dmg2)
        elseif self.DoingCombo == 3 then
            Target:TakeDamage(self.damages.Dmg3)
        elseif self.DoingCombo == 4 then
            Target:TakeDamage(self.damages.Dmg4)
        end
    end
end

function combatPlayer:Hiteffect3(Target)
    local Count = 0
    repeat
        Count = Count + 1
        self:HiteffectBall(Target,Target.CFrame * CFrame.new(math.random(-1,1),math.random(-1,1),math.random(-1,1)))
    until Count >= 5

    if self.DoingCombo == 4 then

        local Sound = self.Sounds.Hitkick:Clone()
        Sound.Parent = Target
        Sound.PlaybackSpeed = math.random(93,107)/100
        Sound:Play()
      --  game.Debris:AddItem(Sound,1.5)
    else
        local Sound = self.Sounds.Punch1:Clone()
        Sound.Parent = self.HumRP
        Sound.PlaybackSpeed = math.random(93,107)/100
        Sound:Play()
       -- game.Debris:AddItem(Sound,0.4)	
    end

    local GoreFX = self.FX.Gore:Clone()
    GoreFX.Parent = Target
    GoreFX:Emit(1)
   -- game.Debris:AddItem(GoreFX,1)
end

function combatPlayer:action(Action,Bool)

    local Char = self.player.Character
	local Hum = Char.Humanoid
	local HumRP = Char.HumanoidRootPart

	if Action == "NormalPunch" then
		if Char:FindFirstChild("Disabled") == nil and self.CanUseSkill == true and self.PunchDebounce == false and Char:FindFirstChild("Blocking") == nil then
			self.PunchDebounce = true

			local LatestWalkSpeed = 16

			Hum.WalkSpeed = 12

			self.CanUseSkill = false
			delay(0.4,function()
				self.CanUseSkill = true
			end)

			self.PunchDebounce = true

			delay(0.4,function()
				Hum.WalkSpeed = LatestWalkSpeed
				self.IsPunching = false
				if self.DoingCombo == 4 then
					wait(0.8)
					self.PunchDebounce = false
				else
					self.PunchDebounce = false
				end
			end)

			self.IsPunching = true

			if self.Combo == 1 then
				self.Punch1:Play()


				self.DoingCombo = 1
				self.Combo = 2
				delay(1,function()
					if self.Combo == 2 then
						self.Combo = 1
					end
				end)
			elseif self.Combo == 2 then
				self.Punch2:Play()

				self.DoingCombo = 2
				self.Combo = 3
				delay(1,function()
					if self.Combo == 3 then
						self.Combo = 1
					end
				end)
			elseif self.Combo == 3 then
				self.Punch3:Play()

				self.DoingCombo = 3
				self.Combo = 4
				delay(1,function()
					if self.Combo == 4 then
						self.Combo = 1
					end
				end)	
			elseif self.Combo == 4 then
				self.Punch4:Play()

				self.DoingCombo = 4
				self.Combo = 1
			end	

			self.newHitbox:HitStart()
		end
	elseif Action == "Block" then
		if Bool == false and self.isBlocking == true then
			self.BlockingDebounce = true
			delay(.65,function()
				self.BlockingDebounce = false
			end)

			self.isBlocking = false

			delay(0.4,function()
				self.CanDoAnything = true
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
		elseif Char:FindFirstChild("Disabled") == nil and self.CanDoAnything == true and Bool == true and self.BlockingDebounce == false and self.isBlocking == false then
			self.isBlocking = true
			self.CanDoAnything = false

			Hum.JumpPower = 0

			self.BlockAnim:Play()

			Hum.WalkSpeed = 5

			local Value = Instance.new("BoolValue",Char)
			Value.Name = "Blocking"
		end	
	end

    
end


function combatPlayer:Destroy()
    
end


return combatPlayer