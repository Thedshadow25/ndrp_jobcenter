-- ===================================================
-- Job Center - Client-side
-- Provides NUI menu + ox_target ped interaction
-- ===================================================
-- This module handles client-side job center interactions,

local jobcenterPed = nil
local jobcenterBlip = nil
local jobLocationBlip = nil

-- ===================================================
-- Helper: Spawn a ped
-- ===================================================
-- Creates and positions an NPC at the given coordinates
local function spawnPed(model, coords)
    lib.requestModel(model)
    local ped = CreatePed(0, model, coords.x, coords.y, coords.z, coords.w, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    return ped
end

-- ===================================================
-- Helper: Create a blip
-- ===================================================
-- Creates a map marker at the specified location
local function createBlip(coords, blipConfig)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipConfig.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, blipConfig.scale)
    SetBlipColour(blip, blipConfig.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(blipConfig.label)
    EndTextCommandSetBlipName(blip)
    return blip
end

-- ===================================================
-- NUI: Open job menu
-- ===================================================
-- Displays the job selection interface to the player
local function openJobMenu()
    local data = lib.callback.await('ndrp_jobcenter:getJobData', false)

    local nuiJobs = {}
    for _, job in ipairs(Config.Jobs) do
        nuiJobs[#nuiJobs + 1] = {
            id = job.id,
            name = job.name,
            description = job.description,
            icon = job.icon,
            salary = job.salary,
            tutorial = job.tutorial or {},
            recommended = job.recommended or false,
            requiredLevel = job.requiredLevel or 1,
            activeCount = data.jobCounts[job.id] or 0,
        }
    end

    SendNUIMessage({
        action = 'showJobMenu',
        jobs = nuiJobs,
        currentJob = data.currentJob or 'unemployed',
        level = data.level or 1,
        minutesIntoLevel = data.minutesIntoLevel or 0,
        minutesPerLevel = data.minutesPerLevel or 60,
    })
    SetNuiFocus(true, true)
end

-- ===================================================
-- NUI: Close job menu
-- ===================================================
-- Closes the job selection interface
local function closeJobMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hideJobMenu' })
end

-- ===================================================
-- NUI Callbacks
-- ===================================================
-- Handle messages from the NUI interface
RegisterNUICallback('closeMenu', function(_, cb)
    closeJobMenu()
    cb('ok')
end)

RegisterNUICallback('selectJob', function(_, cb)
    cb('ok')
end)

-- ===================================================
-- Event: Level up notification
-- ===================================================
RegisterNetEvent('ndrp_jobcenter:levelUp', function(newLevel)
    lib.notify({
        title = 'Level Up!',
        description = ('Congratulations! You have reached Level %d — New jobs may be unlocked!'):format(newLevel),
        type = 'success',
        duration = 7000,
    })
end)

RegisterNUICallback('confirmJob', function(data, cb)
    closeJobMenu()

    local jobId = data.jobId
    if not jobId then
        cb('error')
        return
    end

    local success = lib.callback.await('ndrp_jobcenter:setJob', false, jobId)

    if success then
        if jobLocationBlip then
            RemoveBlip(jobLocationBlip)
            jobLocationBlip = nil
        end

        for _, job in ipairs(Config.Jobs) do
            if job.id == jobId and job.location then
                local loc = job.location
                jobLocationBlip = createBlip(loc.coords, loc.blip)
                SetNewWaypoint(loc.coords.x, loc.coords.y)
                break
            end
        end

        lib.notify({
            title = 'Job Center',
            description = 'You have been assigned the job! Follow the GPS to your workplace.',
            type = 'success',
            duration = 5000,
        })
    else
        lib.notify({
            title = 'Job Center',
            description = 'Failed to assign the job.',
            type = 'error',
            duration = 5000,
        })
    end

    cb('ok')
end)

-- ===================================================
-- Setup: Spawn ped + blip + ox_target
-- ===================================================
-- Initialize the job center NPC and interactions
CreateThread(function()
    local cfg = Config.Ped

    jobcenterPed = spawnPed(cfg.model, cfg.coords)

    if jobcenterPed and cfg.scenario then
        TaskStartScenarioInPlace(jobcenterPed, cfg.scenario, 0, true)
    end

    jobcenterBlip = createBlip(cfg.coords, cfg.blip)

    if jobcenterPed then
        exports.ox_target:addLocalEntity(jobcenterPed, {
            {
                name = 'ndrp_jobcenter_interact',
                icon = cfg.interactIcon,
                label = cfg.interactLabel,
                onSelect = function()
                    openJobMenu()
                end,
                distance = 2.5,
            },
        })
    end
end)

-- ===================================================
-- Cleanup
-- ===================================================
-- Clean up resources when the resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    if jobcenterPed and DoesEntityExist(jobcenterPed) then
        exports.ox_target:removeLocalEntity(jobcenterPed, 'ndrp_jobcenter_interact')
        DeleteEntity(jobcenterPed)
        jobcenterPed = nil
    end

    if jobcenterBlip then
        RemoveBlip(jobcenterBlip)
        jobcenterBlip = nil
    end

    if jobLocationBlip then
        RemoveBlip(jobLocationBlip)
        jobLocationBlip = nil
    end
end)
