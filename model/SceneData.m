% /model/SceneData.m

classdef SceneData
    properties
        scenePath
        sceneFileName
        sceneName
    end
    
    methods
        % Constructor
        function obj = SceneData(sceneFileName, sceneName)
            obj.sceneFileName = sceneFileName;
            obj.sceneName = sceneName;
            obj.scenePath = fullfile(fileparts(mfilename('fullpath')), '../scenes', sceneFileName);
        end
    end
end