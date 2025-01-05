--[[
    LuiExtended
    License: The MIT License (MIT)
--]]

--- @class (partial) LuiExtended
local LUIE = LUIE

--- @class CombatTextAnimation : ZO_InitializingObject
--- @field private timeline AnimationTimeline  The animation timeline
--- @field private namedSteps table<string, Animation> Named animation steps
local CombatTextAnimation = ZO_InitializingObject:Subclass()
LUIE.CombatTextAnimation = CombatTextAnimation
local animationManager = GetAnimationManager()

--- Creates a new CombatTextAnimation instance
--- @return CombatTextAnimation
function CombatTextAnimation:New()
    local obj = setmetatable({}, self)
    obj.timeline = animationManager:CreateTimeline()
    obj.timeline:SetPlaybackType(0, 0)
    obj.namedSteps = {}
    return obj
end

--- Applies all animations to the specified control
--- @param control Control The UI control to apply animations to
function CombatTextAnimation:Apply(control)
    self.timeline:ApplyAllAnimationsToControl(control)
end

--- Stops the animation timeline
function CombatTextAnimation:Stop()
    self.timeline:Stop()
end

--- Sets the progress of the animation timeline
--- @param progress number The progress value between 0 and 1
function CombatTextAnimation:SetProgress(progress)
    self.timeline:SetProgress(progress)
end

--- Plays the animation from the start
function CombatTextAnimation:Play()
    self.timeline:PlayFromStart()
end

--- Plays the animation forward from current position
function CombatTextAnimation:PlayForward()
    self.timeline:PlayForward()
end

--- Plays the animation instantly to its end state
function CombatTextAnimation:PlayInstantlyToEnd()
    self.timeline:PlayInstantlyToEnd()
end

--- Adds an alpha animation to the timeline
--- @param stepName? string Optional name to reference this animation step
--- @param startAlpha number Starting alpha value
--- @param endAlpha number Ending alpha value
--- @param duration number Duration in milliseconds
--- @param delay? number Optional delay before starting in milliseconds
--- @param easingFunc? function Optional easing function
--- @return AnimationObjectAlpha
function CombatTextAnimation:Alpha(stepName, startAlpha, endAlpha, duration, delay, easingFunc)
    local step = self.timeline:InsertAnimation(ANIMATION_ALPHA, nil, delay or 0)
    step:SetAlphaValues(startAlpha, endAlpha)
    step:SetDuration(duration)
    step:SetEasingFunction(easingFunc or ZO_LinearEase)
    if stepName ~= nil and stepName ~= "" then
        self.namedSteps[stepName] = step
    end
    return step
end

--- Adds a scale animation to the timeline
--- @param stepName? string Optional name to reference this animation step
--- @param startScale number Starting scale value
--- @param endScale number Ending scale value
--- @param duration number Duration in milliseconds
--- @param delay? number Optional delay before starting in milliseconds
--- @param easingFunc? function Optional easing function
--- @return AnimationObjectScale
function CombatTextAnimation:Scale(stepName, startScale, endScale, duration, delay, easingFunc)
    local step = self.timeline:InsertAnimation(ANIMATION_SCALE, nil, delay or 0)
    step:SetScaleValues(startScale, endScale)
    step:SetDuration(duration)
    step:SetEasingFunction(easingFunc or ZO_LinearEase)
    if stepName ~= nil and stepName ~= "" then
        self.namedSteps[stepName] = step
    end
    return step
end

--- Adds a movement animation to the timeline
--- @param stepName? string Optional name to reference this animation step
--- @param offsetX number X-axis movement offset
--- @param offsetY number Y-axis movement offset
--- @param duration number Duration in milliseconds
--- @param delay? number Optional delay before starting in milliseconds
--- @param easingFunc? function Optional easing function
--- @return AnimationObjectTranslate
function CombatTextAnimation:Move(stepName, offsetX, offsetY, duration, delay, easingFunc)
    local step = self.timeline:InsertAnimation(ANIMATION_TRANSLATE, nil, delay or 0)
    step:SetTranslateDeltas(offsetX, offsetY, TRANSLATE_ANIMATION_DELTA_TYPE_FROM_START)
    step:SetDuration(duration)
    step:SetEasingFunction(easingFunc or ZO_LinearEase)
    if stepName ~= nil and stepName ~= "" then
        self.namedSteps[stepName] = step
    end
    return step
end

--- Inserts a callback function into the timeline
--- @param func function The callback function to execute
--- @param delay number Delay in milliseconds before executing the callback
function CombatTextAnimation:InsertCallback(func, delay)
    self.timeline:InsertCallback(func, delay)
end

--- Clears all callbacks from the timeline
function CombatTextAnimation:ClearCallbacks()
    self.timeline:ClearAllCallbacks()
end

--- Gets an animation step by index
--- @param i integer The index of the animation step
--- @return Animation?
function CombatTextAnimation:GetStep(i)
    return self.timeline:GetAnimation(i)
end

--- Gets an animation step by name
--- @param stepName string The name of the animation step
--- @return AnimationObjectTranslate ?
function CombatTextAnimation:GetStepByName(stepName)
    if stepName ~= nil and stepName ~= "" then
        return self.namedSteps[stepName]
    end
end

--- Gets the last animation step in the timeline
--- @return AnimationObjectTranslate ?
function CombatTextAnimation:GetLastStep()
    return self.timeline:GetLastAnimation()
end

--- Sets the delay for an animation step
--- @param step Animation The animation step
--- @param delay number The delay in milliseconds
function CombatTextAnimation:SetStepDelay(step, delay)
    return self.timeline:SetAnimationOffset(step, delay)
end

--- Gets the total duration of the timeline
--- @return number duration The duration in milliseconds
function CombatTextAnimation:GetDuration()
    return self.timeline:GetDuration()
end

--- Gets the current progress of the timeline
--- @return number progress The progress value between 0 and 1
function CombatTextAnimation:GetProgress()
    return self.timeline:GetProgress()
end
