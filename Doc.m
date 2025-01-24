%{

Documentazione del Progetto MATLAB: 
Applicazione per Test Clinici Uditivi

Questa applicazione MATLAB, strutturata secondo il pattern MVC 
(Model-View-Controller), è stata progettata per eseguire 
test clinici uditivi. 
La GUI fornisce un ambiente intuitivo per l'esecuzione dei test 
e la visualizzazione dei risultati.

AVVIO DA MATLAB

1) Aprire "MedicalAppGUI.prj".
2) Aprire "Runner.m".
3) Premere "Run" nell'IDE di MATLAB.

AVVIO DA VSCODE

1) Avviare il comando "pathtool"
2) Aggiungere la cartella "MedicalAppGUI" e le sue sottocartelle al path di MATLAB.
3) Aprire "Runner.m".
4) Premere "Run" su VSCode.

STRUTTURA DEL PROGETTO

- Doc.m: File corrente, contenente la documentazione.
- Runner.m: File di avvio principale dell'applicazione.
- view: Contiene le classi per la vista dell'applicazione.
- model: Contiene le classi del modello, che gestiscono i dati dell'applicazione.
- controller: Contiene le classi del controller, che gestiscono la logica dell'applicazione.
- constants: Contiene le costanti di progetto.
- themes: Contiene i codici necessari per gestire i due temi dell'applicazione, uno scuro e l'altro chiaro.
- assets: Contiene i file PNG utilizzati nella vista dell'applicazione.
- resources: Contiene i file necessari per avviare qualunque progetto MATLAB.
- patients: Contiene i file .mat dei pazienti, che memorizzano i dati del paziente.
- scenes: Contiene le scene disponibili nell'applicazione.

%}