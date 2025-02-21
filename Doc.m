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
1) Aprire la cartella "MedicalAppGUI" in VSCode.
2) Avviare il comando "pathtool" dal terminale (nella cartella di progetto).
3) Aggiungere la cartella "MedicalAppGUI" e le sue sottocartelle al path di MATLAB.
4) Aprire "Runner.m".
5) Premere "Run" su VSCode.

STRUTTURA DEL PROGETTO

- Doc.m: File corrente, contenente la documentazione.
- Runner.m: File di avvio principale dell'applicazione.
- view: Contiene le classi per la vista dell'applicazione.
  - MainWindow.m: Classe principale per la finestra dell'applicazione.
  - MainMenu.m: Classe per il menu principale.
  - user: Contiene le classi per la vista utente.
    - ListenerPanel.m: Pannello per la selezione dei listener.
    - EnvironmentPanel.m: Pannello per la selezione dell'ambiente.
- model: Contiene le classi del modello, che gestiscono i dati dell'applicazione.
- controller: Contiene le classi del controller, che gestiscono la logica dell'applicazione.
- constants: Contiene le costanti di progetto.
- themes: Contiene i codici necessari per gestire i due temi dell'applicazione, uno scuro e l'altro chiaro.
- assets: Contiene i file PNG utilizzati nella vista dell'applicazione.
- resources: Contiene i file necessari per avviare qualunque progetto MATLAB.
- patients: Contiene i file .mat dei pazienti, che memorizzano i dati del paziente.
- scenes: Contiene le scene disponibili nell'applicazione.
- languages: Contiene i file per la gestione delle lingue dell'applicazione.
  - LanguageManager.m: Gestisce la lingua corrente dell'applicazione.
  - EnglishLang.m: File di lingua inglese.
  - ItalianLang.m: File di lingua italiana.

%}