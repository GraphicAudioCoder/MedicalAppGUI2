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
        isMouseMoveCallbackSet = false;
        isInTargetRange = false; % Aggiungi questa proprietà
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
            currentLang = LanguageManager('get');

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
                        orientationDropdown = obj.components('orientationDropdown');
                    else
                        targetImg = uiimage(obj.mainWindow, ...
                            'Position', [USER_PANEL_X_START + 10, 80, 560, 560], ...
                            'Visible', 'off');
                        orientationDropdown.Items = {''};
                    end
                    obj.components('targetImg') = targetImg;
                else
                    targetImg = uiimage(obj.mainWindow, ...
                        'Position', [USER_PANEL_X_START + 10, 80, 560, 560], ...
                        'Visible', 'off');
                    obj.components('targetImg') = targetImg;
                end
            end

            % Add text area for target speaker details
            textAreaLabel = uilabel(obj.mainWindow, ...
                'Text', currentLang.TARGET_SPECS_LABEL, ...
                'FontSize', 16, ...
                'FontName', MAIN_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'HorizontalAlignment', 'left', ...
                'FontWeight', 'bold', ...
                'Position', [USER_PANEL_X_START + 580, 620, 200, 30]);
            obj.components('textAreaLabel') = textAreaLabel;

            textArea = uitextarea(obj.mainWindow, ...
                'Value', {''}, ...
                'FontSize', SPECS_FONT_SIZE, ...
                'FontName', SPECS_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE, ...
                'Editable', 'off', ...
                'Position', [USER_PANEL_X_START + 580, 360, 190, 250]);
            obj.components('textArea') = textArea;

            % Add dropdown for target orientation
            orientationLabel = uilabel(obj.mainWindow, ...
                'Text', currentLang.TARGET_ORIENTATION_LABEL, ...
                'FontSize', 16, ...
                'FontName', MAIN_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'HorizontalAlignment', 'left', ...
                'FontWeight', 'bold', ...
                'Position', [USER_PANEL_X_START + 580, 320, 200, 30]);
            obj.components('orientationLabel') = orientationLabel;

            orientationDropdown = uidropdown(obj.mainWindow, ...
                'Items', {''}, ...
                'FontSize', SPECS_FONT_SIZE, ...
                'FontName', SPECS_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE, ...
                'Position', [USER_PANEL_X_START + 580, 280, 190, 30]);
            obj.components('orientationDropdown') = orientationDropdown;

            if (~obj.isCallbackSet)
                % Set right-click callback without overwriting existing one
                originalRightClickCallback = obj.mainWindow.WindowButtonDownFcn;
                obj.mainWindow.WindowButtonDownFcn = @(src, event) obj.combinedRightClickCallback(originalRightClickCallback, src, event);
                obj.isCallbackSet = true;
            end

            % if (~obj.isMouseMoveCallbackSet)
            %     % Set mouse move callback without overwriting existing one
            %     originalMouseMoveCallback = obj.mainWindow.WindowButtonMotionFcn;
            %     obj.mainWindow.WindowButtonMotionFcn = @(src, event) obj.combinedMouseMoveCallback(originalMouseMoveCallback, src, event);
            %     obj.isMouseMoveCallbackSet = true;
            % end

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

        % Combined mouse move callback
        function combinedMouseMoveCallback(obj, originalCallback, src, event)
            if ~isempty(originalCallback)
                originalCallback(src, event);
            end

            targetImg = obj.components('targetImg');
            if strcmp(targetImg.Visible, 'on')
                obj.printMousePosition();
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
                            if contains(obj.targetFiles(j).name, ['_', num2str(targetsForListeners(i))]) && contains(obj.targetFiles(j).name, ['l', num2str(obj.controller.currentScene.selectedListener)])
                                targetsFile = obj.targetFiles(j).name;
                                break;
                            end
                        end

                        if (~isempty(targetsFile))
                            targetImgPath = fullfile(obj.controller.currentScene.scenePath, 'targets', targetsFile);
                            targetImg.ImageSource = targetImgPath;
                            obj.controller.onSelectTargetSpeaker(i);
                            selectedTarget = targetsForListeners(obj.controller.currentScene.selectedTarget);
                            selectedListener = obj.controller.currentScene.selectedListener;
                            selectedMatrix = obj.controller.currentScene.targetsForListenersSpecs{selectedTarget, selectedListener};

                            textAreaContent = cell(size(selectedMatrix, 1), 1);
                            for k = 1:size(selectedMatrix, 1)
                                textAreaContent{k} = [selectedMatrix{k, 1}, ': ', selectedMatrix{k, 2}];
                            end
                            textArea = obj.components('textArea');
                            textArea.Value = textAreaContent;
                            orientationDropdown = obj.components('orientationDropdown');
                            orientationDropdown.Items = obj.controller.currentScene.targetOrientation;
                        end
                    end
                end
            end
        end

        function printMousePosition(obj)
            targetImg = obj.components('targetImg');
            mousePos = targetImg.Parent.CurrentPoint;
            imgPosition = targetImg.Position;
            imgSize = targetImg.Position(3:4);

            relativePos = [mousePos(1) - imgPosition(1), mousePos(2) - imgPosition(2)];
            deltaFromTargets = 10;
            targetPositions = obj.controller.currentScene.targets;
            targetsForListeners = obj.controller.currentScene.targetsForListeners;

            if relativePos(1) > 0 && relativePos(2) > 0 && relativePos(1) < imgSize(1) && relativePos(2) < imgSize(2)
                for i = 1:size(targetPositions, 1)
                    targetPos = targetPositions(i, :);
                    distance = sqrt((relativePos(1) - targetPos(1))^2 + (relativePos(2) - targetPos(2))^2);
                    if distance <= deltaFromTargets
                        if ~obj.isInTargetRange
                            disp("Press k");
                            obj.isInTargetRange = true;
                        end
                        return;
                    end
                end
            end
            obj.isInTargetRange = false; % Reset quando esci dal range
        end
        
        % Clear all panel
        function clearPanel(obj)
        end

        function updateLanguageUI(obj, lang)
            if isKey(obj.components, 'textAreaLabel')
                textAreaLabel = obj.components('textAreaLabel');
                textAreaLabel.Text = lang.TARGET_SPECS_LABEL;
            end

            if isKey(obj.components, 'orientationLabel')
                orientationLabel = obj.components('orientationLabel');
                orientationLabel.Text = lang.TARGET_ORIENTATION_LABEL;
            end
        end

        % Change theme
        function changeColors(obj, currentColors)
            keys = obj.components.keys;
            for i = 1:length(keys)
                componentName = keys{i};
                component = obj.components(componentName);

                if isa(component, 'matlab.ui.container.Panel') && ~strcmp(componentName, 'mainPanel')
                    component.BackgroundColor = currentColors.USER_PANEL_COLOR;
                end

                if isa(component, 'matlab.ui.control.Label')
                    component.FontColor = currentColors.USER_LABEL_COLOR;
                end

                if isa(component, 'matlab.ui.control.Button')
                    component.BackgroundColor = currentColors.USER_CURRENT_TABS_COLOR;
                    component.FontColor = currentColors.USER_LABEL_COLOR;
                end

                if isa(component, 'matlab.ui.control.Image')
                    component.BackgroundColor = currentColors.USER_CURRENT_TABS_COLOR;
                end

                if isa(component, 'matlab.ui.control.NumericEditField')
                    component.BackgroundColor = currentColors.USER_GUI_ELEM_COLOR_ONE;
                    component.FontColor = currentColors.USER_LABEL_COLOR;
                end

                if isa(component, 'matlab.ui.control.Image') && strcmp(componentName, 'arrowImg')
                    arrowIconPath = fullfile(fileparts(mfilename('fullpath')), ['..', filesep, '..', filesep, 'assets', filesep, 'icons', filesep, 'arrow.png']);
                    
                    arrowImgRGB = imread(arrowIconPath);
                    rotatedArrowImgRGB = arrowImgRGB;
                    blackPixels = rotatedArrowImgRGB(:, :, 1) == 0 & rotatedArrowImgRGB(:, :, 2) == 0 & rotatedArrowImgRGB(:, :, 3) == 0;

                    rotatedArrowImgRGB(repmat(blackPixels, [1, 1, 3])) = repmat(currentColors.USER_CURRENT_TABS_COLOR * 255, [sum(blackPixels(:)), 1]);
                    tempImagePath = fullfile(tempdir, ['modifiedArrow', num2str(obj.arrowImageCounter), '.png']);
                    obj.arrowImageCounter = obj.arrowImageCounter + 1;
                
                    imwrite(rotatedArrowImgRGB, tempImagePath);
                    component.ImageSource = tempImagePath;
                end

                if isa(component, 'matlab.ui.control.DropDown')
                    component.BackgroundColor = currentColors.USER_GUI_ELEM_COLOR_ONE;
                    component.FontColor = currentColors.USER_LABEL_COLOR;
                end

                if isa(component, 'matlab.ui.control.TextArea')
                    component.BackgroundColor = currentColors.USER_GUI_ELEM_COLOR_ONE;
                    component.FontColor = currentColors.USER_LABEL_COLOR;
                end
            end
        end
    end
end