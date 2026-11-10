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


Palier 3: Questions de compréhension
Q4: l'image devient plus clair et on ne vois plus le dégradé car l'image est placée par-dessus, alors il est masqué complétement. car le premier élement est au fond et le dernier s'affiche au premier.

Q5: la banniere perd ses coins arrondis et l'image rectangulaire dépasse les angles du conteneur.

Q6: le Positioned des textes a right: 130 pour laisser une espace pour le bouton, car avec right: 130 on bloque le largeur du texte un peu avant la fin pour éviter que le text se superpose au button.

Palier 4: Questions de compréhension
Q7: le spacer a besoin d'une limite claire pour savoir quel espace prendre. Sans Expanded, la column a une largeur infinie et le Spacer est perdu. l'expanded lui sert de cadre précis.

Q8: Pour une 7eme destination on ne dois pas ajouter des lignes de code, en ajoute simplement les données de la destination dans le fichier destinations.dart, la boucle affiche s'adapte et affiche tout les données.
exemple : (
    Destination(
    nom: 'Bizerte',
    region: 'Bizerte',
    categorie: 'Plage',
    image: 'assets/images/Bizerte.png',
    note: 5,
    prix: 360,
    duree: '2 jours',
    description:
        'Médina fortifiée au bord de la mer, jardins de jasmin et longues '
        'plages : la station balnéaire historique du Cap Blanc.',
  ),
)



Palier 5: Questions de compréhension
Q9: En mémoire la variable _categorie change bien et enregistre la nouvelle catégorie sur laquelle j'ai cliquée.
par contre à l'écran Rien ne change du tout, la liste ne se filtre pas car sans setState, Flutter ne sait pas qu'il doit redessiner l'écran pour montrer la modification

Q10: _filtrees a un getter recalculé à chaque build(), parce que la liste des destinations doit changer à chaque fois que je clique sur une nouvelle catégorie. Getter vérifie automatiquement la catégorie active à chaque actualisation de l'écran.

Q11: Parce que le HeroBanner n'a pas besoin de retenir des informations ou de changer tout seul. Il affiche ce qu'on lui donne (image et titre), alors que HomeScreen qui gére le changement d'état et lui transmet les données.



TP4 Question de Comprehension :
Palier 2 :
Q1 : je fais le test et oui, le filtre est conservé. Chaque fois on utilise la fonction pour passer au detail_screen (Push) notre ecran d'acceuil (home_screen) est simplement masqué et placé en dessous du nouvel écran dans la pile de navigation, il n'est pas détruit. Lorsque en utilise Navigator.pop pour revenir en arriere on dépile le Detail_screen et on retrouve l'état exact de home_screen tel qu'il était.

Q2 : Le DetailScreen recoit la destination par son constructeur paramétré (required this.destination), on utilise le mécanisme de transmission d'objets par paraméte (le Constucteur typé) du TP3

Q3 : lorsque je retire le clipBehavior (clipBehavior: Clip.antiAlias), il dépasse les coins arrondis de la carte lors du clic, qui crée des carrés aux coins de la carte au lieu de respecter l'arrondi de 20px 

Palier 3 :
Q1 : _formKey.currentState!.validate() , parcourt l'ensemble des champs du formulaire rattachés à cette clé et exécute leur fonction validaator. Elle renvoie true si tous les validateurs retournent null (succés), ou false dès qu'au moins un validateur retourne un message d'erreur.

Q2 : inputFormatters agit en temps réel agit en intervenir préventivement et en temps réel pendant la frappe, ainsi que validator agit au moment de la soumission (_valider()) pour vérifier si la valeur finale respecte les règles métier

Q3 : il faut appeler dispose() sur les controleurs pour libérer les ressources système et éviter les fuites de mémoire lorsque l'ecran est détruit de la pile de navigation

