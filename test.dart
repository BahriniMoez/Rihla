// fonction qui retourne la somme d'une liste d'entiers
int somme(List<int> liste) {
  int total = 0;
  for (int i = 0; i < liste.length; i++) {
    total += liste[i];
  }
  return total;
}