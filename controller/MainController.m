% /controller/MainController.m

classdef MainController < handle
    properties 
        status
        mainWindow
        currentPatient
        currentScene

        patientPanel
        environmentPanel
        listenerPanel
        targetSpeakerPanel
        maskingNoisePanel
        testSettingsPanel
    end
    
    methods
        % Starts the main application
        function obj = MainController()
            obj.status = 0;
            obj.mainWindow = MainWindow(obj);
            disp('Run...');
        end

        % Create a new patient
        function createNewPatient(obj, name, surname, dob, notes)

            currFileName = sprintf('%s_%s_%s_%d.mat', ...
                            name, ...
                            surname, ...
                            dob, ...
                            obj.generateUniqueRandom());
        
            currFileName = strrep(currFileName, ' ', '');
        
            defaultPath = fullfile(pwd, 'patients');
                   
            if ~isfolder(defaultPath)
                defaultPath = pwd;
            end
            
            [fileName, pathName] = uiputfile({'*.mat', 'MATLAB Files (*.mat)'}, ...
            'New Patient', fullfile(defaultPath, currFileName));
                   
            if fileName ~= 0
                relativePath = fullfile('patients', fileName);
                obj.createNewPatientFile(relativePath, name, surname, dob, notes);
            end
        end

        % Create a new patient file (MAT file)
        function createNewPatientFile(obj, filePath, name, surname, dob, notes)            
            [~, fileName, ~] = fileparts(filePath);
            patientData.filePath = filePath;
            patientData.id = fileName;
            patientData.creationDate = datetime('now');
            patientData.name = name;
            patientData.surname = surname;
            patientData.dateOfBirth = dob;
            patientData.history = [];
            
            if ~isempty(strtrim(notes)) && ~all(cellfun('isempty', notes))
                currentDate = datetime('now', 'Format', 'yyyy-MM-dd');
                currentDate = dateshift(currentDate, 'start', 'day');
                newNote.date = currentDate;
                newNote.text = notes;
                patientData.currentNotes = newNote;
            end

            try
                save(filePath, 'patientData');
                obj.currentPatient = PatientData(filePath, fileName, patientData.creationDate);
            catch
                disp('Error: Unable to create the .mat file.');
            end
        end

        % Initialize history with an empty note
        function history = initializeHistory(obj)
            currentDate = datetime('now', 'Format', 'yyyy-MM-dd');
            currentDate = dateshift(currentDate, 'start', 'day');

            newNote.date = currentDate;
            newNote.text = '';
            history = newNote;
        end
        
        % Save Patient and Data
        function success = saveCurrentPatient(obj, name, surname, dob, notes)
            success = false;
            
            if ~isempty(obj.currentPatient)
                try
                    obj.currentPatient.name = name;
                    obj.currentPatient.surname = surname;
                    obj.currentPatient.dateOfBirth = dob;

                    if ~isempty(strtrim(notes)) && ~all(cellfun('isempty', notes))
                        obj.currentPatient = obj.currentPatient.updateNotes(notes);
                    elseif ~isempty(strtrim(obj.currentPatient.currentNotes.text))
                        obj.currentPatient = obj.currentPatient.updateNotes(notes);
                    end

                    % Prepare patient data for saving
                    patientData.filePath = obj.currentPatient.filePath;
                    patientData.id = obj.currentPatient.id;
                    patientData.name = obj.currentPatient.name;
                    patientData.surname = obj.currentPatient.surname;
                    patientData.dateOfBirth = obj.currentPatient.dateOfBirth;
                    patientData.creationDate = obj.currentPatient.creationDate;
                    patientData.history = obj.currentPatient.history;
                    patientData.currentNotes = obj.currentPatient.currentNotes;

                    % Save the patient data
                    try
                        save(obj.currentPatient.filePath, 'patientData');
                        success = true;
                    catch
                        disp('Error: Unable to save the patient data.');
                    end
                catch ME
                    disp(['Error while saving patient: ', ME.message]);
                end
            end
        end

        function [name, surname, dob, prevHistory, currHistory] = openExistingPatientFile(obj, filePath)
            try
                fileData = load(filePath);
                patientData = fileData.patientData;
                obj.currentPatient = PatientData(filePath, patientData.id, patientData.creationDate);
                obj.currentPatient.name = patientData.name;
                obj.currentPatient.surname = patientData.surname;
                obj.currentPatient.dateOfBirth = patientData.dateOfBirth;
                obj.currentPatient.history = patientData.history;
                obj.currentPatient.currentNotes = patientData.currentNotes;

                [prevHistory, currHistory, sub] = obj.currentPatient.getSplitHistory();

                if sub
                    obj.currentPatient.history = [obj.currentPatient.history, obj.currentPatient.currentNotes];
                    obj.currentPatient.currentNotes.text = '';
                end
                
                obj.saveCurrentPatient(obj.currentPatient.name, ...
                                       obj.currentPatient.surname, ...
                                       obj.currentPatient.dateOfBirth, ...
                                        {''});

                name = obj.currentPatient.name;
                surname = obj.currentPatient.surname;
                dob = obj.currentPatient.dateOfBirth;
            catch
                disp('Error: Unable to open the .mat file.');
            end
        end

        % Reads all scenes
        function [numScenes, sceneNames, fileNames] = readAllScenes(obj)            
            scenesPath = fullfile(fileparts(mfilename('fullpath')), '../scenes');
            sceneDirs = dir(scenesPath);
            sceneDirs = sceneDirs([sceneDirs.isdir] & ~ismember({sceneDirs.name}, {'.', '..'}));
            numScenes = numel(sceneDirs);
            sceneNames = cell(1, numScenes);
            fileNames = cell(1, numScenes);
            
            for i = 1:numScenes
                sceneName = sceneDirs(i).name;
                sceneNames{i} = strrep(sceneName, '_', ' ');
                sceneNames{i} = regexprep(sceneNames{i}, '(^.)', '${upper($1)}');
                fileNames{i} = sceneName;
            end
        end

        % Listener callback for the "Select" buttons
        function onSelectSceneButtonPushed(obj, panelIndex)
            [~, sceneNames, fileNames] = obj.readAllScenes();

            if panelIndex <= numel(sceneNames)
                obj.currentScene = SceneData(fileNames{panelIndex}, sceneNames{panelIndex});
                sceneData = load(fullfile(obj.currentScene.scenePath, [fileNames{panelIndex}, '.mat']));
                obj.currentScene.listenerPositions = sceneData.listenerPositions;
            end
        end

        function onSelectListenerButtonPushed(obj, panelIndex)
            obj.currentScene = obj.currentScene.setListenerNum(panelIndex);
        end

        function onSelectTargetButtonPushed(obj, panelIndex)
            obj.currentScene = obj.currentScene.setSelectedTarget(panelIndex);
        end

        % Generate a unique random number
        function randomValue = generateUniqueRandom(obj)
            randomValue = randi([0, 99]);
        end    
    end
end
