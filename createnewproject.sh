#!/bin/bash


# Check arguments
if [ "$#" -ne 1 ]; then
  echo "Please enter the path of new project ; example: createnewproject ~/MyNewProject"
  return 1
fi

template_directory=`pwd`
new_directory=$1
new_project=${new_directory##*/}
new_project_workspace=${new_directory%/*}
git_user_name=`git config user.name`
git_user_email=`git config user.email`
echo "Creating project ${new_project} from template ${template_directory}"
echo "User: ${git_user_name}  under workspace ${new_project_workspace}."
mkdir -p ${new_directory}
cd ${new_directory}



git init
git fetch --depth=1 -n ${template_directory}/.git
git reset --hard $(git commit-tree FETCH_HEAD^{tree} -m "${git_user_name} create project ${new_project}")

# 1.1 rename project name
sed -i "s/(BoilerPlate)/(${new_project})/" CMakeLists.txt
sed -i "s/(BoilerPlate)/(${new_project})/g" appveyor.yml

# 1.1 register the new files
git add CMakeLists.txt
git add appveyor.yml
exit 0
# 2.1 remove unwanted template files.
git rm createnewproject.sh
git rm CreateBoilerPlate.bat


rm README.md
echo '# TODO: Fill in this README' >> README.md
echo '' >> README.md
echo '### Status' >> README.md
echo "[![Build Status](https://travis-ci.org/${USERNAME}/$1.svg?branch=master)](https
://travis-ci.org/${USERNAME}/$1)" >> README.md
echo "[![Build status](https://ci.appveyor.com/api/projects/status/PROJECT_ID?svg=true)](https://ci.appveyor.com/project/${USERNAME}/$1)" >> README.md
echo '' >> README.md
echo 'This project is distributed under some license. See LICENSE for details.' >> README.md
git add README.md

git add .gitignore

# Fold these changes into the initial commit
git commit --amend --no-edit


cd external
rmdir fmt
git submodule add --depth 1 -- https://github.com/fmtlib/fmt.git
rmdir spdlog
git submodule add --depth 1 -- https://github.com/gabime/spdlog.git
rmdir doctest
git submodule add --depth 1 -- https://github.com/onqtam/doctest.git
cd ..
git submodule update --recursive



mkdir build
cd build
cmake ..
