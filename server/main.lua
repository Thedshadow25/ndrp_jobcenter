-- ===================================================
-- Job Center - Server-side
-- Job assignment + automatic level progression system
-- Level = total work minutes / Config.MinutesPerLevel
-- Work time increments every minute for employed players
-- ===================================================

-- ===================================================
-- Helper: Get player level data from metadata
-- ===================================================
-- Calculates player level based on total work minutes
local function getPlayerLevelData(player)
    local meta = player.PlayerData.metadata or {}
    local workMinutes = meta.jc_workminutes or 0
    local mpl = Config.MinutesPerLevel or 60
    local level = math.floor(workMinutes / mpl) + 1  -- starts at 1
    local minutesIntoLevel = workMinutes % mpl
    return level, workMinutes, minutesIntoLevel, mpl
end

-- ===================================================
-- Work Time Tracker: +1 minute every 60 seconds
-- ===================================================
-- Automatic progression system for employed players
CreateThread(function()
    while true do
        Wait(60000) -- every 60 seconds

        local players = exports.qbx_core:GetQBPlayers()
        for _, player in pairs(players) do
            if player and player.PlayerData and player.PlayerData.job then
                local jobName = player.PlayerData.job.name
                if jobName and jobName ~= 'unemployed' then
                    local meta = player.PlayerData.metadata or {}
                    local current = meta.jc_workminutes or 0
                    local mpl = Config.MinutesPerLevel or 60
                    local oldLevel = math.floor(current / mpl) + 1
                    local newMinutes = current + 1
                    local newLevel = math.floor(newMinutes / mpl) + 1

                    player.Functions.SetMetaData('jc_workminutes', newMinutes)

                    -- Notify player of level up
                    if newLevel > oldLevel then
                        TriggerClientEvent('ndrp_jobcenter:levelUp', player.PlayerData.source, newLevel)
                    end
                end
            end
        end
    end
end)

-- ===================================================
-- Callback: Get job data for the NUI
-- ===================================================
-- Returns player job data and active job counts
lib.callback.register('ndrp_jobcenter:getJobData', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then
        return { currentJob = 'unemployed', level = 1, minutesWorked = 0, minutesIntoLevel = 0, minutesPerLevel = 60, jobCounts = {} }
    end

    local currentJob = player.PlayerData.job and player.PlayerData.job.name or 'unemployed'
    local level, workMinutes, minutesIntoLevel, mpl = getPlayerLevelData(player)

    -- Job counts
    local jobCounts = {}
    local players = exports.qbx_core:GetQBPlayers()
    for _, p in pairs(players) do
        if p and p.PlayerData and p.PlayerData.job then
            local jName = p.PlayerData.job.name
            jobCounts[jName] = (jobCounts[jName] or 0) + 1
        end
    end

    return {
        currentJob = currentJob,
        level = level,
        minutesWorked = workMinutes,
        minutesIntoLevel = minutesIntoLevel,
        minutesPerLevel = mpl,
        jobCounts = jobCounts,
    }
end)

-- ===================================================
-- Callback: Set player job
-- ===================================================
-- Assigns a job to player after validating requirements
lib.callback.register('ndrp_jobcenter:setJob', function(source, jobId)
    if not jobId then return false end

    local validJob = false
    local requiredLevel = 1
    for _, job in ipairs(Config.Jobs) do
        if job.id == jobId then
            validJob = true
            requiredLevel = job.requiredLevel or 1
            break
        end
    end

    if not validJob then return false end

    local player = exports.qbx_core:GetPlayer(source)
    if not player then return false end

    local level = getPlayerLevelData(player)
    if level < requiredLevel then return false end

    player.Functions.SetJob(jobId, 0)
    return true
end)
