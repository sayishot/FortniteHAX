local Config = {
    Box                       = false,
    BoxOutline                = false,
    BoxColor                  = Color3.new(1,1,1),
    BoxOutlineColor           = Color3.new(0,0,0),
    BoxFilled                 = false,
    BoxFilledColor            = Color3.new(1,1,1),
    BoxFilledOpacity          = 50, -- 1-100
    HealthBar                 = false,
    HealthBarSide             = "Left", -- Left, Bottom, Right
    HealthBarText             = false,
    HealthBarTextOutline      = false,
    HealthBarTextOutlineColor = Color3.new(0,0,0),
    HealthBarTextFont         = "Plex", -- UI, System, Plex, Monospace
    HealthBarTextSize         = 13,
    Names                     = false,
    NamesOutline              = false,
    NamesDistance             = false,
    NamesColor                = Color3.new(1,1,1),
    NamesOutlineColor         = Color3.new(0,0,0),
    NamesFont                 = "Plex",
    NamesSize                 = 13,
    HeadDot                   = false,
    HeadDotOutline            = false,
    HeadDotColor              = Color3.new(1,1,1),
    HeadDotOutlineColor       = Color3.new(0,0,0),
    HeadDotRadius             = 5,
    HeadDotNumSides           = 14,
    HeadDotFilled             = false,
    Tracer                    = false,
    TracerColor               = Color3.new(1,1,1),
    TracerOutline             = false,
    TracerOutlineColor        = Color3.new(0,0,0),
    LookAngle                 = false,
    LookAngleSize             = 10, -- 1-10
    LookAngleColor            = Color3.new(1,1,1),
    Skeleton                  = false,
    SkeletonColor             = Color3.new(1,1,1),
    ESPEnabled                = false,
    TeamCheck                 = false,
    MaxDistance               = 2500,
    UseTeamColor              = false,
    AimbotEnabled             = false,
    AimbotAiming              = false,
    AimbotTeamCheck           = false,
    AimbotDrawFOV             = false,
    AimbotDrawFOVOutline      = false,
    AimbotAimPart             = "Head",
    AimbotFOVRadius           = 180,
    AimbotFOVColor            = Color3.new(1,1,1),
    AimbotFOVOutlineColor     = Color3.new(0,0,0),
    AimbotSmoothing           = 50,
    AimbotFOVNumSides         = 24,
    AimbotMaxDistance         = 2500
}

