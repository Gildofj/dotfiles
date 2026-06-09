# Git shortcuts with parameter forwarding ($args)
function ga { git add $args }
function gs { git status $args }
function gp { git push $args }
function gpoh { git push origin HEAD $args }
function gpl { git pull $args }
function gd { git diff $args }
function gdc { git diff --cached $args }
function gco { git checkout $args }
function gcb { git checkout -b $args }
function gb { git branch $args }
function gba { git branch -a $args }
function gcl { git clone $args }
function gst { git stash $args }
function gstp { git stash pop $args }
function gsts { git stash show -p $args }

# Git log with clean graph formatting and output limiter
function gl {
    git log --oneline --graph --decorate -n 10 $args
}
function gla {
    git log --oneline --graph --decorate --all -n 20 $args
}

# Dynamic commit function
# If called without arguments, opens default git editor. Otherwise commits with the provided message.
function gc {
    if ($args.Count -eq 0) {
        git commit
    } else {
        # Combine all arguments into a single commit message
        $msg = $args -join " "
        git commit -m $msg
    }
}

# Add, commit, and push dynamically targeting the current active branch
function gacp {
    if ($args.Count -eq 0) {
        Write-Host "Por favor, forneça uma mensagem de commit." -ForegroundColor Yellow
        return
    }
    
    $msg = $args -join " "
    git add -A
    git commit -m $msg
    
    # Get current active branch
    $branch = (git branch --show-current)
    if ($branch) {
        Write-Host "Pushing to origin $branch..." -ForegroundColor Cyan
        git push origin $branch
    } else {
        Write-Host "Could not detect active branch. Pushing to origin HEAD..." -ForegroundColor Yellow
        git push origin HEAD
    }
}
