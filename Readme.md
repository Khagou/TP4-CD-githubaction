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

7- Dirigez-vous ensuite sur "Kubernetes Engine" et créez votre cluster en l'appelant "deployment-cluster" dans la région "europe-west1" (vous pouvez choisir un autre nom et une autre région mais cela demandera quelques modification donc les fichiers de deploiement k8s).

8- Accèder au repot github puis au parametres de celui-ci, dans le bandeau de gauche dans la section securite cliquer sur "secrets and variables" puis Actions. Une page avec 2 onglets ("Secrets" et "Variables") s'ouvre.

- **Creation des Secrets**:

  - Dans l'onglet **_"secrets"_** cliquer sur **_New repository secret_** nommer le premier secret `DOCKER_TOKEN`, puis coller votre token cree juste avant sur le hub docker dans la section "Secret\*" (si besoin voir point 4 https://github.com/Khagou/TP3-CI-github-actions/blob/main/Readme.md#configuration-des-parametres-de-pipeline)
  - Recreer un nouveau secret et le nommer `DOCKER_USER`, entrer son pseudo hub docker en secret
  - Creer ensuite un secret `GOOGLE_CREDENTIALS`, et copier le contenu du fichier telecharge lors de la creation de la cle du compte de service

- **Creation des Variables**:
  - Acceder a l'onglet **_"variable"_** puis cliquer sur **_New repository variable_**, nommer cette premiere variable `DOCKER_REPO` et entrer en valeur le nom du repot creer sur le hub docker lors de l'etape 3
  - Creer une variable `IMAGE_FILE` laquelle contiendra le chemin du dockerfile de l'app si vous n'avez rien modifier entrez en valeur `docker-app/python/Dockerfile` si non entrez le nouveau chemin
  - Creer une variable `IMAGE_OS` et entrez la valeur `ubuntu-latest` ou celle de votre choix, a savoir que le workflow est parametre pour du Debian, certaines modifications peuvent etre necessaire pour un autre OS.
  - Creer une variable `DOCKER_IMAGE_VERSION` qui contiendra la version de l'image de votre application
  - Creer une variable `TEST_INSTANCE` qui contiendra le nom de l'instance de test, python-test-instance, si vous ne l'avez pas modifié dans les variables terraform du dossier **test_env**
  - Pour finir créer une variable `GCP_PROJECT` et entrez l'ID de votre projet

### Deploiement dans l'environnement de dev

1- A l'aide de votre IDE, modifier les variables "gcp_project" et "sa_email" du fichier `variables.tf` dans le dossier *dev_env*, modifiez ensuite le bucket du fichier providers.tf

2- Réalisation du push sur la branche test, afin de lancer le workflow dev.yml

```
git checkout -b dev
git add ./dev_env/ ./.github/workflows/dev.yml ./docker-app/
git commit -m "< entrer un commentaire de votre choix >"
git push origin dev
```

3- Le workflow ce lance et va réaliser l'ensemble des jobs. Pour voir votre workflow tourner vous pouvez cliquer le sur bouton **_"Actions"_** sur le bandeau du haut.

4- Une fois que le workflow a fini de tourner et que vous avez vérifié sur GCP que votre VM est bien présente et que le conteneur est bien présent dans celle-ci.
Il ne reste plus qu'a créer une pull request et à la merge sur la branch main pour ajouter votre travail. (pour réaliser une pull request vous pouvez voir le TP3 https://github.com/Khagou/TP3-CI-github-actions/blob/main/Readme.md)

### Deploiement dans l'environnement de test

1- A l'aide de votre IDE, modifier les variables "gcp_project" et "sa_email" du fichier `variables.tf` dans le dossier *test_env*, modifiez ensuite le bucket du fichier providers.tf.

2- Réalisation du push sur la branche test, afin de lancer le workflow test.yml

```
git checkout -b test
git add ./test_env/ ./.github/workflows/test.yml ./docker-test/ ./app/
git commit -m "< entrer un commentaire de votre choix >"
git push origin test
```

3- Le workflow ce lance et va réaliser l'ensemble des jobs. Pour voir votre workflow tourner vous pouvez cliquer le sur bouton **_"Actions"_** sur le bandeau du haut.

4- Une fois que le workflow a fini de tourner et que vous avez vérifié sur GCP que votre VM est bien présente et que le conteneur app et les images de test (les conteneurs s'éteignent automatiquement à la fin des tests) sont bien présents dans celle-ci.
Il ne reste plus qu'a créer une pull request et à la merge sur la branch main pour ajouter votre travail. (pour réaliser une pull request vous pouvez voir le TP3 https://github.com/Khagou/TP3-CI-github-actions/blob/main/Readme.md)

### Deploiement dans l'environnement de prod

1- Sur GCP, dirigez vous sur l'artifact registry et sur l'image enregistré lors du déploiement du workflow de dev et récupérez le chemin de l'image, cela devrait ressembler à quelque chose comme "europe-west1-docker.pkg.dev/tp4-test-405014/docker-repo/tp4-cd:latest", puis dans le fichier `deployment.yml` du dossier **prod_env**.

2- Réalisation du push sur la branche test, afin de lancer le workflow prod.yml

```
git checkout -b prod
git add ./prod_env/ ./.github/workflows/prod.yml
git commit -m "< entrer un commentaire de votre choix >"
git push origin prod
```

3- Le workflow ce lance et va réaliser l'ensemble des jobs. Pour voir votre workflow tourner vous pouvez cliquer le sur bouton **_"Actions"_** sur le bandeau du haut.

4- Une fois que le workflow a fini de tourner et que vous avez vérifié sur GCP sur votre cluster que votre déploiement s'est bien déroulé.
Il ne reste plus qu'a créer une pull request et à la merge sur la branch main pour ajouter votre travail. (pour réaliser une pull request vous pouvez voir le TP3 https://github.com/Khagou/TP3-CI-github-actions/blob/main/Readme.md)
