# TP4 create a CD

## Contexte et composition du repot

Il est demande de mettre en place une chaine de deploiement continue pour une application Python. Aucun outils d'orchestration n'etant impose j'ai donc choisi Github action, celui-ci etant simple d'utilisation et directement integre a Github.

L'ensemble du repot permet de réaliser des tests et analyses sur l'application ainsi que les rapports pour:

- Le deploiement d'un conteneur sur une VM dans un environnement de dev
- Le deploiement d'un cluster K8S dans un environnement de prod
- Le deploiement d'un ensemble de conteneur avec docker compose sur une VM dans un environnement de test

Le repot est composé de 8 dossier:

- Le dossier **.github** est lui meme compose de :
  - d'un dossier **workflows** dans le quel ce trouve 3 workflowss github action pour les 3 environnements
- Le dossier **app** qui represente l'ensemble de l'application Python
- Le dossier **docker-app** contient un dossier **python** qui contient le dockerfile pour notre image docker pour l'application
- Le dossier **dev_env** qui contient l'ensemble des fichiers terraform utile au deploiement
- Le dossier **docker-test**  qui contient l'ensemble des Dockerfile et le fichier docker-composse
- Le dossier **env_base** qui contient un script shell et l'ensemble des fichiers terraform utile au deploiement de l'environnement utile au deploiement des environnements dev, test et prod
- Le dossier **prod_env** qui contient les 2 fichier kubernetes utile au deploiement dans le cluster
- Le dossier **test_env** qui contient l'ensemble des fichier terraform pour deployer l'environnement

## Prerequis

Disposer de git sur votre machine, d'un compte Github, d'un compte de facturation GCP et d'un compte sur le hub docker.

## Presentation du workflow

Si on regarde le workflow dev.yml on constate que le workflow:

1. Check l'image sur le hub docker en utilisant docker scout
2. Push l'image sur Google Artifact Registry
3. Deploie l'environnement avec terraform

--------------------------------------------------------------

Si on regarde le workflow test.yml on constate que le workflow:

1. Procède au deploiement terraform
2. Se connect en SSH a la VM deployé afin d'y installer docker et docker compose
3. Realise le deploiement docker compose

--------------------------------------------------------------

Si on regarde le workflow prod.yml on constate que le workflow:

1. Realise le deploiement sur Google Kubernetes Engine

   
## Configuration des parametres de pipeline

1- Cloner l'ensemble du repot sur votre machine

```
git clone https://github.com/Khagou/TP4-CD-githubaction.git
```

2- Creer un repot github et suivre les instructions fournis par github

3- Creer un projet GCP

4- Dans le dossier **env_base**, modifier les variables PORJET et BUCKET du script shell ainsi que la variable gcp_project du fichier variable et le nom du bucket du fichier versions

5- Importer le dossier **env_base** dans cloud shell, puis placez vous dans le dossier et lancez le script.

6- Une fois le script terminé, récupérez l'adresse email du commpte de service cree et creez lui une cle de compte de service (si vous ne l'avez pas modifie le compte de service devrait s'appeler terraform@<project_id>.iam.gserviceaccount.com), puis accordez le role "administrateur artifact registry" au compte de service compute engine, le nom doit ressembler a quelque chose comme "<project-number>-compute@developer.gserviceaccount.com".

7- Accèder au repot github puis au parametres de celui-ci, dans le bandeau de gauche dans la section securite cliquer sur "secrets and variables" puis Actions. Une page avec 2 onglets ("Secrets" et "Variables") s'ouvre.

- **Creation des Secrets**:

  - Dans l'onglet **_"secrets"_** cliquer sur **_New repository secret_** nommer le premier secret `DOCKER_TOKEN`, puis coller votre token cree juste avant sur le hub docker dans la section "Secret\*" (si besoin voir point 4 https://github.com/Khagou/TP3-CI-github-actions/blob/main/Readme.md#configuration-des-parametres-de-pipeline)
  - Recreer un nouveau secret et le nommer `DOCKER_USER`, entrer son pseudo hub docker en secret
  - Creer ensuite un secret `GOOGLE_CREDENTIALS`, et copier le contenu du fichier telecharge lors de la creation de la cle du compte de service

- **Creation des Variables**:
  - Acceder a l'onglet **_"variable"_** puis cliquer sur **_New repository variable_**, nommer cette premiere variable `DOCKER_REPO` et entrer en valeur le nom du repot creer sur le hub docker lors de l'etape 3
  - Creer une 2eme variable `IMAGE_FILE` laquelle contiendra le chemin du dockerfile de l'app si vous n'avez rien modifier entrez en valeur `docker-app/python/Dockerfile` si non entrez le nouveau chemin
  - Creer une 3eme variable `IMAGE_OS` et entrez la valeur `ubuntu-latest` ou celle de votre choix, a savoir que le workflow est parametre pour du Debian, certaines modifications peuvent etre necessaire pour un autre OS.
  - Creer ensuite une 4eme variable `ROBOT_FILE_NAME` et enregistrez y en valeur le nom du fichier robotframework, si vous ne l'avez pas modifie `machine.robot`
  - Puis creer une 5eme variable `ROBOT_FILE_WAY` qui contiendra le chemin du fichier robotframework, si non modifie `./app/test/system`
  - Creer une 6eme variable `DOCKER_IMAGE_VERSION` qui contiendra la version de l'image de votre application
  - Pour finir la 7eme variable s'appellera `UNITTEST_FILE` et contiendra le chemin du fichier unittest, si non modifie `test/unit/test.py`

6- Sur la machine, dans un terminal ce placer dans le dossier qui contient l'ensemble du repot, creer une nouvelle branche et ce placer dedans. Vous pouvez par exemple appeler la branche cicd.

```
git checkout -b < nom de la branche >
```

7- Realiser un commit de notre app

```
git add .
git commit -m "< entrer un commentaire de votre choix >"
```

8- Push de l'ensemble sur notre repot github

```
git push origin < nom de la branche cree a l'etape 6>
```

9- Acceder au repot sur github, dans le bandeau du haut cliquer sur **_"Pull requests"_** dans la nouvelle page cliquer sur **_"New pull request"_**.
Vous devriez alors voir afficher votre cicd, selectionnez la, github vous affiche alors les modification apporte lors du dernier push.
Cliquer sur **_"Create pull request"_**, dans la page qui s'est ouverte vous pouvez entrer un commentaire qui est facultatif, cliquer a nouveau sur **_"Create pull request"_** afin de creer la pull request a partir de votre branche cicd.

10- Le workflow ce lance et va proceder a l'enmsemble des tests et si tout ce deroule bien il lancera le build et le push de l'image docker.
Pour voir votre workflow tourner vous pouvez cliquer le sur bouton **_"Actions"_** sur le bandeau du haut.

11- Sur la page de votre workflow quand celui-ci est terminé, descendez afin de voir les _"Artifacts"_, c'est la que vous retrouverez l'ensemble des rapports que vous pouvez telecharger.

12- Une fois que le workflow a fini de tourner et si tout c'est bien deroule vous vous pouvez retourner sur votre pull request, github devrait vous signaler que tout les test sont passe.
Il ne reste plus qu'a merge la pull request en cliquant sur le bouton **_"Merge pull request"_**, vous pouvez alors modifier le commentaire, puis cliquer sur **_"Confirm merge"_**.
Si vous retourner sur la page principal du repot **_"<> Code"_** sur le bandeau du haut, et que vous affichez votre branche main, vous constaterez que votre code a bien ete mit a jour.