old = Drawing.new
local drawings = {}
local updaters = {}
Drawing.new = function(...)
  local created = old(...)
  drawings[#drawings + 1] = created
  return created
end

local function DrawLine()
    local l = Drawing.new("Line")
    l.Visible = false
    l.From = Vector2.new(0, 0)
    l.To = Vector2.new(1, 1)
    l.Color = Color3.fromRGB(255, 255, 255)
    l.Thickness = 1
    l.ZIndex = 3
    return l
end

function CreateEsp(Player)
    repeat wait() until Player.Character ~= nil and Player.Character:FindFirstChild("Humanoid") ~= nil
    local Box,BoxFilled,BoxOutline,Name,HealthBar,HealthBarOutline,HealthBarText,HeadDot,HeadDotOutline,Tracer,TracerOutline,LookAngle = Drawing.new("Square"),Drawing.new("Square"),Drawing.new("Square"),Drawing.new("Text"),Drawing.new("Square"),Drawing.new("Square"),Drawing.new("Text"),Drawing.new("Circle"),Drawing.new("Circle"),Drawing.new("Line"),Drawing.new("Line"),Drawing.new("Line")
    local limbs = {}
    local R15 = (Player.Character.Humanoid.RigType == Enum.HumanoidRigType.R15) and true or false
    if R15 then 
        limbs = {
            -- Spine
            Head_UpperTorso = DrawLine(),
            UpperTorso_LowerTorso = DrawLine(),
            -- Left Arm
            UpperTorso_LeftUpperArm = DrawLine(),
            LeftUpperArm_LeftLowerArm = DrawLine(),
            LeftLowerArm_LeftHand = DrawLine(),
            -- Right Arm
            UpperTorso_RightUpperArm = DrawLine(),
            RightUpperArm_RightLowerArm = DrawLine(),
            RightLowerArm_RightHand = DrawLine(),
            -- Left Leg
            LowerTorso_LeftUpperLeg = DrawLine(),
            LeftUpperLeg_LeftLowerLeg = DrawLine(),
            LeftLowerLeg_LeftFoot = DrawLine(),
            -- Right Leg
            LowerTorso_RightUpperLeg = DrawLine(),
            RightUpperLeg_RightLowerLeg = DrawLine(),
            RightLowerLeg_RightFoot = DrawLine()
        }
    else 
        limbs = {
            Head_Spine = DrawLine(),
            Spine = DrawLine(),
            LeftArm = DrawLine(),
            LeftArm_UpperTorso = DrawLine(),
            RightArm = DrawLine(),
            RightArm_UpperTorso = DrawLine(),
            LeftLeg = DrawLine(),
            LeftLeg_LowerTorso = DrawLine(),
            RightLeg = DrawLine(),
            RightLeg_LowerTorso = DrawLine()
        }
    end
    local function Visibility(state)
        for i, v in pairs(limbs) do
            v.Visible = state
        end
    end
    local function Colorize(color)
        for i, v in pairs(limbs) do
            v.Color = color
        end
    end
    local Updater = game:GetService("RunService").RenderStepped:Connect(function()
        if Player.Character ~= nil and Player.Character:FindFirstChild("Humanoid") ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") ~= nil and Player.Character.Humanoid.Health > 0 and Player.Character:FindFirstChild("Head") ~= nil then
            local Target2dPosition,IsVisible = workspace.CurrentCamera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            local Target2dPositionHead = workspace.CurrentCamera:WorldToViewportPoint(Player.Character.Head.Position)
            local scale_factor = 1 / (Target2dPosition.Z * math.tan(math.rad(workspace.CurrentCamera.FieldOfView * 0.5)) * 2) * 100
            local width, height = math.floor(40 * scale_factor), math.floor(60 * scale_factor)
            local camera = game:GetService("Workspace").CurrentCamera
            if Config.ESPEnabled then
                if Config.Box then
                    Box.Visible = IsVisible
                    Box.Color = Config.BoxColor
                    Box.Size = Vector2.new(width,height)
                    Box.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2)
                    Box.Thickness = 1
                    Box.ZIndex = 3
                    if Config.BoxOutline then
                        BoxOutline.Visible = IsVisible
                        BoxOutline.Color = Config.BoxOutlineColor
                        BoxOutline.Size = Vector2.new(width,height)
                        BoxOutline.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2)
                        BoxOutline.Thickness = 3
                        BoxOutline.ZIndex = 2
                    else
                        BoxOutline.Visible = false
                    end
                    if Config.BoxFilled then
                        BoxFilled.Visible = IsVisible
                        BoxFilled.Color = Config.BoxFilledColor
                        BoxFilled.Size = Vector2.new(width,height)
                        BoxFilled.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2)
                        BoxFilled.Thickness = 1
                        BoxFilled.Transparency = Config.BoxFilledOpacity / 100
                        BoxFilled.ZIndex = 1
                        BoxFilled.Filled = true
                    else
                        BoxFilled.Visible = false
                    end
                else
                    Box.Visible = false
                    BoxOutline.Visible = false
                    BoxFilled.Visible = false
                end
                if Config.Names then
                    Name.Visible = IsVisible
                    Name.Color = Config.NamesColor
                    Name.Center = true
                    Name.Outline = Config.NamesOutline
                    Name.OutlineColor = Config.NamesOutlineColor
                    Name.Position = Vector2.new(Target2dPosition.X,Target2dPosition.Y - height * 0.5 + -15)
                    Name.ZIndex = 3
                    --Name.Font = Config.NamesFont
                    Name.Size = Config.NamesSize
                    if Config.NamesFont == "UI" then
                        Name.Font = 0
                    elseif Config.NamesFont == "System" then
                        Name.Font = 1
                    elseif Config.NamesFont == "Plex" then
                        Name.Font = 2
                    elseif Config.NamesFont == "Monospace" then
                        Name.Font = 3
                    end
                    if Config.NamesDistance then
                        Name.Text = "["..Player.Name.."]["..math.floor((workspace.CurrentCamera.CFrame.p - Player.Character.HumanoidRootPart.Position).magnitude).."m]"
                    else
                        Name.Text = Player.Name
                    end
                else
                    Name.Visible = false
                end
                if Config.HealthBar then
                    HealthBarOutline.Visible = IsVisible
                    HealthBarOutline.Color = Color3.fromRGB(0,0,0)
                    HealthBarOutline.Thickness = 3
                    HealthBarOutline.Filled = true
                    HealthBarOutline.ZIndex = 2

                    HealthBar.Visible = IsVisible
                    HealthBar.Color = Color3.fromRGB(255,0,0):lerp(Color3.fromRGB(0,255,0), Player.Character:FindFirstChild("Humanoid").Health/Player.Character:FindFirstChild("Humanoid").MaxHealth)
                    HealthBar.Thickness = 1
                    HealthBar.Filled = true
                    HealthBar.ZIndex = 3
                    if Config.HealthBarText then
                        HealthBarText.Visible = IsVisible
                        HealthBarText.Color = Color3.fromRGB(255,0,0):lerp(Color3.fromRGB(0,255,0), Player.Character:FindFirstChild("Humanoid").Health/Player.Character:FindFirstChild("Humanoid").MaxHealth)
                        HealthBarText.Size = Config.HealthBarTextSize
                        HealthBarText.Outline = Config.HealthBarTextOutline
                        HealthBarText.OutlineColor = Config.HealthBarTextOutlineColor
                        HealthBarText.ZIndex = 3
                        --HealthBarText.Font = Config.HealthBarTextFont
                        HealthBarText.Text = math.floor((Player.Character:FindFirstChild("Humanoid").Health/Player.Character:FindFirstChild("Humanoid").MaxHealth)*100).."%"
                        if Config.HealthBarTextFont == "UI" then
                            HealthBarText.Font = 0
                        elseif Config.HealthBarTextFont == "System" then
                            HealthBarText.Font = 1
                        elseif Config.HealthBarTextFont == "Plex" then
                            HealthBarText.Font = 2
                        elseif Config.HealthBarTextFont == "Monospace" then
                            HealthBarText.Font = 3
                        end
                    else
                        HealthBarText.Visible = false
                    end
                    if Config.HealthBarSide == "Left" then
                        HealthBarOutline.Size = Vector2.new(3,height)
                        HealthBarOutline.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2) + Vector2.new(-6,0)

                        HealthBar.Size = Vector2.new(1,-(HealthBarOutline.Size.Y - 2) * (Player.Character:FindFirstChild("Humanoid").Health/Player.Character:FindFirstChild("Humanoid").MaxHealth))
                        HealthBar.Position = HealthBarOutline.Position + Vector2.new(1,-1 + HealthBarOutline.Size.Y)
                        HealthBarText.Position = HealthBarOutline.Position + Vector2.new(-Config.HealthBarTextSize*2-3, 0)
                    elseif Config.HealthBarSide == "Bottom" then
                        HealthBarOutline.Size = Vector2.new(width,3)
                        HealthBarOutline.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2) + Vector2.new(0,height + 3)

                        HealthBar.Size = Vector2.new((HealthBarOutline.Size.X - 2) * (Player.Character:FindFirstChild("Humanoid").Health/Player.Character:FindFirstChild("Humanoid").MaxHealth),1)
                        HealthBar.Position = HealthBarOutline.Position + Vector2.new(1,-2 + HealthBarOutline.Size.Y)
                        HealthBarText.Position = HealthBarOutline.Position + Vector2.new(0, 3)
                    elseif Config.HealthBarSide == "Right" then
                        HealthBarOutline.Size = Vector2.new(3,height)
                        HealthBarOutline.Position = Vector2.new(Target2dPosition.X - Box.Size.X / 2,Target2dPosition.Y - Box.Size.Y / 2) + Vector2.new(width + 3,0)

                        HealthBar.Size = Vector2.new(1,-(HealthBarOutline.Size.Y - 2) * (Player.Character:FindFirstChild("Humanoid").Health/Player.Character:FindFirstChild("Humanoid").MaxHealth))
                        HealthBar.Position = HealthBarOutline.Position + Vector2.new(1,-1 + HealthBarOutline.Size.Y)
                        HealthBarText.Position = HealthBarOutline.Position + Vector2.new(5, 0)
                    end
                else
                    HealthBar.Visible = false
                    HealthBarOutline.Visible = false
                    HealthBarText.Visible = false
                end
                if Config.HeadDot then
                    HeadDot.Visible = IsVisible
                    HeadDot.Color = Config.HeadDotColor
                    HeadDot.Radius = Config.HeadDotRadius
                    HeadDot.Position = Vector2.new(Target2dPositionHead.X,Target2dPositionHead.Y)
                    HeadDot.NumSides = Config.HeadDotNumSides
                    HeadDot.Thickness = 1
                    HeadDot.ZIndex = 3
                    if Config.HeadDotOutline then
                        HeadDotOutline.Visible = IsVisible
                        HeadDotOutline.Color = Config.HeadDotOutlineColor
                        HeadDotOutline.Radius = Config.HeadDotRadius
                        HeadDotOutline.Position = Vector2.new(Target2dPositionHead.X,Target2dPositionHead.Y)
                        HeadDotOutline.NumSides = Config.HeadDotNumSides
                        HeadDotOutline.Thickness = 3
                        HeadDotOutline.ZIndex = 2
                    else
                        HeadDotOutline.Visible = false
                    end
                    if Config.HeadDotFilled then
                        HeadDot.Filled = true
                    else
                        HeadDot.Filled = false
                    end
                else
                    HeadDot.Visible = false
                    HeadDotOutline.Visible = false
                end
                if Config.Tracer then
                    Tracer.Visible = IsVisible
                    Tracer.Color = Config.TracerColor
                    Tracer.Thickness = 1
                    Tracer.ZIndex = 3
                    Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
                    Tracer.To = Vector2.new(Target2dPosition.X, Target2dPosition.Y)
                    if Config.TracerOutline then
                        TracerOutline.Visible = IsVisible
                        TracerOutline.Color = Config.TracerOutlineColor
                        TracerOutline.Thickness = 3
                        TracerOutline.ZIndex = 2
                        TracerOutline.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
                        TracerOutline.To = Vector2.new(Target2dPosition.X, Target2dPosition.Y)
                    else
                        TracerOutline.Visible = false
                    end
                else
                    Tracer.Visible = false
                    TracerOutline.Visible = false
                end
                if Config.LookAngle then
                    local offsetCFrame = CFrame.new(0,0,-Config.LookAngleSize)
                    local playerDirection = Player.Character.Head.CFrame:ToWorldSpace(offsetCFrame)
                    local playerDirectionPos, IsVisible2 = camera:WorldToViewportPoint(Vector3.new(playerDirection.X, playerDirection.Y, playerDirection.Z))
                    LookAngle.Visible = IsVisible2
                    LookAngle.Color = Config.LookAngleColor
                    LookAngle.Thickness = 1
                    LookAngle.ZIndex = 3
                    LookAngle.From = Vector2.new(Target2dPositionHead.X, Target2dPositionHead.Y)
                    LookAngle.To = Vector2.new(playerDirectionPos.X, playerDirectionPos.Y)
                else
                    LookAngle.Visible = false
                end
                
                if Config.Skeleton then
                    Colorize(Config.SkeletonColor)
                    Visibility(IsVisible)
                    if R15 then
                        if limbs.Head_UpperTorso.From ~= Vector2.new(Target2dPositionHead.X, Target2dPositionHead.Y) then
                            --Spine
                            local UT = camera:WorldToViewportPoint(Player.Character.UpperTorso.Position)
                            local LT = camera:WorldToViewportPoint(Player.Character.LowerTorso.Position)
                            -- Left Arm
                            local LUA = camera:WorldToViewportPoint(Player.Character.LeftUpperArm.Position)
                            local LLA = camera:WorldToViewportPoint(Player.Character.LeftLowerArm.Position)
                            local LH = camera:WorldToViewportPoint(Player.Character.LeftHand.Position)
                            -- Right Arm
                            local RUA = camera:WorldToViewportPoint(Player.Character.RightUpperArm.Position)
                            local RLA = camera:WorldToViewportPoint(Player.Character.RightLowerArm.Position)
                            local RH = camera:WorldToViewportPoint(Player.Character.RightHand.Position)
                            -- Left leg
                            local LUL = camera:WorldToViewportPoint(Player.Character.LeftUpperLeg.Position)
                            local LLL = camera:WorldToViewportPoint(Player.Character.LeftLowerLeg.Position)
                            local LF = camera:WorldToViewportPoint(Player.Character.LeftFoot.Position)
                            -- Right leg
                            local RUL = camera:WorldToViewportPoint(Player.Character.RightUpperLeg.Position)
                            local RLL = camera:WorldToViewportPoint(Player.Character.RightLowerLeg.Position)
                            local RF = camera:WorldToViewportPoint(Player.Character.RightFoot.Position)

                            --Head
                            limbs.Head_UpperTorso.From = Vector2.new(Target2dPositionHead.X, Target2dPositionHead.Y)
                            limbs.Head_UpperTorso.To = Vector2.new(UT.X, UT.Y)

                            --Spine
                            limbs.UpperTorso_LowerTorso.From = Vector2.new(UT.X, UT.Y)
                            limbs.UpperTorso_LowerTorso.To = Vector2.new(LT.X, LT.Y)

                            -- Left Arm
                            limbs.UpperTorso_LeftUpperArm.From = Vector2.new(UT.X, UT.Y)
                            limbs.UpperTorso_LeftUpperArm.To = Vector2.new(LUA.X, LUA.Y)

                            limbs.LeftUpperArm_LeftLowerArm.From = Vector2.new(LUA.X, LUA.Y)
                            limbs.LeftUpperArm_LeftLowerArm.To = Vector2.new(LLA.X, LLA.Y)

                            limbs.LeftLowerArm_LeftHand.From = Vector2.new(LLA.X, LLA.Y)
                            limbs.LeftLowerArm_LeftHand.To = Vector2.new(LH.X, LH.Y)

                            -- Right Arm
                            limbs.UpperTorso_RightUpperArm.From = Vector2.new(UT.X, UT.Y)
                            limbs.UpperTorso_RightUpperArm.To = Vector2.new(RUA.X, RUA.Y)

                            limbs.RightUpperArm_RightLowerArm.From = Vector2.new(RUA.X, RUA.Y)
                            limbs.RightUpperArm_RightLowerArm.To = Vector2.new(RLA.X, RLA.Y)

                            limbs.RightLowerArm_RightHand.From = Vector2.new(RLA.X, RLA.Y)
                            limbs.RightLowerArm_RightHand.To = Vector2.new(RH.X, RH.Y)

                            -- Left Leg
                            limbs.LowerTorso_LeftUpperLeg.From = Vector2.new(LT.X, LT.Y)
                            limbs.LowerTorso_LeftUpperLeg.To = Vector2.new(LUL.X, LUL.Y)

                            limbs.LeftUpperLeg_LeftLowerLeg.From = Vector2.new(LUL.X, LUL.Y)
                            limbs.LeftUpperLeg_LeftLowerLeg.To = Vector2.new(LLL.X, LLL.Y)

                            limbs.LeftLowerLeg_LeftFoot.From = Vector2.new(LLL.X, LLL.Y)
                            limbs.LeftLowerLeg_LeftFoot.To = Vector2.new(LF.X, LF.Y)

                            -- Right Leg
                            limbs.LowerTorso_RightUpperLeg.From = Vector2.new(LT.X, LT.Y)
                            limbs.LowerTorso_RightUpperLeg.To = Vector2.new(RUL.X, RUL.Y)

                            limbs.RightUpperLeg_RightLowerLeg.From = Vector2.new(RUL.X, RUL.Y)
                            limbs.RightUpperLeg_RightLowerLeg.To = Vector2.new(RLL.X, RLL.Y)

                            limbs.RightLowerLeg_RightFoot.From = Vector2.new(RLL.X, RLL.Y)
                            limbs.RightLowerLeg_RightFoot.To = Vector2.new(RF.X, RF.Y)
                        end
                    else
                        if limbs.Head_Spine.From ~= Vector2.new(Target2dPositionHead.X, Target2dPositionHead.Y) then
                            local T_Height = Player.Character.Torso.Size.Y/2 - 0.2
                            local UT2 = camera:WorldToViewportPoint((Player.Character.Torso.CFrame * CFrame.new(0, T_Height, 0)).p)
                            local LT2 = camera:WorldToViewportPoint((Player.Character.Torso.CFrame * CFrame.new(0, -T_Height, 0)).p)

                            local LA_Height = Player.Character["Left Arm"].Size.Y/2 - 0.2
                            local LUA2 = camera:WorldToViewportPoint((Player.Character["Left Arm"].CFrame * CFrame.new(0, LA_Height, 0)).p)
                            local LLA2 = camera:WorldToViewportPoint((Player.Character["Left Arm"].CFrame * CFrame.new(0, -LA_Height, 0)).p)

                            local RA_Height = Player.Character["Right Arm"].Size.Y/2 - 0.2
                            local RUA2 = camera:WorldToViewportPoint((Player.Character["Right Arm"].CFrame * CFrame.new(0, RA_Height, 0)).p)
                            local RLA2 = camera:WorldToViewportPoint((Player.Character["Right Arm"].CFrame * CFrame.new(0, -RA_Height, 0)).p)

                            local LL_Height = Player.Character["Left Leg"].Size.Y/2 - 0.2
                            local LUL2 = camera:WorldToViewportPoint((Player.Character["Left Leg"].CFrame * CFrame.new(0, LL_Height, 0)).p)
                            local LLL2 = camera:WorldToViewportPoint((Player.Character["Left Leg"].CFrame * CFrame.new(0, -LL_Height, 0)).p)

                            local RL_Height = Player.Character["Right Leg"].Size.Y/2 - 0.2
                            local RUL2 = camera:WorldToViewportPoint((Player.Character["Right Leg"].CFrame * CFrame.new(0, RL_Height, 0)).p)
                            local RLL2 = camera:WorldToViewportPoint((Player.Character["Right Leg"].CFrame * CFrame.new(0, -RL_Height, 0)).p)

                            -- Head
                            limbs.Head_Spine.From = Vector2.new(Target2dPositionHead.X, Target2dPositionHead.Y)
                            limbs.Head_Spine.To = Vector2.new(UT2.X, UT2.Y)

                            --Spine
                            limbs.Spine.From = Vector2.new(UT2.X, UT2.Y)
                            limbs.Spine.To = Vector2.new(LT2.X, LT2.Y)

                            --Left Arm
                            limbs.LeftArm.From = Vector2.new(LUA2.X, LUA2.Y)
                            limbs.LeftArm.To = Vector2.new(LLA2.X, LLA2.Y)

                            limbs.LeftArm_UpperTorso.From = Vector2.new(UT2.X, UT2.Y)
                            limbs.LeftArm_UpperTorso.To = Vector2.new(LUA2.X, LUA2.Y)

                            --Right Arm
                            limbs.RightArm.From = Vector2.new(RUA2.X, RUA2.Y)
                            limbs.RightArm.To = Vector2.new(RLA2.X, RLA2.Y)

                            limbs.RightArm_UpperTorso.From = Vector2.new(UT2.X, UT2.Y)
                            limbs.RightArm_UpperTorso.To = Vector2.new(RUA2.X, RUA2.Y)

                            --Left Leg
                            limbs.LeftLeg.From = Vector2.new(LUL2.X, LUL2.Y)
                            limbs.LeftLeg.To = Vector2.new(LLL2.X, LLL2.Y)

                            limbs.LeftLeg_LowerTorso.From = Vector2.new(LT2.X, LT2.Y)
                            limbs.LeftLeg_LowerTorso.To = Vector2.new(LUL2.X, LUL2.Y)

                            --Right Leg
                            limbs.RightLeg.From = Vector2.new(RUL2.X, RUL2.Y)
                            limbs.RightLeg.To = Vector2.new(RLL2.X, RLL2.Y)

                            limbs.RightLeg_LowerTorso.From = Vector2.new(LT2.X, LT2.Y)
                            limbs.RightLeg_LowerTorso.To = Vector2.new(RUL2.X, RUL2.Y)
                        end
                    end
                else
                    Visibility(false)
                end
                if Config.MaxDistance < math.floor((workspace.CurrentCamera.CFrame.p - Player.Character.HumanoidRootPart.Position).magnitude) then
                    Box.Visible = false
                    BoxOutline.Visible = false
                    BoxFilled.Visible = false
                    Name.Visible = false
                    HealthBar.Visible = false
                    HealthBarOutline.Visible = false
                    HealthBarText.Visible = false
                    HeadDot.Visible = false
                    HeadDotOutline.Visible = false
                    Tracer.Visible = false
                    TracerOutline.Visible = false
                    LookAngle.Visible = false
                    Visibility(false)
                end
                if Config.UseTeamColor then
                    Box.Color = Player.TeamColor.Color
                    BoxFilled.Color = Player.TeamColor.Color
                    Name.Color = Player.TeamColor.Color
                    HeadDot.Color = Player.TeamColor.Color
                    Tracer.Color = Player.TeamColor.Color
                    LookAngle.Color = Player.TeamColor.Color
                    Colorize(Player.TeamColor.Color)
                end
                if Config.TeamCheck and Player.TeamColor == game:GetService("Players").LocalPlayer.TeamColor then
                    Box.Visible = false
                    BoxOutline.Visible = false
                    BoxFilled.Visible = false
                    Name.Visible = false
                    HealthBar.Visible = false
                    HealthBarOutline.Visible = false
                    HealthBarText.Visible = false
                    HeadDot.Visible = false
                    HeadDotOutline.Visible = false
                    Tracer.Visible = false
                    TracerOutline.Visible = false
                    LookAngle.Visible = false
                    Visibility(false)
                end
            else
                Box.Visible = false
                BoxOutline.Visible = false
                BoxFilled.Visible = false
                Name.Visible = false
                HealthBar.Visible = false
                HealthBarOutline.Visible = false
                HealthBarText.Visible = false
                HeadDot.Visible = false
                HeadDotOutline.Visible = false
                Tracer.Visible = false
                TracerOutline.Visible = false
                LookAngle.Visible = false
                Visibility(false)
            end
        else
            Box.Visible = false
            BoxOutline.Visible = false
            BoxFilled.Visible = false
            Name.Visible = false
            HealthBar.Visible = false
            HealthBarOutline.Visible = false
            HealthBarText.Visible = false
            HeadDot.Visible = false
            HeadDotOutline.Visible = false
            Tracer.Visible = false
            TracerOutline.Visible = false
            LookAngle.Visible = false
            Visibility(false)
            if not Player then
                Box:Remove()
                BoxOutline:Remove()
                BoxFilled:Remove()
                Name:Remove()
                HealthBar:Remove()
                HealthBarOutline:Remove()
                HealthBarText:Remove()
                HeadDot:Remove()
                HeadDotOutline:Remove()
                Tracer:Remove()
                TracerOutline:Remove()
                LookAngle:Remove()
                Updater:Disconnect()
                for i, v in pairs(limbs) do
                    v:Remove()
                end
            end
        end
    end)
    updaters[#updaters + 1] = Updater
end

local fovcircle, fovcircleoutline = Drawing.new("Circle"), Drawing.new("Circle")
fovcircle.Thickness = 1
fovcircle.Filled = false
fovcircle.Transparency = 1
fovcircle.ZIndex = 3
fovcircleoutline.Thickness = 3
fovcircleoutline.Filled = false
fovcircleoutline.Transparency = 1
fovcircleoutline.ZIndex = 2

function getplayer()
    local ClosestPlayer = nil
    local FarthestDistance = math.huge
    local MouseLocation  = game:GetService("UserInputService"):GetMouseLocation()
    for i, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player == game:GetService("Players").LocalPlayer then continue end
        if player.Character:FindFirstChild("Humanoid").Health > 0 and player ~= game:GetService("Players").LocalPlayer then
            if player.TeamColor ~= game:GetService("Players").LocalPlayer.TeamColor and Config.AimbotTeamCheck or Config.AimbotTeamCheck == false then
                local character = player.Character
                local char_part_pos, is_onscreen = workspace.CurrentCamera:WorldToViewportPoint(character[Config.AimbotAimPart].Position)
                if is_onscreen then
                    local MouseDistance = (Vector2.new(char_part_pos.X, char_part_pos.Y) - MouseLocation).Magnitude
                    if MouseDistance < FarthestDistance and MouseDistance <= Config.AimbotFOVRadius and math.floor((workspace.CurrentCamera.CFrame.p - character.HumanoidRootPart.Position).magnitude) < Config.AimbotMaxDistance then
                        FarthestDistance = MouseDistance
                        ClosestPlayer = player
                    end
                end
            end
        end
    end
    return ClosestPlayer
end

local updater1 = game:GetService("RunService").RenderStepped:Connect(function()
    fovcircle.Radius = Config.AimbotFOVRadius
    fovcircle.Color = Config.AimbotFOVColor
    fovcircle.NumSides = Config.AimbotFOVNumSides
    fovcircleoutline.NumSides = Config.AimbotFOVNumSides
    fovcircleoutline.Radius = Config.AimbotFOVRadius
    fovcircleoutline.Color = Config.AimbotFOVOutlineColor
    fovcircle.Position = Vector2.new(game:GetService("UserInputService"):GetMouseLocation().X, game:GetService("UserInputService"):GetMouseLocation().Y)
    fovcircleoutline.Position = fovcircle.Position
    if Config.AimbotDrawFOV and Config.AimbotDrawFOVOutline then
        fovcircleoutline.Visible = true
    else
        fovcircleoutline.Visible = false
    end
    if Config.AimbotEnabled then
        fovcircle.Visible = Config.AimbotDrawFOV
    else
        fovcircle.Visible = false
        fovcircleoutline.Visible = false
    end
    if Config.AimbotAiming and Config.AimbotEnabled then
        local ClosestPlayer = getplayer()
        local character = ClosestPlayer.Character
        if ClosestPlayer ~= nil then
            local char_part_pos, is_onscreen = workspace.CurrentCamera:WorldToViewportPoint(character[Config.AimbotAimPart].Position)
            if char_part_pos and is_onscreen then
                local MouseLocation = game:GetService("UserInputService"):GetMouseLocation()
                mousemoverel((char_part_pos.X - MouseLocation.X) / (Config.AimbotSmoothing / 10), (char_part_pos.Y - MouseLocation.Y) / (Config.AimbotSmoothing / 10))
            end
        end
    end
end)

updaters[#updaters + 1] = updater1

function DestroyEsp()
    for i, v in pairs(drawings) do
        v:Remove()
    end
    for i, v in pairs(updaters) do
        v:Disconnect()
    end
end

for _,v in pairs(game:GetService("Players"):GetPlayers()) do
    if v ~= game:GetService("Players").LocalPlayer then
        CreateEsp(v)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(v)
    if v ~= game:GetService("Players").LocalPlayer then
        CreateEsp(v)
    end
end)
return Config
