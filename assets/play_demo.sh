hugo new site "hugo-demo.hezser.de"
git submodule add https://github.com/McShelby/hugo-theme-relearn hugo-demo.hezser.de/themes/relearn
cd hugo-demo.hezser.de
echo "theme = 'relearn'" >> hugo.toml
