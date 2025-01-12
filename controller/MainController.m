% /controller/MainController.m

classdef MainController < handle
    properties 
        status
        mainWindow
        currentPatient
    end
    
    methods

        % Starts the main application
        function obj = MainController()
            obj.status = 0;
            obj.mainWindow = MainWindow(obj);
            % disp(['Status dopo MainWindow: ', num2str(obj.status)]);
            disp('Run...');
        end

        % Create a new patient file (MAT file)
        function createNewPatientFile(obj, filePath)            
            [~, fileName, ~] = fileparts(filePath);
            patientData.filePath = filePath;
            patientData.id = fileName;
            patientData.creationDate = datetime('now');
            
            try
                save(filePath, 'patientData');
                obj.currentPatient = PatientData(filePath, fileName, patientData.creationDate);
            catch
                disp('Error: Unable to create the .mat file.');
            end
        end
        
        % Save Patient and Data
        function saveCurrentPatient(obj, name, surname, dob, notes)
            obj.currentPatient.name = name;
            obj.currentPatient.surname = surname;
            obj.currentPatient.dateOfBirth = dob;
        
            if ~isempty(notes)
                disp(['notes: ', notes]);
                obj.currentPatient = obj.currentPatient.addNotes(notes);
            end
            
            obj.currentPatient.save();
        end

   
        % Add a new note to the current patient
        function obj = addNoteToPatient(obj, noteText)
            if isempty(obj.currentPatient)
                error('No patient to add notes to');
            end
            obj.currentPatient = obj.currentPatient.addNote(noteText);
            disp('Note added to patient history');
        end
    end
end
