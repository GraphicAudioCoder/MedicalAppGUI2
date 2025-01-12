% /view/user/PatientPanel.m

classdef PatientPanel < handle
    properties
        mainWindow
        controller
        components
    end
    
    methods
        function obj = PatientPanel(mainWindow, controller)
            NamesFonts;
            theme = ThemeManager();
            
            obj.components = containers.Map();
            obj.mainWindow = mainWindow;
            obj.controller = controller;

            % Registry Panel
            obj.components('registryPanel') = uipanel(mainWindow, ...
                'Position', [240, 500, 820, 150], ...
                'BackgroundColor', theme.USER_PANEL_COLOR);

            % New Patient Button
            newIconPath = fullfile(fileparts(mfilename('fullpath')), '../../assets/icons/add.png');
            obj.components('newBtn') = uibutton(mainWindow, ...
                'Position', [260, 560, 70, 70], ...
                'Text', 'New', ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'FontName', MAIN_FONT, ...
                'FontWeight', 'bold', ...
                'Icon', newIconPath, ...
                'IconAlignment', 'top', ...
                'ButtonPushedFcn', @(btn, event)obj.onAddButtonPushed());

            % Open Existing Patient Button
            openIconPath = fullfile(fileparts(mfilename('fullpath')), '../../assets/icons/folder.png');
            obj.components('openBtn') = uibutton(mainWindow, ...
                'Position', [350, 560, 70, 70], ...
                'Text', 'Open', ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'FontWeight', 'bold', ...
                'FontName', MAIN_FONT, ...
                'Icon', openIconPath, ...
                'IconAlignment', 'top', ...
                'ButtonPushedFcn', @(btn, event)obj.onOpenButtonPushed());

            textFieldOffsetX = 700;
            fieldOffsetY = 600;

            % Name Label and Text Field
            obj.components('nameLabel') = uilabel(mainWindow, ...
                'Position', [textFieldOffsetX, fieldOffsetY, 100, 30], ...
                'Text', 'Name:', ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontColor', theme.USER_LABEL_COLOR);

            obj.components('nameField') = uieditfield(mainWindow, 'text', ...
                'Position', [textFieldOffsetX + 120, fieldOffsetY, 220, 30], ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'FontName', MAIN_FONT, ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE);

            % Surname Label and Text Field
            obj.components('surnameLabel') = uilabel(mainWindow, ...
                'Position', [textFieldOffsetX, fieldOffsetY - 40, 100, 30], ...
                'Text', 'Surname:', ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontColor', theme.USER_LABEL_COLOR);

            obj.components('surnameField') = uieditfield(mainWindow, 'text', ...
                'Position', [textFieldOffsetX + 120, fieldOffsetY - 40, 220, 30], ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE);

            % Date of Birth Label and Date Picker
            obj.components('dobLabel') = uilabel(mainWindow, ...
                'Position', [textFieldOffsetX, fieldOffsetY - 80, 100, 30], ...
                'Text', 'Birthday:', ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontColor', theme.USER_LABEL_COLOR);
            
            obj.components('dobField') = uidatepicker(mainWindow, ...
                'Position', [textFieldOffsetX + 120, fieldOffsetY - 80, 220, 30], ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'DisplayFormat','dd/MM/yyyy', ...
                'Value',datetime(1990,1,1), ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE);

            % Registry Panel
            obj.components('prevHistoryPanel') = uipanel(mainWindow, ...
                'Position', [240, 340, 820, 150], ...
                'BackgroundColor', theme.USER_PANEL_COLOR);

            % Previous History Label
            obj.components('prevHistoryLabel') = uilabel(obj.components('prevHistoryPanel'), ...
                'Position', [10, 115, 300, 30], ...
                'Text', 'Clinical History', ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontColor', theme.USER_LABEL_COLOR);
            
            % Non-editable Text Area for Previous History
            obj.components('prevHistoryArea') = uitextarea(obj.components('prevHistoryPanel'), ...
                'Position', [10, 10, 800, 100], ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE, ...
                'Editable', 'off');

            % New Notes Panel
            obj.components('newNotesPanel') = uipanel(mainWindow, ...
                'Position', [240, 130, 820, 200], ...
                'BackgroundColor', theme.USER_PANEL_COLOR);
            
            % New Notes Label
            obj.components('newNotesLabel') = uilabel(obj.components('newNotesPanel'), ...
                'Position', [10, 165, 500, 30], ...
                'Text', 'Add New Notes for Today (will overwrite if exists)', ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontColor', theme.USER_LABEL_COLOR);
            
            % Editable Text Area for New Notes
            obj.components('newNotesArea') = uitextarea(obj.components('newNotesPanel'), ...
                'Position', [10, 10, 800, 150], ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE, ...
                'Editable', 'on');

            % Save Button
            obj.components('saveBtn') = uibutton(mainWindow, ...
                'Position', [480, 70, 260, 50], ...
                'Text', 'Save patient and data', ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'BackgroundColor', theme.USER_PANEL_COLOR, ...
                'FontWeight', 'bold', ...
                'ButtonPushedFcn', @(btn, event)obj.onSaveButtonPushed());
        end

        % Add New Patient listener
        function onAddButtonPushed(obj)

            % Open a Save dialog to create a new file
            [fileName, pathName] = uiputfile({'*.mat', 'MATLAB Files (*.mat)'}, ...
                'New Patient');
            
            if fileName ~= 0
                fullPath = fullfile(pathName, fileName);
                obj.controller.createNewPatientFile(fullPath);
            else
                disp('Patient creation canceled.');
            end
        end

        % Open a File dialog to select an existing file
        function onOpenButtonPushed(obj)
            [fileName, pathName] = uigetfile({...
                '*.m', 'MATLAB Files (*.m)'; ...
                '*.xlsx', 'Excel Files (*.xlsx)'; ...
                '*.*', 'All Files (*.*)'}, ...
                'Existing Patient');
            if fileName ~= 0
                fullPath = fullfile(pathName, fileName);
                disp(['File selected: ', fullPath]);
            end
        end

        % Save Patient and Data listener
        function onSaveButtonPushed(obj)
            NamesFonts;

            name = obj.components('nameField').Value;
            surname = obj.components('surnameField').Value;
            dob = obj.components('dobField').Value;
            notes = obj.components('newNotesArea').Value;

            obj.controller.saveCurrentPatient(name, surname, dob, notes);

            % % Temp label
            % saveMessage = uilabel(obj.mainWindow, ...
            %     'Position', [470, 40, 280, 30], ...
            %     'Text', 'Data saved successfully!', ...
            %     'FontSize', NEXT_BTN_FONT_SIZE, ...
            %     'FontName', MAIN_FONT, ...
            %     'HorizontalAlignment', 'center', ...
            %     'FontColor', [0, 0.5, 0]);
            % 
            % pause(3);
            % delete(saveMessage);
        end
        
        % Sets the visibility of all components
        function setVisibility(obj, visibility)
            keys = obj.components.keys;
            for i = 1:length(keys)
                componentName = keys{i};
                component = obj.components(componentName);
                if visibility
                    component.Visible = 'on';
                else
                    component.Visible = 'off';
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

        % Change theme
        function changeColors(obj, currentColors)
            registryPanel = obj.components('registryPanel');
            registryPanel.BackgroundColor = currentColors.USER_PANEL_COLOR;
            prevHistoryPanel = obj.components('prevHistoryPanel');
            prevHistoryPanel.BackgroundColor = currentColors.USER_PANEL_COLOR;
            newBtn = obj.components('newBtn');
            newBtn.BackgroundColor = currentColors.USER_GUI_ELEM_COLOR_ONE;
            newBtn.FontColor = currentColors.USER_LABEL_COLOR;
            openBtn = obj.components('openBtn');
            openBtn.BackgroundColor = currentColors.USER_GUI_ELEM_COLOR_ONE;
            openBtn.FontColor = currentColors.USER_LABEL_COLOR;
            nameLabel = obj.components('nameLabel');
            nameLabel.FontColor = currentColors.USER_LABEL_COLOR;
            nameField = obj.components('nameField');
            nameField.FontColor = currentColors.USER_LABEL_COLOR;
            nameField.BackgroundColor = currentColors.USER_GUI_ELEM_COLOR_ONE;
            surnameLabel = obj.components('surnameLabel');
            surnameLabel.FontColor = currentColors.USER_LABEL_COLOR;
            surnameField = obj.components('surnameField');
            surnameField.FontColor = currentColors.USER_LABEL_COLOR;
            surnameField.BackgroundColor = currentColors.USER_GUI_ELEM_COLOR_ONE;
            dobLabel = obj.components('dobLabel');
            dobLabel.FontColor = currentColors.USER_LABEL_COLOR;
            dobField = obj.components('dobField');
            dobField.FontColor = currentColors.USER_LABEL_COLOR;
            dobField.BackgroundColor = currentColors.USER_GUI_ELEM_COLOR_ONE;
            prevHistoryLabel = obj.components('prevHistoryLabel');
            prevHistoryLabel.FontColor = currentColors.USER_LABEL_COLOR;
            prevHistoryArea = obj.components('prevHistoryArea');
            prevHistoryArea.FontColor = currentColors.USER_LABEL_COLOR;
            prevHistoryArea.BackgroundColor = currentColors.USER_GUI_ELEM_COLOR_ONE;
            newNotesPanel = obj.components('newNotesPanel');
            newNotesPanel.BackgroundColor = currentColors.USER_PANEL_COLOR;
            newNotesLabel = obj.components('newNotesLabel');
            newNotesLabel.FontColor = currentColors.USER_LABEL_COLOR;
            newNotesArea = obj.components('newNotesArea');
            newNotesArea.FontColor = currentColors.USER_LABEL_COLOR;
            newNotesArea.BackgroundColor = currentColors.USER_GUI_ELEM_COLOR_ONE;
            saveButton = obj.components('saveBtn');
            saveButton.BackgroundColor = currentColors.USER_PANEL_COLOR;
            saveButton.FontColor = currentColors.USER_LABEL_COLOR;
        end
    end
end
