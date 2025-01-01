% /view/user/UserWindow.m

classdef UserWindow < handle
    properties
        mainWindow
        controller
        components
        onHeaderPanel
        onPatientTab
        onEnvironmentTab
        onListenerTab
        onTargetSpeakerTab
        onMaskingNoiseTab
        onTestSettingsTab
        mouseDown
        mouseUp
    end
    methods
        function obj = UserWindow(mainWindow, controller)
            NameFontColor;

            obj.mainWindow = mainWindow;
            obj.controller = controller;
            obj.components = containers.Map();
            obj.onHeaderPanel = false;
            obj.onPatientTab = false;
            obj.onEnvironmentTab = false;
            obj.onListenerTab = false;
            obj.onTargetSpeakerTab = false;
            obj.onMaskingNoiseTab = false;
            obj.onTestSettingsTab = false;
            obj.mouseUp = true;
            obj.mouseDown = false;

            figPosition = mainWindow.Position;
            
            % Header Panel
            headerPanel = uipanel(mainWindow, ...
                'Position', [10, 660, figPosition(3)-20, 50], ...
                'BackgroundColor', USER_HEADER_COLOR);
            obj.components('headerPanel') = headerPanel;

            % Help Button
            helpIconPath = fullfile(fileparts(mfilename('fullpath')), '../../assets/icons/help.png');
            helpButton = uibutton(mainWindow, ...
                'Position', [figPosition(3)-100, figPosition(4)-50, 70, 30], ...
                'Text', 'Help', ...
                'FontSize', HELP_BTN_FONT_SIZE, ...
                'BackgroundColor', HELP_BTN_COLOR, ...
                'ButtonPushedFcn', @(btn, event)obj.onHelpButtonPushed(), ...
                'Icon', helpIconPath, ...
                'IconAlignment', 'right');
            obj.components('helpButton') = helpButton;
            
            % User Mode Label
            userModeLabel = uilabel(mainWindow, ...
                'Text', 'USER MODE', ...
                'Position', [20, figPosition(4)-50, figPosition(3)*0.6, 30], ...
                'FontSize', MODE_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'FontColor', USER_LABEL_COLOR, ...
                'HorizontalAlignment', 'left', ...
                'FontWeight', 'bold');
            obj.components('userModeLabel') = userModeLabel;

            % Test Label
            testLabel = uilabel(mainWindow, ...
                'Text', 'Test Configuration', ...
                'Position', [260, figPosition(4)-50, figPosition(3)*0.6, 30], ...
                'FontSize', MODE_FONT_SIZE - 2, ...
                'FontName', 'Arial', ...
                'HorizontalAlignment', 'left', ...
                'FontWeight', 'bold');
            obj.components('testLabel') = testLabel;

            % Tab Panel
            tabPanel = uipanel(mainWindow, ...
                'Position', [10, 10, 220, figPosition(4)-70], ...
                'BackgroundColor', USER_HEADER_COLOR);
            obj.components('tabPanel') = tabPanel;

            tabSize = 50;
            tabStartY = figPosition(4)-110;

            % Patient Tab
            patientTab = uipanel(mainWindow, ...
                'Position', [10, tabStartY, 220, tabSize], ...
                'BackgroundColor', USER_TABS_COLOR);
            obj.components('patientTab') = patientTab;

            % Patient Label
            patientLabel = uilabel(mainWindow, ...
                'Text', 'Patient', ...
                'Position', [20, tabStartY + 10, 180, 30], ...
                'FontSize', TABS_FONT_SIZE, ...
                'FontName', TAB_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontWeight', 'bold');
            obj.components('patientLabel') = patientLabel;

            % Environment Tab
            environmentTab = uipanel(mainWindow, ...
                'Position', [10, tabStartY - tabSize, 220, tabSize], ...
                'BackgroundColor', USER_TABS_COLOR);
            obj.components('environmentTab') = environmentTab;

            % Environment Label
            environmentLabel = uilabel(mainWindow, ...
                'Text', 'Environment', ...
                'Position', [20, tabStartY + 10 - tabSize, 180, 30], ...
                'FontSize', TABS_FONT_SIZE, ...
                'FontName', TAB_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontWeight', 'bold');
            obj.components('environmentLabel') = environmentLabel;

            % Listener Tab
            listenerTab = uipanel(mainWindow, ...
                'Position', [10, tabStartY - 2*tabSize, 220, tabSize], ...
                'BackgroundColor', USER_TABS_COLOR);
            obj.components('listenerTab') = listenerTab;

            % Listener Label
            listenerLabel = uilabel(mainWindow, ...
                'Text', 'Listener', ...
                'Position', [20, tabStartY + 10 - 2*tabSize, 180, 30], ...
                'FontSize', TABS_FONT_SIZE, ...
                'FontName', TAB_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontWeight', 'bold');
            obj.components('listenerLabel') = listenerLabel;

            % Target Speaker Tab
            targetSpeakerTab = uipanel(mainWindow, ...
                'Position', [10, tabStartY - 3*tabSize, 220, tabSize], ...
                'BackgroundColor', USER_TABS_COLOR);
            obj.components('targetSpeakerTab') = targetSpeakerTab;

            % Target Speaker Label
            targetSpeakerLabel = uilabel(mainWindow, ...
                'Text', 'Target Speaker', ...
                'Position', [20, tabStartY + 10 - 3*tabSize, 180, 30], ...
                'FontSize', TABS_FONT_SIZE, ...
                'FontName', TAB_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontWeight', 'bold');
            obj.components('targetSpeakerLabel') = targetSpeakerLabel;

            % Masking Noise Tab
            maskingNoiseTab = uipanel(mainWindow, ...
                'Position', [10, tabStartY - 4*tabSize, 220, tabSize], ...
                'BackgroundColor', USER_TABS_COLOR);
            obj.components('maskingNoiseTab') = maskingNoiseTab;

            % Masking Noise Label
            maskingNoiseLabel = uilabel(mainWindow, ...
                'Text', 'Masking Noise', ...
                'Position', [20, tabStartY + 10 - 4*tabSize, 180, 30], ...
                'FontSize', TABS_FONT_SIZE, ...
                'FontName', TAB_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontWeight', 'bold');
            obj.components('maskingNoiseLabel') = maskingNoiseLabel;

            % Test Settings Tab
            testSettingsTab = uipanel(mainWindow, ...
                'Position', [10, tabStartY - 5*tabSize, 220, tabSize], ...
                'BackgroundColor', USER_TABS_COLOR);
            obj.components('testSettingsTab') = testSettingsTab;

            % Test Settings Label
            testSettingsLabel = uilabel(mainWindow, ...
                'Text', 'Test Settings', ...
                'Position', [20, tabStartY + 10 - 5*tabSize, 180, 30], ...
                'FontSize', TABS_FONT_SIZE, ...
                'FontName', TAB_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontWeight', 'bold');
            obj.components('testSettingsLabel') = testSettingsLabel;

            % Event Handlers
            obj.mainWindow.WindowButtonMotionFcn = @(src, event)obj.onMouseMove(src, event);
            obj.mainWindow.WindowButtonDownFcn = @(src, event)obj.onRightClick(src, event);
            obj.mainWindow.WindowButtonUpFcn = @(src, event)obj.onMouseUp(src, event);
        end
        
        % Mouse move handler for detecting tab hover
        function onMouseMove(obj, src, event)
            NameFontColor;

            mousePos = get(src, 'Currentpoint');
            patientTab = obj.components('patientTab');
            environmentTab = obj.components('environmentTab');
            listenerTab = obj.components('listenerTab');
            targetSpeakerTab = obj.components('targetSpeakerTab');
            maskingNoiseTab = obj.components('maskingNoiseTab');
            testSettingsTab = obj.components('testSettingsTab');
            
            % Patient Tab hover detection
            patientPos = patientTab.Position;
            if ~obj.mouseDown
                if mousePos(1) >= patientPos(1) && mousePos(1) <= (patientPos(1) + patientPos(3)) && ...
                   mousePos(2) >= patientPos(2) && mousePos(2) <= (patientPos(2) + patientPos(4))
                    patientTab.BackgroundColor = USER_ON_TABS_COLOR;
                    obj.onPatientTab = true;
                else
                    patientTab.BackgroundColor = USER_TABS_COLOR;
                    obj.onPatientTab = false;
                end
            end
            
            % Environment Tab hover detection
            environmentPos = environmentTab.Position;
            if ~obj.mouseDown
                if mousePos(1) >= environmentPos(1) && mousePos(1) <= (environmentPos(1) + environmentPos(3)) && ...
                   mousePos(2) >= environmentPos(2) && mousePos(2) <= (environmentPos(2) + environmentPos(4))
                    environmentTab.BackgroundColor = USER_ON_TABS_COLOR;
                    obj.onEnvironmentTab = true;
                else
                    environmentTab.BackgroundColor = USER_TABS_COLOR;
                    obj.onEnvironmentTab = false;
                end
            end

            % Listener Tab hover detection
            listenerPos = listenerTab.Position;
            if ~obj.mouseDown
                if mousePos(1) >= listenerPos(1) && mousePos(1) <= (listenerPos(1) + listenerPos(3)) && ...
                   mousePos(2) >= listenerPos(2) && mousePos(2) <= (listenerPos(2) + listenerPos(4))
                    listenerTab.BackgroundColor = USER_ON_TABS_COLOR;
                    obj.onListenerTab = true;
                else
                    listenerTab.BackgroundColor = USER_TABS_COLOR;
                    obj.onListenerTab = false;
                end
            end

            % Target Speaker Tab hover detection
            targetSpeakerPos = targetSpeakerTab.Position;
            if ~obj.mouseDown
                if mousePos(1) >= targetSpeakerPos(1) && mousePos(1) <= (targetSpeakerPos(1) + targetSpeakerPos(3)) && ...
                   mousePos(2) >= targetSpeakerPos(2) && mousePos(2) <= (targetSpeakerPos(2) + targetSpeakerPos(4))
                    targetSpeakerTab.BackgroundColor = USER_ON_TABS_COLOR;
                    obj.onTargetSpeakerTab = true;
                else
                    targetSpeakerTab.BackgroundColor = USER_TABS_COLOR;
                    obj.onTargetSpeakerTab = false;
                end
            end

            % Masking Noise Tab hover detection
            maskingNoisePos = maskingNoiseTab.Position;
            if ~obj.mouseDown
                if mousePos(1) >= maskingNoisePos(1) && mousePos(1) <= (maskingNoisePos(1) + maskingNoisePos(3)) && ...
                   mousePos(2) >= maskingNoisePos(2) && mousePos(2) <= (maskingNoisePos(2) + maskingNoisePos(4))
                    maskingNoiseTab.BackgroundColor = USER_ON_TABS_COLOR;
                    obj.onMaskingNoiseTab = true;
                else
                    maskingNoiseTab.BackgroundColor = USER_TABS_COLOR;
                    obj.onMaskingNoiseTab = false;
                end
            end

            % Test Settings Tab hover detection
            testSettingsPos = testSettingsTab.Position;
            if ~obj.mouseDown
                if mousePos(1) >= testSettingsPos(1) && mousePos(1) <= (testSettingsPos(1) + testSettingsPos(3)) && ...
                   mousePos(2) >= testSettingsPos(2) && mousePos(2) <= (testSettingsPos(2) + testSettingsPos(4))
                    testSettingsTab.BackgroundColor = USER_ON_TABS_COLOR;
                    obj.onTestSettingsTab = true;
                else
                    testSettingsTab.BackgroundColor = USER_TABS_COLOR;
                    obj.onTestSettingsTab = false;
                end
            end
        end

        % Right click handler
        function onRightClick(obj, src, event)
            NameFontColor;

            obj.mouseDown = true;
            obj.mouseUp = false;
            if obj.onPatientTab
                patientTab = obj.components('patientTab');
                patientTab.BackgroundColor = USER_PRESSED_TABS_COLOR;
            elseif obj.onEnvironmentTab
                environmentTab = obj.components('environmentTab');
                environmentTab.BackgroundColor = USER_PRESSED_TABS_COLOR;
            elseif obj.onListenerTab
                listenerTab = obj.components('listenerTab');
                listenerTab.BackgroundColor = USER_PRESSED_TABS_COLOR;
            elseif obj.onTargetSpeakerTab
                targetSpeakerTab = obj.components('targetSpeakerTab');
                targetSpeakerTab.BackgroundColor = USER_PRESSED_TABS_COLOR;
            elseif obj.onMaskingNoiseTab
                maskingNoiseTab = obj.components('maskingNoiseTab');
                maskingNoiseTab.BackgroundColor = USER_PRESSED_TABS_COLOR;
            elseif obj.onTestSettingsTab
                testSettingsTab = obj.components('testSettingsTab');
                testSettingsTab.BackgroundColor = USER_PRESSED_TABS_COLOR;
            end
        end

        % Mouse release handler
        function onMouseUp(obj, src, event)
            NameFontColor;

            obj.mouseDown = false;
            obj.mouseUp = true;
            if obj.onPatientTab
                patientTab = obj.components('patientTab');
                patientTab.BackgroundColor = USER_ON_TABS_COLOR;
            end
            if obj.onEnvironmentTab
                environmentTab = obj.components('environmentTab');
                environmentTab.BackgroundColor = USER_ON_TABS_COLOR;
            end
            if obj.onListenerTab
                listenerTab = obj.components('listenerTab');
                listenerTab.BackgroundColor = USER_ON_TABS_COLOR;
            end
            if obj.onTargetSpeakerTab
                targetSpeakerTab = obj.components('targetSpeakerTab');
                targetSpeakerTab.BackgroundColor = USER_ON_TABS_COLOR;
            end
            if obj.onMaskingNoiseTab
                maskingNoiseTab = obj.components('maskingNoiseTab');
                maskingNoiseTab.BackgroundColor = USER_ON_TABS_COLOR;
            end
            if obj.onTestSettingsTab
                testSettingsTab = obj.components('testSettingsTab');
                testSettingsTab.BackgroundColor = USER_ON_TABS_COLOR;
            end
        end

        function onHelpButtonPushed(obj)
        end
        
        % Delete all components
        function delete(obj)
            componentNames = keys(obj.components);
            for i = 1:length(componentNames)
                component = obj.components(componentNames{i});
                if isvalid(component)
                    delete(component);
                end
            end
        end
    end
end
