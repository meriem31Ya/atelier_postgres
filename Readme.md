# 🎮 TP SQL – Analyse d'une base de données de jeux vidéo`

> Objectif : réaliser les requêtes ci-dessous. Chaque exercice indique le but.
> Pré-requis : schéma + données chargés depuis `bdd`.

## 📥 Étape 1 : Importer la base de données

---

1. **Créer un utilisateur et une base**

   ```sql
   -- À COMPLÉTER
   -- Créer l'utilisateur mon_user avec un mot de passe
   -- Créer la base video_games en propriétaire mon_user
   -- Se connecter à la base
   ```

2. **Charger le schéma et les données** (remplacer le chemin)

   ```sql
   -- À COMPLÉTER
   -- \i 'CHEMIN/vers/bdd/nom.sql'
   ```

3. **Privilèges**  
   Accorder à `mon_user` les privilèges nécessaires sur le schéma `public`, sur **toutes les tables** et **toutes les séquences** existantes, et définir des **privilèges par défaut** pour les futurs objets.
   ```sql
   -- À COMPLÉTER
   -- GRANT ... ON SCHEMA public TO mon_user;
   -- GRANT ... ON ALL TABLES IN SCHEMA public TO mon_user;
   -- GRANT ... ON ALL SEQUENCES IN SCHEMA public TO mon_user;
   -- ALTER DEFAULT PRIVILEGES ...
   ```

> (Windows) Démarrer `psql` si besoin :

```bat
cd "C:\Program Files\PostgreSQL\17\bin"
.\psql.exe -U postgres
```

---

## 🧠 Étape 2 : Requêtes SQL à réaliser

> ✏️ Pour chaque question, écrivez la requête SQL correspondante et commentez-la brièvement.

## 1) Vérifications rapides

1. **Lister toutes les lignes** de `game` et de `genre`.

2. **Compter** le nombre de jeux.

## 2) Jeux & Genres

1. **Lister les jeux avec leur genre** (y compris les jeux sans genre).

2. **Compter les jeux par genre** (tri décroissant).

3. **Lister les jeux sans genres** (2 variantes possibles).

## 3) Jeux, Éditeurs & Plateformes

1. **Sélectionner les jeux avec leur éditeur associé.**

2. **Lister les jeux avec leur éditeur et leur plateforme associée.**

3. **Lister les 5 jeux les plus récents** en se basant sur `release_year`.

4. **Lister les jeux sans éditeur.**

5. **Lister les éditeurs distincts.**

## 4) Agrégations : éditeurs & plateformes

1. **Compter les jeux par éditeur (Top 10).**

2. **Compter les jeux par plateforme (Top 10).**

3. **Compter le nombre de jeux pour la plateforme 'GBA'.**

4. **Nombre de jeux par plateforme (toutes).**

5. **Lister les plateformes sans jeux.**

## 5) Tri & filtres texte / regex

1. **Lister les jeux par ordre alphabétique.**

2. **Afficher les 5 genres les plus populaires** (en nombre de jeux).

3. **Afficher les 5 genres les moins populaires** (en nombre de jeux).

4. **Jeux dont le nom commence par 'Super'.**

5. **Jeux dont le nom contient 'Mario'.**

6. **Jeux dont le nom contient un chiffre** (regex).

7. **Jeux dont le nom finit par 'Edition'.**

8. **Bonus regex : jeux avec plateformes sans voyelles** dans le nom de plateforme.

## 6) Ventes & régions

1. **Top 10 des jeux les plus vendus en Europe (EU).**

2. **Ventes totales par éditeur (toutes régions).**

3. **Top 5 éditeurs par ventes au Japon (JP).**

4. **Ventes globales d’un jeu (somme multi‑régions) — Top 20 jeux.**

---

## 7) Jointures multiples & agrégations avancées

1. **Jeux avec leur genre et la liste des plateformes** (utiliser `STRING_AGG` + `DISTINCT`).

## 8) Full‑Text Search (FTS)

1. **Trouver les jeux correspondant à “shooting & space”.**

## 9) Fenêtre temporelle

1. **Lister les jeux sortis sur les 10 dernières années** (via `release_year`).

## 10) Vues & qualité des données

1. **Créer une vue `gameinfos`** retourne uniquement le nom du jeu et son genre

2. **À partir de la vue**, afficher les **les 10 premiers jeux avec leur genre**.

3. **Détecter les doublons de jeux** (même `game_name` + `release_year`).

   ```sql
   -- À COMPLÉTER
   -- GROUP BY g.game_name, gpl.release_year
   -- HAVING COUNT(*) > 1
   ```

4. **Détecter les éditeurs orphelins sans jeux**.

5. **(Optionnel) Appeler une procédure** si elle existe (ex. `add_game`).

   ```sql
   -- À COMPLÉTER
   -- CALL add_game(genre_id, 'Nom du jeu');
   ```

### Modèle de données attendu (rappel)

- `game`, `genre`, `publisher`
- `game_publisher (id, game_id, publisher_id)`
- `game_platform (id, game_publisher_id, platform_id, release_year)`
- `platform`
- `region_sales (id, game_platform_id, region_id, num_sales)`

> Adaptez les noms si votre schéma diffère légèrement.
