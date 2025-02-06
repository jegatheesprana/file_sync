#!/bin/bash

# run ./script.sh
# run ./script.sh -c to copy screenshots to the repo

repo=git@github.com:pranavan/testing.git
branch="main"

mkdir -p big_data
cd big_data
[ -d .git ] || git init
git remote | grep -q origin || git remote add origin $repo
git fetch
if git show-ref --verify --quiet refs/heads/$branch; then
    git checkout $branch
elif git ls-remote --heads origin $branch | grep -q $branch; then
    echo "Branch '$branch' exists remotely. Checking out and tracking..."
    git checkout -b $branch origin/$branch
else
    echo "Branch '$branch' does not exist."
	git checkout -b $branch
	touch ans.txt
	git add ans.txt
	git commit -m "Initial commit"
	git push --set-upstream origin $branch
fi

git pull --rebase 2>/dev/null || echo "Pull failed or Branch $branch doesn't exist remotely."
# trying to push
if git push; then
	echo "Push successful!"
else
	echo "Push failed. Trying to pull and push again..."
	
	# Pull latest changes
	git pull --rebase
	
	# Try pushing again
	git push && echo "Push successful after pulling."
fi

while true; do
	output=$(git pull --rebase 2>&1)

	# Check if the output contains "Already up to date" or any changes
	if [[ "$output" != *"Already up to date."* ]]; then
	    # Print the output if there were any changes
	    echo "$output"
	fi
	if [[ "$1" == "-c" ]]; then
		cp /home/$USER/Pictures/Screenshots/* .
	fi
	if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
	    # Get the current date and time for the commit message
	    commit_message="Commit on $(date '+%Y-%m-%d %H:%M:%S')"
	    
	    # Stage all changes and commit with the generated message
	    git add -A
	    git commit -m "$commit_message"
	    if git push; then
			echo "Push successful!"
		else
			echo "Push failed. Trying to pull and push again..."
			
			# Pull latest changes
			git pull --rebase
			
			# Try pushing again
			git push && echo "Push successful after pulling."
		fi
	    
	    echo "Changes committed with message: $commit_message"
	fi
    	sleep 1  # Wait for 1 second
done