Palier 4 Question de comprehension:
Q1 : Le champ date est en readOnly pour empêcher l'utilisateur d'ouvrir le clavier virtuel et de taper une date manuellement ce qui risquerait d'introduire des formats invalides ou des fautes de frappe. Sans cela, l'utilisateur pourrait écrire n'importe quoi et casser la logique de validation de la date.

Q2 : Parce qu'à chaque fois que setState() est appelé lorsque l'utilisateur change de formule dans le SegmentedButton, Flutter reconstruit l'interface graphique (build). Comme _total est un getter calculé à la volée à partir de _formule et _prixParPersonne, il est réévalué automatiquement à chaque affichage sans nécessiter de variable d'état supplémentaire ni de calcul manuel.


Palier 5 Question de comprehension:
Q1 : reservation vaut null, car aucun objet n'a été passé en paramètre à Navigator.pop(context) lors de la fermeture par la flèche de l'AppBar.

Q2: VS Code affiche un avertissement de type « Use of 'BuildContext' across asynchronous gaps ». Cela signifie qu'utiliser le context après un délai asynchrone (await) sans vérifier si le widget est toujours monté (mounted) peut provoquer des bugs ou des crashes si l'utilisateur a quitté l'écran entre-temps.

Q3 : nous apprend qu'une boîte de dialogue (AlertDialog) est gérée par Flutter comme un écran superposé géré à l'intérieur de la pile de navigation. Elle s'ouvre via un système de route et se ferme en la dépilant avec Navigator.pop.


TP5 Question de Comprehension :
Palier0:
Q1: La /destinations/99 renvoie le code 404 Not Found. Il appartient à la famille des erreurs client

Q2: Le serveur a choisi l'id de la réservation qui & généré et attribué l'ID automatiquement lors de l'enregistrement de la ressource.

Q3: Une requete Get récuprére les données, alors l'URL et les parametres de requete suffisent à récupérer les données, Contrairement, un POST sert à envoyer des nouvelles données à enregistrer, alors le corps de la requete transporte donc ses données.

Palier2 :
Q1: Un constructeur factory permet de créer un nouvel objet tout en effectuant des vérifications ou en utilisant des données existantes.Contrairement à une méthode statique classique, il s'appelle directement avec Destination.fromJson(...), ce qui facilite la création des objets.

Q2: Si db.json contient "prix": "420", le prix est considéré comme une chaine de caractères (String) et non comme un entier (int).Donc l'expression "json['prix'] as int" provoquera une erreur de type (TypeError)

Q3: Parce que la méthode utilise une opération asynchrone. Le résultat n'est pas disponible immédiatement, Le programme ne peut pas bloquer en attendant la réponse, il renvoie donc une promesse (Future) qui se résoudra par la liste des destinations une fois la réponse du serveur reçue et traitée.

Palier3:
Q1: On déclare _futurDestinations avec late parce que _futurDestinations sera initialisée plus tard, généralement dans la méthode initState(), avant son utilisation

Q2: Sans le test snapshot.hasError quand le serveur est aarrété, l'utilisateur verrait une erreur à l'écran au lieu d'un message clair indiquant que le chargement a échoué.

Q3: Non. La liste complète des destinations a déjà été récupérée depuis le serveur et stockée en mémoire via snapshot.data. le changement de catégorie,reconstruit la vue  et filtre les données existantes sur la liste sans contacter le serveur.

Palier4:
Q1: les relations entre les données se font par identifiant(id),alors l'envoie de l'ID permet d'éviter de renvoyer des données en double, puisque le serveur peut facilement lier la réservation grace à cet identifiant unique.

Q2: Le serveur ne comprendra pas le format des données envoyées et rejettera la requête, car cet en-tête lui indique explicitement qu'on lui transmet du JSON.

Q3: on test mounted apres await de creerReservation pour s'assurer que l'écran, existe toujours, au cas où l'utilisateur aurait quitté la page pendant que la requête réseau s'exécutait, ce qui évite une erreur critique d'exécution.