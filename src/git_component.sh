commit_fn() {
  cp "../src/commits/element_c$1.sh" "./element.sh"
  git add element.sh
  git commit -m "$2"
}

# make the directory if it does not exist
mkdir -p periodic_table

# remove the .git folder if it exists
rm -rf periodic_table/.git
cd periodic_table
git init

# perform the 1st commit
commit_fn 1 "Initial commit"

# rename the branch to main
git branch -m master main

# create a feature branch
git checkout -b feat/add_greeting

# perform the 2nd commit
commit_fn 2 "feat: Add generic greeting"

# merge commits 2 into main
git checkout main
git merge feat/add_greeting

# create a feature branch
git checkout -b feat/argument_support

# perform the 3rd-9th commit
commit_fn 3 "feat: Add basic argument behavior"
commit_fn 4 "feat: Differentiate between string and number args"
commit_fn 5 "feat: Add element lookup"
commit_fn 6 "feat: Add properties lookup"
commit_fn 7 "feat: Formatted user feedback statement"
commit_fn 8 "feat: Failed element user statment"
commit_fn 9 "fix: No argument user statement"
commit_fn 10 "feat: Add comments"

# merge commits 3-9 into main
git checkout main
git merge feat/argument_support

# make the file executable
chmod +x element.sh

# copy the file as required by the project description
cp element.sh ../element.sh
