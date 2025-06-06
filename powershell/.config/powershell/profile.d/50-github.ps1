function ga {
  git add
}

function gs {
  git status
}

function gc($message) {
  git commit -m $message
}

function gp {
  git push
}

function gpoh {
  git push origin HEAD
}

function gh($message) {
  if (-not $message) {
    Write-Host "Por favor, forneça uma mensagem de commit."
  } else {
    git add .
    git commit -m $message
    git push origin HEAD
  }
}
