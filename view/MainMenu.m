% /view/MainMenu.m

% Menu for choosing the mode 
classdef MainMenu < handle
    properties
        controller
        components
    end

    methods
        function obj = MainMenu(mainWindow, controller)
            NameFontColor;

            obj.controller = controller;
            obj.components = containers.Map();

            figPosition = mainWindow.Position;
            
            % Welcome label
            welcomeLabel = uilabel(mainWindow, ...
                'Position', [figPosition(3)/4, figPosition(4)*0.83, figPosition(3)/2, 50], ...
                'Text', ['Welcome to ', APP_NAME], ...
                'FontSize', HEADER_FONT_SIZE, ...
                'FontName', HEADER_FONT, ...
                'FontColor', HEADER_COLOR, ...
                'HorizontalAlignment', 'center');
            obj.components('welcomeLabel') = welcomeLabel;

            % Dimensions and positions for buttons
            buttonHeight = 420;
            buttonWidth = 250;
            startX = 55;
            lowerVerticalPosition = figPosition(4) * 0.7;

            % User button
            leftButtonPosition = [startX, lowerVerticalPosition - buttonHeight, buttonWidth, buttonHeight];
            leftButton = uibutton(mainWindow, ...
                'Position', leftButtonPosition, ...
                'FontSize', MODE_FONT_SIZE, ...
                'FontName', MODE_FONT, ...
                'BackgroundColor', USER_COLOR, ...
                'Text', {'USER', 'MODE'}, ...
                'ButtonPushedFcn', @(btn, event)obj.onUserModeButtonPushed(mainWindow));
            obj.components('leftButton') = leftButton;

            % Developer button
            centerButtonPosition = [(figPosition(3) - buttonWidth) / 2, lowerVerticalPosition - buttonHeight, buttonWidth, buttonHeight];
            centerButton = uibutton(mainWindow, ...
                'Position', centerButtonPosition, ...
                'FontSize', MODE_FONT_SIZE, ...
                'FontName', MODE_FONT, ...
                'BackgroundColor', DEVELOPER_COLOR, ...
                'Text', {'DEVELOPER', 'MODE'});
            obj.components('centerButton') = centerButton; % Store in components map

            % Block button
            rightButtonPosition = [figPosition(3) - buttonWidth - startX, lowerVerticalPosition - buttonHeight, buttonWidth, buttonHeight];
            rightButton = uibutton(mainWindow, ...
                'Position', rightButtonPosition, ...
                'FontSize', MODE_FONT_SIZE, ...
                'FontName', MODE_FONT, ...
                'BackgroundColor', BLOCK_COLOR, ...
                'Text', {'BLOCK', 'MODE'});
            obj.components('rightButton') = rightButton;
        end

        % Left button callback
        function onUserModeButtonPushed(obj, mainWindow)
            UserWindow(mainWindow, obj.controller);
            obj.delete();
        end

        % Delete all created components
        function delete(obj)
            keys = obj.components.keys();
            for i = 1:length(keys)
                component = obj.components(keys{i});
                if isvalid(component)
                    delete(component);
                end
            end
        end
    end
end
