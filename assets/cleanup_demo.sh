# remove git submodule
cd /workspaces/Static-websites-with-Hugo/
git rm hugo-demo.hezser.de/themes/relearn -f
rm -rf .git/modules/hugo-demo.hezser.de

# remove hugo-demo.hezser.de
rm -rf hugo-demo.hezser.de