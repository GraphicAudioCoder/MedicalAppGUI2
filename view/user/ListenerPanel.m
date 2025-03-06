% /view/user/ListenerPanel.m

classdef ListenerPanel < handle
    properties
        mainWindow
        components
        controller
        scrollableArea
        patientFiles
        arrowImageCounter = 1;
    end
    
    properties (Access = private)
        isCallbackSet = false;
    end
    
    methods
        function obj = ListenerPanel(mainWindow, controller)
            NamesFonts;
            theme = ThemeManager();
            currentLang = LanguageManager('get');

            obj.mainWindow = mainWindow;
            obj.components = containers.Map();
            obj.controller = controller;

            % Selected Listener Label
            % selectedLabel = uilabel(obj.mainWindow, ...
            %     'Text', 'Selected listener: ', ...
            %     'Position', [USER_PANEL_X_START + 20, 40, 500, 30], ...
            %     'FontSize', NEXT_BTN_FONT_SIZE, ...
            %     'FontName', MAIN_FONT, ...
            %     'FontColor', theme.USER_LABEL_TABS_COLOR, ...
            %     'HorizontalAlignment', 'left', ...
            %     'FontWeight', 'bold');
            % obj.components('selectedLabel') = selectedLabel;

            % Elevation Label
            elevationLabel = uilabel(obj.mainWindow, ...
                'Text', currentLang.LISTENER_ELEVATION_LABEL, ...
                'Position', [USER_PANEL_X_START + 590, 500, 200, 30], ...
                'FontSize', SELECT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'HorizontalAlignment', 'left', ...
                'FontWeight', 'bold');
            obj.components('elevationLabel') = elevationLabel;

            % Elevation Dropdown
            elevationDropdown = uidropdown(obj.mainWindow, ...
                'Position', [USER_PANEL_X_START + 690, 500, 80, 30], ...
                'FontSize', SELECT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE, ...
                'enable', 'off', ...
                'Items', {'0'}, ...
                'ValueChangedFcn', @(src, event) obj.onElevationChanged(src, event));
            obj.components('elevationDropdown') = elevationDropdown;

            % Azimuth Label
            azimuthLabel = uilabel(obj.mainWindow, ...
                'Text', currentLang.LISTENER_AZIMUTH_LABEL, ...
                'Position', [USER_PANEL_X_START + 590, 450, 200, 30], ...
                'FontSize', SELECT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'HorizontalAlignment', 'left', ...
                'FontWeight', 'bold');
            obj.components('azimuthLabel') = azimuthLabel;

            % Azimuth Dropdown
            azimuthDropdown = uidropdown(obj.mainWindow, ...
                'Position', [USER_PANEL_X_START + 690, 450, 80, 30], ...
                'FontSize', SELECT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE, ...
                'enable', 'off', ...
                'Items', {'0'}, ...
                'ValueChangedFcn', @(src, event) obj.onAzimuthChanged(src, event));
            obj.components('azimuthDropdown') = azimuthDropdown;

            % Update language for UI components
            % obj.updateLanguageUI(currentLang);
        end

        % Sets the listener
        function onSelectListenerButtonPushed(obj, panelIndex) 
        end

        % Sets the visibility of all components
        function setVisibility(obj, visibility)
            keys = obj.components.keys;
            for i = 1:length(keys)
                componentName = keys{i};
                if isvalid(obj.components(componentName))
                    component = obj.components(componentName);
                    if strcmp(componentName, 'arrowImg')
                        component.Visible = 'off';
                    elseif visibility
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
        
        % Hide a component
        function hideComponent(obj, componentName)
            if isKey(obj.components, componentName)
                component = obj.components(componentName);
                component.Visible = 'off';
            end
        end

        % Update listeners based on the selected scene
        function updateListeners(obj, currentScene)
            NamesFonts;
            theme = ThemeManager();

            % Add patient image
            patientPath = fullfile(currentScene.scenePath, 'listeners');
            obj.patientFiles = dir(fullfile(patientPath, '*.png'));
            if isempty(obj.patientFiles)
                obj.patientFiles = dir(fullfile(patientPath, '*.jpg'));
            end

            if ~isempty(obj.patientFiles)
                % Find the file that ends with 'listeners'
                listenerFile = '';
                for i = 1:length(obj.patientFiles)
                    if contains(obj.patientFiles(i).name, 'listeners')
                        listenerFile = obj.patientFiles(i).name;
                        break;
                    end
                end

                if ~isempty(listenerFile)
                    patientImgPath = fullfile(patientPath, listenerFile);
                    patientImg = uiimage(obj.mainWindow, ...
                        'ImageSource', patientImgPath, ...
                        'Position', [USER_PANEL_X_START + 10, 80, 560, 560]);
                    obj.components('patientImg') = patientImg;

                    elevationDropdown = obj.components('elevationDropdown');
                    azimuthDropdown = obj.components('azimuthDropdown');
                    elevationDropdown.Enable = 'off';
                    azimuthDropdown.Enable = 'off';

                    elevationDropdown.Items = {'0'};
                    azimuthDropdown.Items = {'0'};
                end

                arrowIconPath = fullfile(fileparts(mfilename('fullpath')), ['..', filesep, '..', filesep, 'assets', filesep, 'icons', filesep, 'arrow.png']);
                arrowImg = uiimage(obj.mainWindow, ...
                    'ImageSource', arrowIconPath, ...
                    'Position', [USER_PANEL_X_START + 610, 350, 50, 50]);

                arrowImgRGB = imread(arrowIconPath);
                rotatedArrowImgRGB = imrotate(arrowImgRGB, 180, 'bilinear', 'crop');
                blackPixels = rotatedArrowImgRGB(:, :, 1) == 0 & rotatedArrowImgRGB(:, :, 2) == 0 & rotatedArrowImgRGB(:, :, 3) == 0;

                rotatedArrowImgRGB(repmat(blackPixels, [1, 1, 3])) = repmat(theme.USER_CURRENT_TABS_COLOR * 255, [sum(blackPixels(:)), 1]);
                tempImagePath = fullfile(tempdir, 'modifiedArrow.png');
                imwrite(rotatedArrowImgRGB, tempImagePath);
                arrowImg.ImageSource = tempImagePath;

                obj.components('arrowImg') = arrowImg;

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
            elevationLabel = obj.components('elevationLabel');
            if strcmp(elevationLabel.Visible, 'on')
                obj.printClickPosition();
            end
        end

        % Print click position and "Click" relative to the image
        function printClickPosition(obj)
            patientImg = obj.components('patientImg');
            mousePos = patientImg.Parent.CurrentPoint;
            imgPos = patientImg.Position;
            relativePos = [mousePos(1) - imgPos(1), mousePos(2) - imgPos(2)];
            deltaFromListener = 10; % Define the radius around the listener positions
            listenerPositions = obj.controller.currentScene.listenerPositions;

            if relativePos(1) > 0 && relativePos(2) > 0 && relativePos(1) < 500 && relativePos(2) < 500
                for i = 1:size(listenerPositions, 1)
                    listenerPos = listenerPositions(i, :);
                    distance = sqrt((relativePos(1) - listenerPos(1))^2 + (relativePos(2) - listenerPos(2))^2);
                    if distance <= deltaFromListener
                        % disp(['Mouse Position relative to image: ', num2str(relativePos)]);
                        
                        % Find the file that ends with _i
                        listenerFile = '';
                        for j = 1:length(obj.patientFiles)
                            if contains(obj.patientFiles(j).name, ['_', num2str(i)])
                                listenerFile = obj.patientFiles(j).name;
                                break;
                            end
                        end

                        if (~isempty(listenerFile))
                            patientImgPath = fullfile(obj.controller.currentScene.scenePath, 'listeners', listenerFile);
                            patientImg.ImageSource = patientImgPath;
                            elevationDropdown = obj.components('elevationDropdown');
                            azimuthDropdown = obj.components('azimuthDropdown');
                            elevationDropdown.Enable = 'on';
                            azimuthDropdown.Enable = 'on';
                            obj.controller.onSelectListener(i);
                            
                            elevationDropdown.Items = string(obj.controller.getListenerElevations(i));
                            azimuthDropdown.Items = [string(obj.controller.getListenerAzimuths(i)), "60"];
                            obj.controller.targetSpeakerPanel.updateTargetSpeaker(obj.controller.currentScene);
                        end
                    end
                end
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
                
            end
        end

        function updateLanguageUI(obj, lang)
            % selectListenerPosLabel = obj.components('selectListenerPosLabel');
            % selectListenerPosLabel.Text = lang.SELECT_LISTENER_POS_LABEL;
            % selectedLabel = obj.components('selectedLabel');
            % selectedLabel.Text = lang.SELECTED_LISTENER_LABEL;

            elevationLabel = obj.components('elevationLabel');
            elevationLabel.Text = lang.LISTENER_ELEVATION_LABEL;

            azimuthLabel = obj.components('azimuthLabel');
            azimuthLabel.Text = lang.LISTENER_AZIMUTH_LABEL;
        end

        function onElevationChanged(obj, src, event)
            newElevation = src.Value;
            obj.controller.setListenerElevation(newElevation);
        end

        function onAzimuthChanged(obj, src, event)
            newAzimuth = str2double(src.Value);
            theme = ThemeManager();

            obj.controller.setListenerAzimuth(newAzimuth);

            arrowImg = obj.components('arrowImg');
            arrowIconPath = fullfile(fileparts(mfilename('fullpath')), ['..', filesep, '..', filesep, 'assets', filesep, 'icons', filesep, 'arrow.png']);
                
            arrowImgRGB = imread(arrowIconPath);
            rotatedArrowImgRGB = imrotate(arrowImgRGB, newAzimuth, 'bilinear', 'crop');
            blackPixels = rotatedArrowImgRGB(:, :, 1) == 0 & rotatedArrowImgRGB(:, :, 2) == 0 & rotatedArrowImgRGB(:, :, 3) == 0;

            rotatedArrowImgRGB(repmat(blackPixels, [1, 1, 3])) = repmat(theme.USER_CURRENT_TABS_COLOR * 255, [sum(blackPixels(:)), 1]);
            tempImagePath = fullfile(tempdir, ['modifiedArrow', num2str(obj.arrowImageCounter), '.png']);
            obj.arrowImageCounter = obj.arrowImageCounter + 1;
        
            imwrite(rotatedArrowImgRGB, tempImagePath);
            arrowImg.ImageSource = tempImagePath;
            pause(0.2);
            arrowImg.Visible = 'on';
            pause(1.5);
            arrowImg.Visible = 'off';
        end
    end
end
