% /view/MainWindow.m

classdef MainWindow
    properties
        mainFig
        patientTable
    end
    
    methods
        function obj = MainWindow()
            obj.mainFig = uifigure('Name', 'Patient Data', 'Position', [100, 100, 600, 400]);
            
            % Tabella per visualizzare i pazienti
            obj.patientTable = uitable(obj.mainFig, 'Position', [50, 150, 500, 200]);
            
            % Pulsanti, slider, altri controlli qui...
        end
        
        function updatePatientList(obj, patients)
            % Aggiorna la tabella con i dati dei pazienti
            patientData = cell(length(patients), 3);
            for i = 1:length(patients)
                patientData{i, 1} = patients(i).patientID;
                patientData{i, 2} = patients(i).patientName;
                patientData{i, 3} = patients(i).medicalHistory;
            end
            obj.patientTable.Data = patientData;
        end
    end
end
