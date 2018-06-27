function remove() {
  read -p "Are you sure you want to remove CLI Project Workflow? We will not remove your projects, just file references, aliases, etc. (Y/n)`remove_newline`" answer
  case ${answer:0:1} in
    y|Y )
      source bashrc_variables.sh
      remove_aliases
      remove_references
      remove_variables
    ;;
    n|N )
      echo "Okay. No changes made."
    ;;
    * )
      echo "Invalid input."
      remove
    ;;
  esac
}

function remove_aliases() {
  sed -i 's/\(# CLI Project Workflow Generated Aliases.*\|alias.*# CLI PW Generated\)//' $bashrc_path
  sed -i '/^$/N;/^\n$/D' $bashrc_path
}

function remove_references() {
  sed -i 's/\(# Command Line Interface Project Workflow.*\|source.*# CLI PW Added\)//' $bashrc_path
  sed -i '/^$/N;/^\n$/D' $bashrc_path
}

function remove_variables() {
  rm bashrc_variables.sh
}


function setup_add_reference() {
  echo "# Command Line Project Workflow"
  echo "source $(pwd)/bashrc_variables.sh"
  echo "source $(pwd)/bashrc.sh"

  echo "`setup_newline`# CLI Project Workflow Generated Aliases"
}

function setup_add_variable() {
  echo "$1=\"$2\""
}

function setup_success() {
  echo "The setup is complete. You may need to start a new session. (Y/n)"
}

function remove_newline() {
  echo $'\n> '
}

remove
