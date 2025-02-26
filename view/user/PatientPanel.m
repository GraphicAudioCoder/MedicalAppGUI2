% /view/user/PatientPanel.m

classdef PatientPanel < handle
    properties
        mainWindow
        controller
        components
        errorMessageLabel
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
                'Position', [USER_PANEL_X_START, 500, 1060 - USER_PANEL_X_START, 150], ...
                'BackgroundColor', theme.USER_PANEL_COLOR);

            % New Patient Button
            newIconPath = fullfile(fileparts(mfilename('fullpath')), ['..', filesep, '..', filesep, 'assets', filesep, 'icons', filesep, 'add.png']);
            obj.components('newBtn') = uibutton(mainWindow, ...
                'Position', [USER_PANEL_X_START + 20, 560, 70, 70], ...
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
            openIconPath = fullfile(fileparts(mfilename('fullpath')), ['..', filesep, '..', filesep, 'assets', filesep, 'icons', filesep, 'folder.png']);
            obj.components('openBtn') = uibutton(mainWindow, ...
                'Position', [USER_PANEL_X_START + 110, 560, 70, 70], ...
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
                'Position', [textFieldOffsetX - 20, fieldOffsetY, 150, 30], ...
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
                'Position', [textFieldOffsetX - 20, fieldOffsetY - 40, 150, 30], ...
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
                'Position', [textFieldOffsetX - 20, fieldOffsetY - 80, 150, 30], ...
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

            % Previous History Panel
            obj.components('prevHistoryPanel') = uipanel(mainWindow, ...
                'Position', [USER_PANEL_X_START, 340, 1060 - USER_PANEL_X_START, 150], ...
                'BackgroundColor', theme.USER_PREVIOUS_HISTORY_PANEL_COLOR);

            % Previous History Label
            obj.components('prevHistoryLabel') = uilabel(obj.components('prevHistoryPanel'), ...
                'Position', [10, 115, 300, 30], ...
                'Text', 'Previous Clinical History:', ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontColor', theme.USER_LABEL_COLOR);
            
            % Non-editable Text Area for Previous History
            obj.components('prevHistoryArea') = uitextarea(obj.components('prevHistoryPanel'), ...
                'Position', [10, 10, 1040 - USER_PANEL_X_START, 100], ...
                'FontSize', HISTORY_FONT_SIZE, ...
                'FontName', HISTORY_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE, ...
                'Editable', 'off');

            % New Notes Panel
            obj.components('newNotesPanel') = uipanel(mainWindow, ...
                'Position', [USER_PANEL_X_START, 130, 1060 - USER_PANEL_X_START, 200], ...
                'BackgroundColor', theme.USER_PANEL_COLOR);
            
            % New Notes Label
            obj.components('newNotesLabel') = uilabel(obj.components('newNotesPanel'), ...
                'Position', [10, 165, 500, 30], ...
                'Text', 'Notes: ', ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'HorizontalAlignment', 'left', ...
                'FontColor', theme.USER_LABEL_COLOR);
            
            % Editable Text Area for New Notes
            obj.components('newNotesArea') = uitextarea(obj.components('newNotesPanel'), ...
                'Position', [10, 10, 1040 - USER_PANEL_X_START, 150], ...
                'FontSize', HISTORY_FONT_SIZE, ...
                'FontName', HISTORY_FONT, ...
                'FontColor', theme.USER_LABEL_COLOR, ...
                'BackgroundColor', theme.USER_GUI_ELEM_COLOR_ONE, ...
                'Editable', 'on');

            % Save Button
            obj.components('saveBtn') = uibutton(mainWindow, ...
                'Position', [USER_PANEL_X_START + 240, 70, 260, 50], ...
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
            NamesFonts;
            
            nameField = obj.components('nameField');
            surnameField = obj.components('surnameField');
            dobField = obj.components('dobField');
            notes = obj.components('newNotesArea');
        
            nameValue = strtrim(nameField.Value);
            surnameValue = strtrim(surnameField.Value);
            notesValue = notes.Value;
            
            lang = LanguageManager('get');
            
            if isempty(nameValue) || isempty(surnameValue)
                if isempty(nameValue) && isempty(surnameValue)
                    msgText = lang.MISSING_NAME_SURNAME;
                elseif isempty(nameValue)
                    msgText = lang.MISSING_NAME;
                else
                    msgText = lang.MISSING_SURNAME;
                end
                
                msgColor = [0.9, 0, 0];
                
                % Delete previous error message if it exists
                if ~isempty(obj.errorMessageLabel) && isvalid(obj.errorMessageLabel)
                    delete(obj.errorMessageLabel);
                end
                
                obj.errorMessageLabel = uilabel(obj.mainWindow, ...
                    'Position', [USER_PANEL_X_START + 175, 40, 400, 30], ...
                    'Text', msgText, ...
                    'FontSize', NEXT_BTN_FONT_SIZE, ...
                    'FontName', MAIN_FONT, ...
                    'HorizontalAlignment', 'center', ...
                    'FontColor', msgColor);

                pause(3);
                delete(obj.errorMessageLabel);
                return;
            end

            dobValue = datestr(dobField.Value, 'yyyymmdd');
        
            obj.controller.createNewPatient(nameValue, surnameValue, dobValue, notesValue);
        end


        % Open a File dialog to select an existing file
        function onOpenButtonPushed(obj)

            defaultPath = fullfile(pwd, 'patients');
   
            if ~isfolder(defaultPath)
                defaultPath = pwd;
            end
            
            [fileName, pathName] = uigetfile({'*.mat', 'MATLAB Files (*.mat)'}, ...
                'Existing Patient', defaultPath);

            if fileName ~= 0
                fullPath = fullfile(pathName, fileName);
                [name, surname, dob, prevHistory, currHistory] = obj.controller.openExistingPatientFile(fullPath);
                
                nameField = obj.components('nameField');
                surnameField = obj.components('surnameField');
                dobField = obj.components('dobField');
                notesField = obj.components('newNotesArea');
                prevNotes = obj.components('prevHistoryArea');
                
                nameField.Value = name;
                surnameField.Value = surname;
                dobField.Value = datetime(dob, 'InputFormat', 'yyyyMMdd');
                notesField.Value = currHistory;
                prevNotes.Value = prevHistory;
            end
        end

        % Save Patient and Data listener
        function onSaveButtonPushed(obj)
            NamesFonts;

            name = obj.components('nameField').Value;
            surname = obj.components('surnameField').Value;
            dob = obj.components('dobField').Value;
            notes = obj.components('newNotesArea').Value;

            success = obj.controller.saveCurrentPatient(name, surname, dob, notes);
    
            lang = LanguageManager('get');
            
            if success
                msgText = lang.DATA_SAVED_SUCCESSFULLY;
                msgColor = [0, 0.5, 0];
            else
                msgText = lang.NONEXISTENT_PATIENT;
                msgColor = [0.9, 0, 0];
            end

            % Delete previous error message if it exists
            if ~isempty(obj.errorMessageLabel) && isvalid(obj.errorMessageLabel)
                delete(obj.errorMessageLabel);
            end

            obj.errorMessageLabel = uilabel(obj.mainWindow, ...
                'Position', [520, 40, 280, 30], ...
                'Text', msgText, ...
                'FontSize', NEXT_BTN_FONT_SIZE, ...
                'FontName', MAIN_FONT, ...
                'HorizontalAlignment', 'center', ...
                'FontColor', msgColor);

            pause(3);
            delete(obj.errorMessageLabel);
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
            prevHistoryPanel.BackgroundColor = currentColors.USER_PREVIOUS_HISTORY_PANEL_COLOR;
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

        function randomValue = generateUniqueRandom(obj)
            randomValue = randi([0, 99]);
        end

        function onRightClick(obj, src, event)
        end

        function updateLanguageUI(obj, lang)
            nameLabel = obj.components('nameLabel');
            nameLabel.Text = lang.NAME_LABEL;
            surnameLabel = obj.components('surnameLabel');
            surnameLabel.Text = lang.SURNAME_LABEL;
            dobLabel = obj.components('dobLabel');
            dobLabel.Text = lang.BIRTHDAY_LABEL;
            prevHistoryLabel = obj.components('prevHistoryLabel');
            prevHistoryLabel.Text = lang.PREVIOUS_CLINICAL_HISTORY_LABEL;
            newNotesLabel = obj.components('newNotesLabel');
            newNotesLabel.Text = lang.NOTES_LABEL;
            saveBtn = obj.components('saveBtn');
            saveBtn.Text = lang.SAVE_PATIENT_AND_DATA_LABEL;
            newBtn = obj.components('newBtn');
            newBtn.Text = lang.NEW_LABEL;
            openBtn = obj.components('openBtn');
            openBtn.Text = lang.OPEN_LABEL;
        end
    end
end
