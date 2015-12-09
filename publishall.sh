set -e

git branch -D master
git filter-branch --prune-empty --subdirectory-filter ./public/ -- master
git push origin master:master -f
