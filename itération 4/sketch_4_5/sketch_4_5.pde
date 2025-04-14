int bombes = 0;
int nombre_de_bombe =20;
int bomb_adj = 0; // Variable inutilisée ici
boolean[][] grille = new boolean[9][9];
int[][] bombes_adj = new int[grille.length][grille[0].length];

int taille_case = 70;
int nbLignes = grille.length;
int nbColonnes = grille[0].length;
boolean[][] casesCliquees = new boolean[grille.length][grille[0].length]; // Tableau des cases cliquées

void settings() {
  int largeur = taille_case * nbColonnes;
  int hauteur = taille_case * nbLignes;
  size(largeur, hauteur);
}

void setup() {
  init_plateau(grille);
}

void draw() {
  for (int y = 0; y < grille.length; y++) {
    for (int x = 0; x < grille[y].length; x++) {
      // Choix de couleur selon l'état de la case
      if (casesCliquees[y][x]) {
        if (grille[y][x]) {
          fill(255, 0, 0);  // Bombe
        } else {
          fill(200);        // Case vide découverte
        }
      } else {
        fill(180);  // Case non cliquée
      }

      // Dessine la case
      rect(x * taille_case, y * taille_case, taille_case, taille_case);

      if (casesCliquees[y][x] && grille[y][x] == false) {
        fill(0);
        textAlign(CENTER, CENTER);
        textSize(16);
        text(str(bombes_adj[y][x]), x * taille_case + taille_case / 2, y * taille_case + taille_case / 2);
      }
    }
  }
}

void mouseClicked() {
  int x = mouseX / taille_case;
  int y = mouseY / taille_case;

  if (x >= 0 && x < grille[0].length && y >= 0 && y < grille.length) {
    casesCliquees[y][x] = true;

    if (grille[y][x] == false) {
      // Si la valeur n'est pas 0, on affiche le nombre de bombes adjacentes
      if (bombes_adj[y][x] > 0)
      {
        fill(0);
        textAlign(CENTER, CENTER);
        textSize(16);
        text(str(bombes_adj[y][x]), x * taille_case + taille_case / 2, y * taille_case + taille_case / 2);
      } else {

        vide(y, x);
      }
    }
    if (grille[y][x] == true) {
      gameover();
    }
    if (verifierVictoire()) {
      victoire();  // Appelle la fonction de victoire
    }
  }
}


void vide(int y, int x) {
  println("Clique sur la case: (" + y + ", " + x + ")");

  // Haut gauche
  if (y > 0 && x > 0) {
    if (bombes_adj[y - 1][x - 1] == 0 && casesCliquees[y - 1][x - 1] == false) {
      casesCliquees[y - 1][x - 1] = true;
      vide(y - 1, x - 1);
    } else if (bombes_adj[y - 1][x - 1] > 0) {
      casesCliquees[y - 1][x - 1] = true;
    }
  }

  // Haut
  if (y > 0) {
    if (bombes_adj[y - 1][x] == 0 && casesCliquees[y - 1][x] == false) {
      casesCliquees[y - 1][x] = true;
      vide(y - 1, x);
    } else if (bombes_adj[y - 1][x] > 0) {
      casesCliquees[y - 1][x] = true;
    }
  }

  // Haut droite
  if (y > 0 && x < bombes_adj[0].length - 1) {
    if (bombes_adj[y - 1][x + 1] == 0 && casesCliquees[y - 1][x + 1] == false) {
      casesCliquees[y - 1][x + 1] = true;
      vide(y - 1, x + 1);
    } else if (bombes_adj[y - 1][x + 1] > 0) {
      casesCliquees[y - 1][x + 1] = true;
    }
  }

  // Droite
  if (x < bombes_adj[0].length - 1) {
    if (bombes_adj[y][x + 1] == 0 && casesCliquees[y][x + 1] == false) {
      casesCliquees[y][x + 1] = true;
      vide(y, x + 1);
    } else if (bombes_adj[y][x + 1] > 0) {
      casesCliquees[y][x + 1] = true;
    }
  }

  // Bas droite
  if (y < bombes_adj.length - 1 && x < bombes_adj[0].length - 1) {
    if (bombes_adj[y + 1][x + 1] == 0 && casesCliquees[y + 1][x + 1] == false) {
      casesCliquees[y + 1][x + 1] = true;
      vide(y + 1, x + 1);
    } else if (bombes_adj[y + 1][x + 1] > 0) {
      casesCliquees[y + 1][x + 1] = true;
    }
  }

  // Bas
  if (y < bombes_adj.length - 1) {
    if (bombes_adj[y + 1][x] == 0 && casesCliquees[y + 1][x] == false) {
      casesCliquees[y + 1][x] = true;
      vide(y + 1, x);
    } else if (bombes_adj[y + 1][x] > 0) {
      casesCliquees[y + 1][x] = true;
    }
  }

  // Bas gauche
  if (y < bombes_adj.length - 1 && x > 0) {
    if (bombes_adj[y + 1][x - 1] == 0 && casesCliquees[y + 1][x - 1] == false) {
      casesCliquees[y + 1][x - 1] = true;
      vide(y + 1, x - 1);
    } else if (bombes_adj[y + 1][x - 1] > 0) {
      casesCliquees[y + 1][x - 1] = true;
    }
  }

  // Gauche
  if (x > 0) {
    if (bombes_adj[y][x - 1] == 0 && casesCliquees[y][x - 1] == false) {
      casesCliquees[y][x - 1] = true;
      vide(y, x - 1);
    } else if (bombes_adj[y][x - 1] > 0) {
      casesCliquees[y][x - 1] = true;
    }
  }
}


