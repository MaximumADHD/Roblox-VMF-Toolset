--!strict

local Tree = require(script.Tree)
local Plane = require(script.Plane)
local Config = require(script.Config)
local TexVec = require(script.TexVec)

local uvScale = 2.25 / Config.UnitScale
local lines = {} :: { string }
local vmf = Tree.new("ROOT")

local validSurfaces = {
    weld = true,
    studs = true,
    inlet = true,
    smooth = true,
    universal = true,
}

local partSides = {} :: {
    [string]: Vector3
}

for i, normalId in Enum.NormalId:GetEnumItems() do
    partSides[normalId.Name] = Vector3.fromNormalId(normalId)
end

local function writeLine(...: any)
    local line = table.concat({...}, " ")
    table.insert(lines, line)
end

local world = vmf:AddChild("world")
    :AddItem("mapversion", 1)
    :AddItem("classname", "worldspawn")
    :AddItem("detailmaterial", "detail/detailsprites")
    :AddItem("detailvbsp", "detail.vbsp")
    :AddItem("maxpropscreenwidth", -1)
    :AddItem("skyname", Config.SkyName)

for i, part in workspace:GetDescendants() do
    if not part:IsA("Part") then
        continue
    end

    local size = part.Size
    local parent = world

    if size.Magnitude < Config.MinSolidSize then
        parent = vmf:AddChild("entity")
        parent:AddItem("classname", "func_detail")
    end

    local color = part.BrickColor.Name
        :gsub("[%.%(%)/]", "")
        :gsub(" ", "_")
        :lower()

    local matName = part.Material.Name:lower()
    local matBase = `roblox/materials/{matName}/vmts/{color}`

    local solid = parent:AddChild("solid")
    local cf = part.CFrame

    for surfId, normal in partSides do
        local material = matBase

        if matName == "plastic" then
            local surface = string.lower((part :: any)[`{surfId}Surface`].Name)
            
            if validSurfaces[surface] then
                material ..= `/{surface}`
            else
                material ..= "/smooth"
            end
        end

        local offset = normal * size
        local lookAt = cf * offset

        local surface = cf * (offset / 2)
		local planeCF = CFrame.lookAt(surface, lookAt)
        
        local uaxis = TexVec.new(planeCF.RightVector, uvScale)
        local vaxis = TexVec.new(planeCF.UpVector, uvScale)
        local plane = Plane.new(planeCF)

        --------------------------------------------------------------------------
        solid:AddChild("side")
             :AddItem("plane", plane)
             :AddItem("material", material)
             :AddItem("uaxis", uaxis)
             :AddItem("vaxis", vaxis)
             :AddItem("lightmapscale", 8)
        --------------------------------------------------------------------------
    end
end

local output do
    vmf:Write(writeLine)
    output = table.concat(lines, "\n")
end

print(output)