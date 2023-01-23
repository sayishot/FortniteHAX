local a=loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()local b=a:CreateWindow({Name="/moonUtils",LoadingTitle="Loading /moonUtils <3",LoadingSubtitle="by ash & astral",ConfigurationSaving={Enabled=true,FolderName="FortniteHAX",FileName="/moonUtils"},Discord={Enabled=true,Invite="YF2hQMeZgP"},KeySystem=true,KeySettings={Title="/moonUtils",Subtitle="Key System",Note="Join the discord (discord.gg/YF2hQMeZgP)",FileName="/moonUtilsKey",SaveKey=true,GrabKeyFromSite=false,Key="moon/Key/MadeWith<3"}})a:Notify({Title="LOADED",Content="This was made by ash˞#2200 & Astral#6076",Duration=6.5,Image=4483362458,Actions={Ignore={Name="Okay!",Callback=function()print("ash˞#2200")print("Astral#6076")end}}})
local h = Window:CreateTab("Home", 4483362458) -- Title, Image
local r = Window:CreateTab("Rebirth", 4483362458) -- Title, Image
local i = Window:CreateTab("Info", 4483362458) -- Title, Image

local autoClick =
    h:CreateToggle(
    {
        Name = "Auto Click",
        CurrentValue = false,
        Flag = "autoclickhavoc", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(bool)
            XXX=bool while XXX do task.wait(Random.new():NextNumber(0.2, 0.5))
                game:GetService("ReplicatedStorage").Click:FireServer()
            end
            end
    }
)



local One="RB001"
local Five="RB002"

local rebirthOption="One"
r:CreateDropdown({
    Name = "Rebirth Options",
    Options = {"One","Five"},
    CurrentOption = "One",
    Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(s)
        rebirthOption=s        
    end,
 })
 r:CreateToggle(
    {
        Name = "Auto Rebirth",
        CurrentValue = false,
        Flag = "autoRebirthhavoc", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(bool)
            XXX=bool while XXX do task.wait(Random.new():NextNumber(4, 7))
                game:GetService("ReplicatedStorage").Rebirth:FireServer(rebirthOption)
                
            end
            end
    }
)

i:CreateParagraph({
    Title = "Mid Game",
    Content = "Bro this game is so fucking boring i gave up on the script 15 minutes in.. source code is avaliable in the github 'ClickingHavoc' if u wanna continue onto this script lmao"})
i:CreateParagraph({
    Title = "IF SCRIPTING IN THIS GAME",
    Content = "this game checks if the user does something a certain amount of seconds so if you use a randomized wait script when u automating something its a bypass for the anti cheat i used this for thte rebirthing and autoclicking."})

moon:LoadConfiguration()