void gameover() {
  for (int y = 0; y < grille.length; y++) {
    for (int x = 0; x < grille[y].length; x++) {
      if (grille[y][x] == true) {
        fill(255, 0, 0);
        rect(x * taille_case, y * taille_case, taille_case, taille_case);
      }
    }
  }
  // Affiche un message au centre
  fill(0);               // Couleur du texte : noir
  textSize(32);          // Taille du texte
  textAlign(CENTER, CENTER);
  fill(255,0,0);
  text("BOOM ! Tu as perdu ", width / 2, height / 2);

  noLoop();
}

void victoire() {
  // Affiche un message de victoire au centre
  fill(0);               // Couleur du texte : noir
  textSize(32);          // Taille du texte
  textAlign(CENTER, CENTER);
  fill(0,255,0);
  text("Félicitations ! Tu as gagné", width / 2, height / 2);

  noLoop(); // Arrête la boucle de jeu
}

boolean verifierVictoire() {
  for (int y = 0; y < grille.length; y++) {
    for (int x = 0; x < grille[y].length; x++) {
      // Si la case n'est pas une bombe et n'a pas été cliquée, la partie n'est pas terminée
      if (grille[y][x] == false && casesCliquees[y][x] == false) {
        return false; // Il reste des cases non découvertes sans bombe
      }
    }
  }
  return true; // Toutes les cases sans bombe ont été découvertes
}



void init_plateau(boolean[][] pose_bombe) {
  // Initialisation de la grille sans bombe
  for (int y = 0; y < pose_bombe.length; y++) {
    for (int x = 0; x < pose_bombe[y].length; x++) {
      pose_bombe[y][x] = false;
    }
  }

  // Placement des bombes
  while (bombes < nombre_de_bombe) {
    int index_y = int(random(pose_bombe.length));
    int index_x = int(random(pose_bombe[0].length));
    if (pose_bombe[index_y][index_x] == false) {
      pose_bombe[index_y][index_x] = true;
      bombes++;
    }
  }

  // Comptage des bombes adjacentes pour les cases vides
  for (int y = 0; y < pose_bombe.length; y++) {
    for (int x = 0; x < pose_bombe[y].length; x++) {
      // Si la case est vide (pas une bombe)
      if (pose_bombe[y][x] == false) {
        // Vérification des voisins
        if (y > 0 && x > 0 && pose_bombe[y - 1][x - 1] == true) {  // Haut gauche
          bombes_adj[y][x]++;
        }
        if (y > 0 && pose_bombe[y - 1][x] == true) {  // Haut
          bombes_adj[y][x]++;
        }
        if (y > 0 && x < pose_bombe[y].length - 1 && pose_bombe[y - 1][x + 1] == true) {  // Haut droite
          bombes_adj[y][x]++;
        }
        if (x < pose_bombe[y].length - 1 && pose_bombe[y][x + 1] == true) {  // Droite
          bombes_adj[y][x]++;
        }
        if (y < pose_bombe.length - 1 && x < pose_bombe[y].length - 1 && pose_bombe[y + 1][x + 1] == true) {  // Bas droite
          bombes_adj[y][x]++;
        }
        if (y < pose_bombe.length - 1 && pose_bombe[y + 1][x] == true) {  // Bas
          bombes_adj[y][x]++;
        }
        if (y < pose_bombe.length - 1 && x > 0 && pose_bombe[y + 1][x - 1] == true) {  // Bas gauche
          bombes_adj[y][x]++;
        }
        if (x > 0 && pose_bombe[y][x - 1] == true) {  // Gauche
          bombes_adj[y][x]++;
        }
      }
    }
  }
}
