% /model/SceneData.m

classdef SceneData
    properties
        scenePath
        sceneFileName
        sceneName
        listenerNum
        selectedListener
        selectedTarget
        selectedAzimuth
        selectedElevation
        listenerPositions
        listenerAzimuths
        listenerElevations
        targetsForListeners
        targetsForListenersSpecs
        targets
        targetOrientation
    end
    
    methods
        % Constructor
        function obj = SceneData(sceneFileName, sceneName)
            obj.sceneFileName = sceneFileName;
            obj.sceneName = sceneName;
            obj.scenePath = fullfile(fileparts(mfilename('fullpath')), '../scenes', sceneFileName);
            sceneData = load(fullfile(obj.scenePath, [sceneFileName, '.mat']));
            obj.listenerAzimuths = sceneData.listenerAzimuths;
            obj.listenerElevations = sceneData.listenerElevations;
            obj.targetsForListeners = sceneData.targetsForListeners;
            obj.targets = sceneData.targets;
            obj.targetsForListenersSpecs = sceneData.targetsForListenersSpecs;
            obj.targetOrientation = sceneData.targetOrientation;
        end

        function obj = setListenerNum(obj, listenerNum)
            obj.listenerNum = listenerNum;
        end

        function obj = setSelectedListener(obj, listenerIndex)
            obj.selectedListener = listenerIndex;
        end

        function obj = setSelectedTarget(obj, targetIndex)
            obj.selectedTarget = targetIndex;
        end
    end
end