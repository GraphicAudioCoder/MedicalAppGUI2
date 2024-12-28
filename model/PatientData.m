% /model/PatientData.m

classdef PatientData
    properties
        patientID
        patientName
        medicalHistory
    end

    methods
        function obj = PatientData(patientID, patientName, medicalHistory)
            obj.patientID = patientID;
            obj.patientName = patientName;
            obj.medicalHistory = medicalHistory;
        end

        function displayPatientInfo(obj)
            disp(['ID: ', obj.patientID, ' Name: ', obj.patientName]);
        end
    end
end