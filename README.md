# rihla

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Palier2: Questions de compréhension 

Q1: Si on supprime le expanded, Flutter declenche une erreur, c'est une erreur de disposition.
Sans expanded, la Column essaie de s'étaler à l'infini et pousse l'avatar complètement hors de l'écran ce qui declenche un erreur.

Q2: le prenom est final car un StatelessWidget doivent initialisées toutes ses propriétés une seule fois et ne peuvent plus changer après la construction du widget.

Q3: cs.primary est dynamique, il s'adapte automatiquement et génère la couleur principale en fonction de la seedColor définie dans le thème de l'application. 
Si on change la seedColor, cs.primary changera de couleur. 
Par contre, Colors.teal est une couleur statique codée en dur : elle restera toujours teal, peu importe les modifications apportées au thème global.