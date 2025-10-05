Afin que terraform crée des envrionnement cohérant, vous dever configurer votre username git dans votre IDE avec le meme username que sur github:

```sh
git config --global user.name "your-github-username" # ton username github
```

!! Si vous ne le faite pas l'infrastructure deployée par terraform ne sera coherante avec ce qui se passe en CI.