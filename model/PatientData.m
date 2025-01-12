% /model/PatientData.m

classdef PatientData
    properties
        filePath
        id
        name
        surname
        dateOfBirth
        creationDate
        history
    end
    
    methods

        function obj = PatientData(fullPath, fileName, creationDate)
            obj.filePath = fullPath;
            obj.id = fileName;
            obj.creationDate = creationDate;
        end

        % Add a new note to the patient's history
        function obj = addNotes(obj, noteText)
            currentDate = datetime('now', 'Format', 'yyyy-MM-dd');
            
            noteUpdated = false;
            for i = 1:length(obj.history)
                if isequal(obj.history{i}.date, currentDate)
                    obj.history{i}.text = noteText;
                    noteUpdated = true;
                    break;
                end
            end
            
            if ~noteUpdated
                newNote.date = currentDate;
                newNote.text = noteText;
                obj.history = {newNote}; 
            end
        end

        % Save method for saving the data
        function save(obj)
            patientData.filePath = obj.filePath;
            patientData.id = obj.id;
            patientData.name = obj.name;
            patientData.surname = obj.surname;
            patientData.dateOfBirth = obj.dateOfBirth;
            patientData.creationDate = obj.creationDate;
            patientData.history = obj.history;
            try
                save(obj.filePath, 'patientData');
                disp(['Data saved to: ', obj.filePath]);
            catch
                disp('Error: Unable to save the patient data.');
            end
        end
    end
end
