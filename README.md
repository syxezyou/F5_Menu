# Menu F5 en RageUI pour FiveM

Un menu F5 simple et configurable pour votre serveur FiveM, développé avec le framework RageUI V2. Ce README vous guidera pour l'installation et la configuration.

## 📸 Aperçu (Preview)

Les captures d’écran ne sont pas encore documentées.

## ✨ Fonctionnalités

*   **Interface Intuitive** : Navigation simple et claire grâce à RageUI.
*   **Entièrement Configurable** : Modifiez facilement les options, les touches et les permissions depuis le fichier `config.lua`.
*   **Optimisé** : Le script est conçu pour être léger et ne pas impacter les performances de votre serveur (0.00ms au repos).

## 📋 Prérequis

Avant d'installer ce menu, assurez-vous d'avoir les éléments suivants :

*   Un serveur FiveM fonctionnel.
*   La ressource RageUI_V2 installée et fonctionnelle.

## 🛠️ Installation

1.  Téléchargez la dernière version du script depuis la section "Releases" de GitHub.
2.  Décompressez l'archive `.zip` que vous venez de télécharger.
3.  Copiez le dossier du script (par exemple, `F5_menu`) dans le répertoire `resources` de votre serveur FiveM.
4.  Assurez-vous que `RageUI` est bien présent dans vos ressources et démarré **avant** ce script.
5.  Ajoutez la ligne suivante dans votre fichier `server.cfg` :

```cfg
# Exemple de configuration dans server.cfg
# Assurez-vous que RageUI est démarré avant votre menu.

start RageUI
start F5_menu # <-- Remplacez "F5_menu" par le nom du dossier de votre script
```

6.  Redémarrez complètement votre serveur FiveM ou lancez la ressource via la console (`refresh` suivi de `start F5_menu`).

## 🎮 Utilisation

Par défaut, appuyez sur la touche **F5** pour ouvrir et fermer le menu. Vous pouvez changer cette touche dans le fichier `config.lua`.

## 📝 Crédits

*   **Développement du script** : SYX
*   **Framework UI** : Un grand merci à ImRage pour son excellent travail sur RageUI.

## 📄 Licence

Consultez les conditions de licence du dépôt avant redistribution.

---

## Auteur et maintenance

**SYX** — [GitHub @syxezyou](https://github.com/syxezyou).

Pour signaler un problème, indiquez la version utilisée, les étapes de reproduction et les messages d’erreur pertinents, sans publier de secrets ni d’identifiants.
