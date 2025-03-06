% /view/user/TargetSpeakerPanel.m

classdef TargetSpeakerPanel < handle
    properties
        mainWindow
        components
        controller
        scrollableArea
        targetFiles
    end

    properties (Access = private)
        isCallbackSet = false;
    end
    
    methods
        function obj = TargetSpeakerPanel(mainWindow, controller)
            NamesFonts;
            theme = ThemeManager();

            obj.mainWindow = mainWindow;
            obj.components = containers.Map();
            obj.controller = controller;
        end
        
         % Sets the visibility of all components
         function setVisibility(obj, visibility)
            keys = obj.components.keys;
            for i = 1:length(keys)
                componentName = keys{i};
                if isvalid(obj.components(componentName))
                    component = obj.components(componentName);
                    if visibility
                        component.Visible = 'on';
                    else
                        component.Visible = 'off';
                    end
                end
            end
        end
        
         % Shows a component
         function showComponent(obj, componentName)
            if isKey(obj.components, componentName)
                component = obj.components(componentName);
                component.Visible = 'on';
            end
        end

         % Update listeners based on the selected scene
        function updateTargetSpeaker(obj, currentScene)
            NamesFonts;
            theme = ThemeManager();

            listener = obj.controller.getListener();
            
            % Add target image
            targetPath = fullfile(currentScene.scenePath, 'targets');
            obj.targetFiles = dir(fullfile(targetPath, '*.png'));
            if isempty(obj.targetFiles)
                obj.targetFiles = dir(fullfile(targetPath, '*.jpg'));
            end

            if ~isempty(obj.targetFiles)
                if listener ~= 0
                    targetFile = '';
                    for i = 1:length(obj.targetFiles)
                        if contains(obj.targetFiles(i).name, 'targets') && contains(obj.targetFiles(i).name, ['l', num2str(listener)])
                            targetFile = obj.targetFiles(i).name;
                            break;
                        end
                    end                    
                    if ~isempty(targetFile)
                        targetImgPath = fullfile(targetPath, targetFile);
                        targetImg = uiimage(obj.mainWindow, ...
                            'ImageSource', targetImgPath, ...
                            'Position', [USER_PANEL_X_START + 10, 80, 560, 560]);
                        obj.components('targetImg') = targetImg;
                    end                    
                else
                    targetImg = uiimage(obj.mainWindow, ...
                        'Position', [USER_PANEL_X_START + 10, 80, 560, 560]);
                    obj.components('targetImg') = targetImg;
                end
            end

            if (~obj.isCallbackSet)
                % Set right-click callback without overwriting existing one
                originalRightClickCallback = obj.mainWindow.WindowButtonDownFcn;
                obj.mainWindow.WindowButtonDownFcn = @(src, event) obj.combinedRightClickCallback(originalRightClickCallback, src, event);
                obj.isCallbackSet = true;
            end

            obj.setVisibility(false);
        end

        % Combined right-click callback
        function combinedRightClickCallback(obj, originalCallback, src, event)
            if ~isempty(originalCallback)
                originalCallback(src, event);
            end
            targetImg = obj.components('targetImg');
            if strcmp(targetImg.Visible, 'on')
                obj.printClickPosition();
            end
        end

        % Print click position and "Click" relative to the image
        function printClickPosition(obj)
            % Get the position of the target image
            targetImg = obj.components('targetImg');
            mousePos = targetImg.Parent.CurrentPoint;
            imgPosition = targetImg.Position;
            imgSize = targetImg.Position(3:4); % Get the size of the image

            relativePos = [mousePos(1) - imgPosition(1), mousePos(2) - imgPosition(2)];
            deltaFromTargets = 10;
            targetPositions = obj.controller.currentScene.targets;
            targetsForListeners = obj.controller.currentScene.targetsForListeners;

            if relativePos(1) > 0 && relativePos(2) > 0 && relativePos(1) < imgSize(1) && relativePos(2) < imgSize(2)
            for i = 1:size(targetPositions, 1)
                targetPos = targetPositions(i, :);
                distance = sqrt((relativePos(1) - targetPos(1))^2 + (relativePos(2) - targetPos(2))^2);
                if distance <= deltaFromTargets
                    % disp(['Mouse Position relative to image: ', num2str(relativePos)]);

                    targetsFile = '';
                    for j = 1:length(obj.targetFiles)
                        disp(obj.targetFiles(j).name);
                        if contains(obj.targetFiles(j).name, ['_', num2str(targetsForListeners(i))]) && contains(obj.targetFiles(j).name, ['l', num2str(obj.controller.currentScene.selectedListener)])
                            targetsFile = obj.targetFiles(j).name;
                            break;
                        end
                    end

                    if (~isempty(targetsFile))
                        targetImgPath = fullfile(obj.controller.currentScene.scenePath, 'targets', targetsFile);
                        targetImg.ImageSource = targetImgPath;
                    end
                end
            end
            end
        end
        
        % Clear all panel
        function clearPanel(obj)
        end

        % Change theme
        function changeColors(obj, currentColors)
        end
    end
end
