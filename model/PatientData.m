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
        currentNotes
    end
    
    methods
        % Constructor
        function obj = PatientData(fullPath, fileName, creationDate)
            obj.filePath = fullPath;
            obj.id = fileName;
            obj.creationDate = creationDate;
            obj.history = [];
        end

        % Update current note
        function obj = updateNotes(obj, noteText)
            currentDate = datetime('now', 'Format', 'yyyy-MM-dd');  
            currentDate = dateshift(currentDate, 'start', 'day');  
            
            obj.currentNotes.date = currentDate;
            obj.currentNotes.text = noteText;
        end

        % Save method for preparing the data
        function patientData = save(obj)
            if isempty(strtrim(obj.history(end).text))
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
        function [prevHistory, currHistory, sub] = getSplitHistory(obj, numDashes)
            if nargin < 2
                numDashes = 50;
            end
            
            prevHistory = '';
            currHistory = '';
            
            for i = 1:length(obj.history)
                noteDate = dateshift(obj.history(i).date, 'start', 'day');
                noteText = strjoin(obj.history(i).text, '\n');

                noteDateStr = string(noteDate, 'dd-MM-yyyy');
                dashes = repmat('-', 1, numDashes);

                prevHistory = sprintf('%s%s %s %s\n%s\n\n', prevHistory, dashes, noteDateStr, dashes, noteText);
            end

            sub = false;

            if ~isempty(strtrim(obj.currentNotes.text)) && ~all(cellfun('isempty', obj.currentNotes.text))
                noteDateStr = string(obj.currentNotes.date, 'dd-MM-yyyy');
                noteText = strjoin(obj.currentNotes.text, '\n');

                sub = true;
                
                dashes = repmat('-', 1, numDashes);
                prevHistory = sprintf('%s%s %s %s\n%s\n\n', prevHistory, dashes, noteDateStr, dashes, noteText);
            end
            
            obj.currentNotes.text = '';

        end
    end
end
