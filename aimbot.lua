local Place = "Universal"
local GetHealth = nil

if game.PlaceId == 292439477 then
    local Place = "Phantom Forces"
    local GetHealth = FindLocal("gethealth")[2]
end

--if Input.UserInputType == Enum.UserInputType.MouseButton2 then

loadstring(game:HttpGet("https://pastebin.com/raw/06MMJp4c", true))() -- ESP Initiation
local ESP = shared.uESP
ESP.Enabled = false
ESP.Settings.Box3D = false
ESP.Settings.DrawTracers = false
ESP.Settings.DrawDistance = false
ESP.Settings.DrawNames = false
ESP.Settings.TextOutline = false
ESP.Settings.VisibilityCheck = false
ESP.Settings.TeamColor = Color3.fromRGB(0, 0, 0)
ESP.Settings.EnemyColor = Color3.fromRGB(255, 255, 255)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Client = Players.LocalPlayer
local Mouse = Client:GetMouse()
local Camera = game:GetService("Workspace"):FindFirstChildOfClass("Camera")

local MaxDistance = 1000
local AimbotEnabled = false
local AimbotActive = false
local VisibilityCheck = false
local TeamCheck = false
local InvisibleCheck = false
local ShowFOV = false
local AimingAt = nil
local Smoothness = 0
local MovementPrediction = false
local MovementPredictionStrength = 1

local FOV_Color = Color3.fromRGB(255, 255, 255)
local FOV_Size = 0

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(0, 0)
FOVCircle.Radius = FOV_Size
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = true
FOVCircle.Color = FOV_Color

local function AimToPosition(Position)
	local AimX = ((Position.X - Mouse.X) + 0) / Smoothness 
    local AimY = ((Position.Y - Mouse.Y - 36) + 0) / Smoothness
    return AimX, AimY
end

local function InitAimbot()
    if game:GetService("Workspace"):FindFirstChildOfClass("Camera") then
        local Camera = game:GetService("Workspace"):FindFirstChildOfClass("Camera")
    end
    local ScreenSize = Camera.ViewportSize
    if FOVCircle then
        FOVCircle.Radius = FOV_Size
        FOVCircle.Visible = ShowFOV
		FOVCircle.Color = FOV_Color
		FOVCircle.Transparency = 1
		FOVCircle.Filled = false
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    end

    if AimbotEnabled == false then return end
    if AimbotActive == true then
        local Closest = {nil, nil, nil, nil, nil}
        for i, v in pairs(Players:GetChildren()) do
            pcall(function()
                if v.Character and v ~= Client then
                    local HumanoidHealth = nil
                    if v.Character:FindFirstChildOfClass("Humanoid") ~= nil then
                        HumanoidHealth = v.Character:FindFirstChildOfClass("Humanoid").Health
                    end
					if MaxDistance == MaxDistance then
						AimbotEnabled = true
					elseif MaxDistance ~= MaxDistance then
						AimbotEnabled = false
					end
                    if HumanoidHealth == nil or HumanoidHealth > 0 then
                        local PlayerRoot = v.Character:FindFirstChild("HumanoidRootPart") or v.Character:FindFirstChild("Torso")
                        local PlayerHead = v.Character:FindFirstChild("Head") or PlayerRoot
						local PlayerRightArm = v.Character:FindFirstChildOfClass("Right Arm")
						local PlayerLeftArm = v.Character:FindFirstChildOfClass("Left Arm")
						local PlayerRightLeg = v.Character:FindFirstChildOfClass("Right Leg")
						local PlayerLeftLeg = v.Character:FindFirstChildOfClass("Left Leg")
                        local PlayerScreen, InFOV = Camera:WorldToViewportPoint(PlayerRoot.Position)
                        local DistanceFromCenter = 0
                        DistanceFromCenter = (Vector2.new(PlayerScreen.X, PlayerScreen.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
                        if (InFOV == true and DistanceFromCenter < FOV_Size) or AimingAt == v then
                            if AimingAt == v then
                                DistanceFromCenter = 0
                            end
                            if (TeamCheck == true and v.Team ~= Client.Team) or TeamCheck == false then
                                local Obscuring = false
                                if InvisibleCheck == true then
                                	local CheckParts = Camera:GetPartsObscuringTarget({Players.Head.Transparency, PlayerHead.Position}, {Camera, Client.Character})
                                	for i2, v2 in pairs(CheckParts) do
                                    if v2:IsDescendantOf(v.Character) == false and v2.Transparency == 0 or Character.Head.Transparency == 0 then
                                            Obscuring = false
                                        end
									end
                                end
                                if VisibilityCheck == true then
                                	local Parts = Camera:GetPartsObscuringTarget({Client.Character.Head.Position, PlayerHead.Position}, {Camera, Client.Character})
                                	for i2, v2 in pairs(Parts) do
                                    if v2:IsDescendantOf(v.Character) == false and v2.Transparency == 0 then
                                            Obscuring = true
                                        end
									end
                                end
                                if Obscuring == false and ((Closest[1] ~= nil and DistanceFromCenter < Closest[1]) or Closest[1] == nil) then
                                    if Closest[1] == nil or (DistanceFromCenter < Closest[1]) then
                                        local Prediction = Vector3.new(0, 0, 0)
                                        if MovementPrediction == true then
                                            Prediction = PlayerRoot.Velocity * (MovementPredictionStrength / 10) * (Client.Character.Head.Position - PlayerHead.Position).magnitude / 100
                                        end
                                        Closest[1] = DistanceFromCenter
                                        local PlayerAim = nil
                                        if AimPart == "Torso" then
                                            PlayerAim = v.Character:FindFirstChild("HumanoidRootPart") or v.Character:FindFirstChild("Torso")
                                        else
                                            PlayerAim = v.Character.Head
                                        end
										if AimPart == "Right Arm" then
											PlayerAim = v.Character:FindFirstChild("Right Arm")
										end
										if AimPart == "Left Arm" then
											PlayerAim = v.Character:FindFirstChild("Left Arm")
										end
										if AimPart == "Right Leg" then
											PlayerAim = v.Character:FindFirstChild("Right Leg")
										end
										if AimPart == "Left Leg" then
											PlayerAim = v.Character:FindFirstChild("Left Leg")
										end
										if AimPart == "Random Upper Body" then
											local RandomParts = {
												"Head";
												"Torso";
												"Right Arm";
												"Left Arm";
												-- this should work, how it works is it picks a random hitpart in the list above with math.random then it will put that part in AimPart and it'll aim at that exact part.

												-- more room for more parts
												}
												function garbagetalking()
												while AimPart == "Random Upper Body" do
													RandomParts[math.random(1,#RandomParts)]()
													  end
												end
										end
                                        Closest[2] = PlayerAim
                                        Closest[3] = Vector2.new(PlayerScreen.X, PlayerScreen.Y)
                                        Closest[4] = Prediction
                                        Closest[5] = v
									end
										end
									end
                                end
                            end
                        end
					end)
				end
        if Closest[1] ~= nil and Closest[2] ~= nil and Closest[3] ~= nil and Closest[4] ~= nil and Closest[5] ~= nil then
            pcall(function()
                local AimAt = Camera:WorldToViewportPoint(Closest[2].Position + Closest[4])
                mousemoverel(AimToPosition(Vector2.new(AimAt.X, AimAt.Y)))
                AimingAt = Closest[5]
            end)
        else
            AimingAt = nil
        end
    end
end
return Environment
