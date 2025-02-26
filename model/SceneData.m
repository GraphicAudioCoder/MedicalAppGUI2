% /model/SceneData.m

classdef SceneData
    properties
        scenePath
        sceneFileName
        sceneName
        listenerNum
        selectedListener
        selectedTarget
        listenerPositions
    end
    
    methods
        % Constructor
        function obj = SceneData(sceneFileName, sceneName)
            obj.sceneFileName = sceneFileName;
            obj.sceneName = sceneName;
            obj.scenePath = fullfile(fileparts(mfilename('fullpath')), '../scenes', sceneFileName);
            sceneData = load(fullfile(obj.scenePath, [sceneFileName, '.mat']));
            if isfield(sceneData, 'listenerPositions')
                obj.listenerPositions = sceneData.listenerPositions;
            else
                obj.listenerPositions = [];
            end
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