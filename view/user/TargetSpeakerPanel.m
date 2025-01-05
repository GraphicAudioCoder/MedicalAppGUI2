% /view/user/TargetSpeakerPanel.m

classdef TargetSpeakerPanel < handle
    properties
        mainWindow
        panel
        label
        componentsVisibility
    end
    
    methods
        function obj = TargetSpeakerPanel(mainWindow)
            obj.mainWindow = mainWindow;
            obj.componentsVisibility = containers.Map();
           
            obj.label = uilabel(mainWindow, ...
                'Text', 'Welcome to the Target Speaker Panel', ...
                'FontSize', 20, ...
                'FontWeight', 'bold', ...
                'HorizontalAlignment', 'center', ...
                'Position', [150, 200, 840, 50]);
            
            % Store initial visibility status of components
            obj.componentsVisibility('panel') = true;
            obj.componentsVisibility('label') = true;
        end
        
        % Hide or show all components
        function setVisibility(obj, visibility)
            if visibility
                % Show all components
                obj.panel.Visible = 'on';
                obj.label.Visible = 'on';
                obj.componentsVisibility('panel') = true;
                obj.componentsVisibility('label') = true;
            else
                % Hide all components
                obj.panel.Visible = 'off';
                obj.label.Visible = 'off';
                obj.componentsVisibility('panel') = false;
                obj.componentsVisibility('label') = false;
            end
        end
        
        % Show a specific component
        function showComponent(obj, componentName)
            if isKey(obj.componentsVisibility, componentName)
                switch componentName
                    case 'panel'
                        obj.panel.Visible = 'on';
                    case 'label'
                        obj.label.Visible = 'on';
                end
                obj.componentsVisibility(componentName) = true;
            end
        end
        
        % Hide a specific component
        function hideComponent(obj, componentName)
            if isKey(obj.componentsVisibility, componentName)
                switch componentName
                    case 'panel'
                        obj.panel.Visible = 'off';
                    case 'label'
                        obj.label.Visible = 'off';
                end
                obj.componentsVisibility(componentName) = false;
            end
        end
    end
end
