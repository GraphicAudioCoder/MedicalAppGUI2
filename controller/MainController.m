% /controller/MainController.m

% Main controller
classdef MainController
    properties
        mainWindow
    end
    
    methods
        function obj = MainController()
        end
        
        % Starts the main application
        function obj = run(obj)
            obj.mainWindow = MainWindow(obj);
            disp('Run...');
        end
    end
end
