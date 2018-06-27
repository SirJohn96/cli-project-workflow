function setup() {
  setup_projects
  setup_bash
}

function setup_projects() {
  read -p "Do you have a projects directory? (Y/n)`setup_newline`" answer
  case ${answer:0:1} in
    y|Y )
      setup_where_projects
    ;;
    n|N )
      setup_projects_directory
    ;;
    * )
      echo "Invalid input."
      setup_projects
    ;;
  esac
}

function setup_bash() {
  read -p "Do you know where your .bashrc file is? (Y/n)`setup_newline`" answer
  case ${answer:0:1} in
    y|Y )
      setup_where_bash
    ;;
    n|N )
      setup_solve
    ;;
    * )
      echo "Invalid input."
      setup_bash
    ;;
  esac
}

function setup_where_projects() {
  read -p "Enter the path of your projects directory.`setup_newline`" answer

  tilde=`echo $answer | cut -d/ -f1`
  if [ "$tilde" = '~' ]
    then
    answer="${answer/#\~/$HOME}"
  fi

  if [ -d "$answer" ]
    then
    setup_add_variable projects_directory $answer >> ./bashrc_variables.sh
    echo "Noted."
  else
    echo "Directory not found."
    setup_where_projects
  fi
}

function setup_projects_directory() {
  read -p "Would you like to create one now? (Y/n).`setup_newline`" answer
  case ${answer:0:1} in
    y|Y )
      read -p "What should the name be? Type in a full path.`setup_newline`" answer

      tilde=`echo $answer | cut -d/ -f1`
      if [ "$tilde" = '~' ]
        then
        answer="${answer/#\~/$HOME}"
      fi

      if [ -d $(dirname $answer) ]
        then
        mkdir $answer
        setup_add_variable projects_directory $answer >> ./bashrc_variables.sh
      else
        echo "The directory $(dirname $answer) does not exist."
        exit
      fi
    ;;
    n|N )
      echo "Okay. One can manually be created. This is a requirement."
      exit
    ;;
    * )
      echo "Invalid input."
      setup_projects_directory
    ;;
  esac
}

function setup_where_bash() {
  read -p "Enter the path and name of the file.`setup_newline`" answer

  tilde=`echo $answer | cut -d/ -f1`
  if [ "$tilde" = '~' ]
    then
    answer="${answer/#\~/$HOME}"
  fi

  if [ -f "$answer" ]
    then
    setup_add_reference >> $answer
    setup_add_variable bashrc_path $answer >> ./bashrc_variables.sh
    setup_success
  else
    echo "File not found."
    setup_where_bash
  fi
}

function setup_solve() {
  read -p "Would you like to attempt a search for the file? If not, we can create the file in your home directory (~). (Y/n)`setup_newline`" answer
  case ${answer:0:1} in
    y|Y )
      setup_find
    ;;
    n|N )
      setup_create
    ;;
    * )
      echo "Invalid input."
      setup_solve
    ;;
  esac
}

function setup_find() {
  echo "Searching..."
  file=`find ~ -name ".bashrc" -print -quit`

  if [ -n "$file" ]
    then
    echo "Found "$(basename $file)" in "$(dirname $file)"."
    read -p "Use file? (Y/n)`setup_newline`" answer
    case ${answer:0:1} in
      y|Y )
        setup_add_reference >> $file
        setup_add_variable bashrc_path $file >> ./bashrc_variables.sh
        setup_success
      ;;
      n|N )
        echo "Okay. Bye now."
        return
      ;;
      * )
        echo Invalid input.
        setup_find
      ;;
    esac
  else
    echo "No .bashrc file found."
    setup_create
  fi
}

function setup_create() {
  read -p "May we create the .bashrc file in your home directory (~)? (Y/n)`setup_newline`" answer
  case ${answer:0:1} in
    y|Y )
      setup_add_reference >> ~/.bashrc
      setup_add_variable bashrc_path ~/.bashrc >> ./bashrc_variables.sh
      setup_success
    ;;
    n|N )
      return
    ;;
    * )
      echo "Invalid input."
      setup_create
    ;;
  esac
}

function setup_add_reference() {
  echo "# Command Line Interface Project Workflow"
  echo "source $(pwd)/bashrc_variables.sh # CLI PW Added"
  echo "source $(pwd)/bashrc.sh # CLI PW Added"

  echo $'\n'"# CLI Project Workflow Generated Aliases"
}

function setup_add_variable() {
  echo "$1=\"$2\""
}

function setup_success() {
  echo "The setup is complete. You may need to start a new session. (Y/n)"
}

function setup_newline() {
  echo $'\n> '
}

setup
