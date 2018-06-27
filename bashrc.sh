function create-project() {
  mkdir "$projects_directory/$1"
  mkdir "$projects_directory/$1/DatabaseDumps"
  mkdir "$projects_directory/$1/Documents"
  mkdir "$projects_directory/$1/main"

  echo "alias $1=\"cdpr $1\" # CLI PW Generated" >> $bashrc_path
  echo "alias ${1,,}=\"cdpr $1\" # CLI PW Generated" >> $bashrc_path
  source $bashrc_path
}

function cd-project() {
  cd "$projects_directory/$1"

  if [ ${2+x} ]
    then
    cd "$projects_directory/$1/$2"
  fi

  if [ ${3+x} ]
    then
    vagrant $3
  fi
}

function get-dbdump() {
  project=${PWD##*/}

  cd "../"
  client=${PWD##*/}

  cd "../"
  current_directory=`pwd`

  if [ "$current_directory" = "$projects_directory" ]
    then
    cd "$current_directory/$client/$project"

    dbdump=`ls "../DatabaseDumps" | while read -r file; do
      stat -c '%Y %n' "../DatabaseDumps/$file"
    done | sort -nr | cut -d ' ' -f2 | head -1`

    if [ -n "$dbdump" ]
      then
      cp $dbdump ./

      gzip="gzip -dc < ${dbdump##*/} | mysql -u {username} -p sql-cli"
      echo $gzip | clip
      echo "Here you go: $gzip"
    else
      echo "There are currently no database dumps."
    fi
  else
    echo "You must be in a valid project directory. (Ex: ~/Projects/BestClient/main)"
  fi
}

alias crpr="create-project"

alias cdpr="cd-project"

alias gdb="get-dbdump"
