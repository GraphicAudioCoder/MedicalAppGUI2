% /controller/MainController.m

classdef MainController
    properties
        model
        view
    end
    
    methods
        function obj = MainController()
            obj.model = []; % Inizializza il Model
            obj.view = MainWindow(); % Inizializza la View
            % Popola la View con i dati iniziali
            obj.loadPatients();
        end
        
        function loadPatients(obj)
            % Carica i dati dei pazienti dal Model e aggiorna la View
            patient1 = PatientData('001', 'Mario Rossi', 'Allergy');
            patient2 = PatientData('002', 'Giovanni Verdi', 'Cold');
            patients = [patient1, patient2]; % Lista dei pazienti
            
            % Passa i pazienti alla View per visualizzarli
            obj.view.updatePatientList(patients);
        end
        
        % Gestisci altre interazioni (ad esempio clic su un bottone)
    end
end
