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
        % Costruttore
        function obj = PatientData(fullPath, fileName, creationDate, newNote)
            obj.filePath = fullPath;
            obj.id = fileName;
            obj.creationDate = creationDate;
            obj.history = [];
            if newNote
                obj = obj.addNotes('');
            end
        end

        % Add a new note to the patient's history
        function obj = addNotes(obj, noteText)
            currentDate = datetime('now', 'Format', 'yyyy-MM-dd');  
            currentDate = dateshift(currentDate, 'start', 'day');  

            newNote.date = currentDate;
            newNote.text = noteText;
            obj.history = [obj.history, newNote];
        end

        % Update last note to the patient's history
        function obj = updateNotes(obj, noteText)
            currentDate = datetime('now', 'Format', 'yyyy-MM-dd');  
            currentDate = dateshift(currentDate, 'start', 'day');  
            
            if ~isempty(obj.history)
                obj.history(end).date = currentDate;
                obj.history(end).text = noteText;
            else
                newNote.date = currentDate;
                newNote.text = noteText;
                obj.history = [obj.history, newNote];
            end
        end

        % Save method for preparing the data
        function patientData = save(obj)
            lastText = obj.history(end).text; 
            disp(['Tipo di text: ', class(lastText)]);
            disp(['Dimensione di text: ', num2str(size(lastText))]);
            disp(['Valore di text: ', cell2mat(lastText)]);

            if isempty(cell2mat(lastText))
                obj.history(end) = [];
            end

            patientData.filePath = obj.filePath;
            patientData.id = obj.id;
            patientData.name = obj.name;
            patientData.surname = obj.surname;
            patientData.dateOfBirth = obj.dateOfBirth;
            patientData.creationDate = obj.creationDate;
            patientData.history = obj.history;
        end

        % Get today's note
        function noteText = getTodayNote(obj)
            currentDate = datetime('now', 'Format', 'yyyy-MM-dd');
            
            noteText = '';
            for i = 1:length(obj.history)
                if isequal(obj.history{i}.date, currentDate)
                    noteText = obj.history{i}.text;
                    return;
                end
            end
        end

        % Get today's note and previous notes
        function [prevHistory, currHistory] = getSplitHistory(obj)
            prevHistory = '';
            currHistory = '';
            
            for i = 1:length(obj.history)
                noteDate = dateshift(obj.history(i).date, 'start', 'day');
                noteText = obj.history(i).text{1};
                noteDateStr = string(noteDate, 'dd-MM-yyyy');

                prevHistory = sprintf('%s%s:\n"%s"\n', prevHistory, noteDateStr, noteText);
            end
        end
    end
end
