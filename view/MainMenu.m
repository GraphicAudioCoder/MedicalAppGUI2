% /view/MainMenu.m

% Menu for choosing the mode 
classdef MainMenu < handle
    properties
        mainWindow
        controller
        components
    end

    methods
        function obj = MainMenu(mainWindow, controller)
            NamesFonts;
            theme = ThemeManager();
            
            obj.mainWindow = mainWindow;
            obj.controller = controller;
            obj.components = containers.Map();

            figPosition = mainWindow.Position;
            
            % Welcome label
            welcomeLabel = uilabel(mainWindow, ...
                'Position', [figPosition(3)/4, figPosition(4)*0.83, figPosition(3)/2, 50], ...
                'Text', ['Welcome to ', APP_NAME], ...
                'FontSize', HEADER_FONT_SIZE, ...
                'FontName', HEADER_FONT, ...
                'FontColor', theme.HEADER_COLOR, ...
                'HorizontalAlignment', 'center');
            obj.components('welcomeLabel') = welcomeLabel;

            % Dimensions and positions for buttons
            buttonHeight = 80;
            buttonWidth = 250;
            startX = 55;
            lowerVerticalPosition = 400;

            % Theme Button
            if strcmp(theme.THEME, 'DARK')
                themeIconPath = fullfile(fileparts(mfilename('fullpath')), '../assets/icons/sun.png');  
            else
                themeIconPath = fullfile(fileparts(mfilename('fullpath')), '../assets/icons/moon.png');
            end
            themeButton = uibutton(mainWindow, ...
                'Position', [figPosition(3)-90, figPosition(4)-50, 30, 30], ...
                'Text', '', ...
                'FontSize', HELP_BTN_FONT_SIZE, ...
                'BackgroundColor', theme.THEME_BTN_COLOR, ...
                'ButtonPushedFcn', @(btn, event) obj.onThemeButtonPushed(btn), ...
                'Icon', themeIconPath, ...
                'IconAlignment', 'right');
            obj.components('themeButton') = themeButton;

            % User button
            leftButtonPosition = [startX, lowerVerticalPosition - buttonHeight, buttonWidth, buttonHeight];
            leftButton = uibutton(mainWindow, ...
                'Position', leftButtonPosition, ...
                'FontSize', MODE_FONT_SIZE, ...
                'FontName', MODE_FONT, ...
                'BackgroundColor', theme.USER_COLOR, ...
                'FontColor', theme.FONT_MAIN_MENU_COLOR, ...
                'Text', {'USER', 'MODE'}, ...
                'ButtonPushedFcn', @(btn, event)obj.onUserModeButtonPushed(mainWindow));
            obj.components('leftButton') = leftButton;

            % Developer button
            centerButtonPosition = [(figPosition(3) - buttonWidth) / 2, lowerVerticalPosition - buttonHeight, buttonWidth, buttonHeight];
            centerButton = uibutton(mainWindow, ...
                'Position', centerButtonPosition, ...
                'FontSize', MODE_FONT_SIZE, ...
                'FontName', MODE_FONT, ...
                'BackgroundColor', theme.DEVELOPER_COLOR, ...
                'FontColor', theme.FONT_MAIN_MENU_COLOR, ...
                'Text', {'DEVELOPER', 'MODE'});
            obj.components('centerButton') = centerButton; % Store in components map

            % Block button
            rightButtonPosition = [figPosition(3) - buttonWidth - startX, lowerVerticalPosition - buttonHeight, buttonWidth, buttonHeight];
            rightButton = uibutton(mainWindow, ...
                'Position', rightButtonPosition, ...
                'FontSize', MODE_FONT_SIZE, ...
                'FontName', MODE_FONT, ...
                'BackgroundColor', theme.BLOCK_COLOR, ...
                'FontColor', theme.FONT_MAIN_MENU_COLOR, ...
                'Text', {'BLOCK', 'MODE'});
            obj.components('rightButton') = rightButton;
        end

        % Left button callback
        function onUserModeButtonPushed(obj, mainWindow)
            UserWindow(mainWindow, obj.controller);
            obj.delete();
        end
        
        % Theme button listener
        function onThemeButtonPushed(obj, btn)
            theme = ThemeManager('switch');        
            currentColors = theme;
            
            if strcmp(theme.THEME, 'DARK')
                themeIconPath = fullfile(fileparts(mfilename('fullpath')), '../assets/icons/sun.png');
            else
                themeIconPath = fullfile(fileparts(mfilename('fullpath')), '../assets/icons/moon.png');
            end
            btn.Icon = themeIconPath;
            
            % Update the colors of various UI components
            obj.mainWindow.Color =  currentColors.BACKGROUND_COLOR;
            welcomeLabel = obj.components('welcomeLabel');
            welcomeLabel.FontColor = currentColors.HEADER_COLOR;
            leftButton = obj.components('leftButton');
            leftButton.BackgroundColor = currentColors.USER_COLOR;
            leftButton.FontColor = currentColors.FONT_MAIN_MENU_COLOR;
            centerButton = obj.components('centerButton');
            centerButton.BackgroundColor = currentColors.DEVELOPER_COLOR;
            centerButton.FontColor = currentColors.FONT_MAIN_MENU_COLOR;
            rightButton = obj.components('rightButton');
            rightButton.BackgroundColor = currentColors.BLOCK_COLOR;
            rightButton.FontColor = currentColors.FONT_MAIN_MENU_COLOR;
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
