% /view/MainWindow.m

% Main UI window
classdef MainWindow < handle
    properties
        fig
        controller
        currentUI
    end
    
    methods
        function obj = MainWindow(controller)
            obj.controller = controller;
            obj.createUI();
        end
        
        % Creates the main UI window with specific dimensions and position
        function createUI(obj)
            NamesFonts;
            theme = ThemeManager('forceDark');

            screenSize = get(0, 'ScreenSize');            
            figWidth = 1080;
            figHeight = 720;
            figX = (screenSize(3) - figWidth) / 2;
            figY = (screenSize(4) - figHeight) / 2;

            % Create a fixed-size, non-resizable window
            obj.fig = uifigure('Position', [figX, figY, figWidth, figHeight], 'Name', APP_NAME, ...
                               'Color', theme.BACKGROUND_COLOR, 'Resize', 'off');
            obj.currentUI = MainMenu(obj.fig, obj.controller);
        end
        
        % Displays the main menu by clearing the current UI and loading a new one
        function showMainMenu(obj)
            if ~isempty(obj.currentUI)
                delete(obj.currentUI);
            end
            
            obj.currentUI = MainMenu(obj.fig, obj.controller);
        end
    end
end
