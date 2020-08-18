#!/bin/sh

# If a command fails then the deploy stops
set -e

# setup key
mkdir -p /root/.ssh/
echo "${INPUT_DEPLOYKEY}" >/root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
ssh-keyscan -t rsa github.com >>/root/.ssh/known_hosts

git config --global user.name "${INPUT_USERNAME}"
git config --global user.email "${INPUT_EMAIL}"

hugo version

git submodule init
#git submodule sync
git submodule update

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

gitRepoUrl="${INPUT_REPO_URL}"
gitRepoBranch="${INPUT_BRANCH}"
if [[ ! -n $gitRepoUrl ]]; then
  echo "Requires git repo url"
  exit 1
fi
if [[ ! -n $gitRepoBranch ]]; then
  printf "\033[0;32mSetting default git.repo.branch = master\033[0m\n"
  gitRepoBranch="master"
fi

msg="rebuilding site $(date)"

# 删除 deploy dir
echo "当前目录："$(pwd)
deployDir=".deploy_git"
if [ ! -d $deployDir ]; then
  echo "mkdir $deployDir ..."
  mkdir $deployDir
  msg="First commit"
fi
rm -rf $deployDir/*
echo "已删除：$deployDir 下的文件"

# Build the project.
hugo --minify # if using a theme, replace with `hugo -t <YOURTHEME>`

cp -R public/* $deployDir
cd $deployDir
echo "已进入："$(pwd)
# 重新初始化 git
git init
git add -A
git commit -m "$msg"
git push -u $gitRepoUrl HEAD:$gitRepoBranch --force
