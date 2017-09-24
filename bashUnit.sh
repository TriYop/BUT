#!/bin/bash
#
#==============================================================================
#
# BASH UNIT Testing library
#------------------------------------------------------------------------------
# Description: 
#   This library is designed to deliver unit testing capabilities and 
#   xUnit reports compatibility to bash scripts. 
#
# Version: 1.0.0
# Author   Yvan JANET
#==============================================================================

#=== 
# TODO: some more assertions are still in progress
# - File max permissions
# - File owner group
#



# Check if current shell is bash
if [ '/bin/bash' != "$SHELL" ]; then
  echo "This scripts requires BASH to run, not $SHELL." >> 2
  exit 1
fi

# Load custom configuration
[ -f /etc/bashunitrc ] && source /etc/bashunitrc
[ -f $HOME/.bashunitrc ] && source $HOME/.bashunitrc
if [ -z "$BASH_TEST_OUTDIR" ]; then
  BASH_TEST_OUTDIR=$(pwd)/TestResults
  [ ! -d $BASH_TEST_OUTDIR ] && mkdir $BASH_TEST_OUTDIR
fi
if [ -z "$BASH_TEST_OUTFILE" ]; then
  BASH_TEST_OUTFILE=$BASH_TEST_OUTDIR/$(basename $0.xml)
fi
#======================================
# Starts a new TestSuite result file.
# 
# @param $1 Script full name ($0 from calling script)
function beginTestSuite  {

  SCRIPT_FULLNAME=$1
  TIMESTAMP=$( date +'%Y-%m-%d %H:%M:%S' )
  PROPERTIES='PATH HOME PPID SHELL TERM PWD STY USER UID HOSTNAME HOSTTYPE MACHTYPE'

  echo "<testsuite hostname='${HOSTNAME}' name='${SCRIPT_FULLNAME}' timestamp='${TIMESTAMP}'>" > $BASH_TEST_OUTFILE
  echo "<properties>" >> $BASH_TEST_OUTFILE
  for property in $PROPERTIES; do
    prop='${'$property'}' 
    VALUE=$( eval "echo $prop" )
    echo "<property name='${property}' value='${VALUE}'></property>" >> $BASH_TEST_OUTFILE
  done
  echo "</properties>" >> $BASH_TEST_OUTFILE
}

#======================================a
# Ends a test suite result file
# 
function endTestSuite {
  echo "</testsuite>" >> $BASH_TEST_OUTFILE
}

#======================================
# Ends a generic test suite in error
# @param $1 the error code to return as exit code
# @param $2 the error message to log
# @param $3 the log file
function exitTestSuite {

  returnCode=$1
  errorMessage=$2
  logFile=$3

  echo "Error: ${errorMessage}" | tee -a ${logFile}
  echo "More details in log file '${logFile}'."
  endTestSuite
  exit $returnCode
}


#=======================================
# Starts a new generic test case
# @param $1 Test class
# @param $2 Test Name
function beginTestCase {
  CASE=$1
  NAME=$2
  echo "<testcase classname=\"org.bash.${CASE}\" name=\"${NAME}\">" >> $BASH_TEST_OUTFILE
}

#======================================
# Ends a generic test case
function endTestCase {
  echo "</testcase>" >> $BASH_TEST_OUTFILE
}


#======================================
# Adds a failure to a given test case. 
# 
# @param $1 failure message
# @param $2 failure type
# @param $3 stack trace / failure trace
function fail {
  msg=$( echo $1 | sed -e 's/\"/_/g' )
  type=$2
  trace=$3
  export lastTestError=1
  echo "Failure: ${msg}"
  echo "<failure message=\"${msg}\" type=\"${type}\">${trace}</failure>" >> $BASH_TEST_OUTFILE
}

#======================================
# Checks if param 2 is not empty
# 
# @param $1 failure message
# @param $2 result
function assertNotEmpty {
  export lastTestError=0
  msg=$1
  actual=$2
  beginTestCase NotEmpty "Check if not empty"
  [ -z "$actual" ] && fail "${msg}" 'NOT EMPTY' "Expected not empty, found '${actual}' instead."
  endTestCase
  
}

#======================================
# Check if param 2 is empty
# 
# @param $1 failure message
# @param $2 result
function assertEmpty {
  export lastTestError=0
  msg=$1
  actual=$2
  beginTestCase Empty "Check if empty"
  [ -z "$actual" ] || fail "${msg}" 'EMPTY' "Expected empty, found '${actual}' instead."
  endTestCase
}

#======================================
# Check if param 3 is equal to parameter 2
# 
# @param $1 failure message
# @param $2 expected value
# @param $3 actual value
function assertEquals {
  export lastTestError=0
  msg=$1
  expect=$2
  actual=$3
  beginTestCase Equality "Check for equality"
  [ "${expect}" = "${actual}" ] || fail "${msg}" 'EQUALITY' "Expected '${expect}', found '${actual}' instead."
  endTestCase
}

#======================================
# Check if param 3 differs from parameter 2
#
# @param $1 failure message
# @param $2 expected value
# @param $3 actal value
function assertDiffers {
  export lastTestError=0
  msg=$1
  expect=$2
  actual=$3
  beginTestCase Difference "Check for difference"
  [ "${expect}" = "${actual}" ] && fail "${msg}" 'INEQUALITY' "Expected '${expect}', found '${actual}' instead." 
  endTestCase
}

#======================================
# Check if param 2 points to an existing file
#
# @param $1 failure message
# @param $2 file name to check
function assertExists {
  export lastTestError=0
  msg=$1
  filename=$2
  beginTestCase Existence "Check for file ${filename} existence"
  [ -e "${filename}" ] || fail "${msg}"  'FILE EXISTS' "File ${filename} does not exist in filesystem."
  endTestCase
}

#======================================
# Check if param 2 points to an existing regular file
#
# @param $1 failure message
# @param $2 file name to check
function assertIsFile {
  export lastTestError=0
  msg=$1
  filename=$2
  beginTestCase RegularFile "Check if file ${filename} is regular file"
  [ -f "${filename}" ] || fail "${msg}"  'REGULAR FILE' "File ${filename} is not a regular file."
  endTestCase
}

#======================================
# Check if param 2 points to an existing readable file
#
# @param $1 failure message
# @param $2 file name to check
function assertIsReadableFile {
  export lastTestError=0
  msg=$1
  filename=$2
  beginTestCase ReadableFile "Check if file ${filename} is readable"
  [ -f "${filename}" ] || fail "${msg}"  'READABLE FILE' "File ${filename} is not a regular file."
  endTestCase
}

#======================================
# Check if param 2 points to an existing directory
#
# @param $1 failure message
# @param $2 file name to check
function assertIsDirectory {
  export lastTestError=0
  msg=$1
  filename=$2
  beginTestCase Directory "Check if file '${filename}' is Directory"
  [ -d "${filename}" ] || fail "${msg}"  'DIRECTORY' "File ${filename} is not a directory."
  endTestCase
}

#======================================
# Check if param 2 points to an existing symbolic link
# pointing to a regular file 
#
# @param $1 failure message
# @param $2 file name to check
function assertIsSymLink {
  export lastTestError=0
  msg=$1
  filename=$2
  beginTestCase SymLink "Check if file ${filename} is valid symbolic link"
  [ -L "${filename}" ] || fail "${msg}"  'SYMBOLIC LINK' "File ${filename} is not a symbolic link."
  [ -f $(readlink -f ${filename}) ] || fail "${msg}" 'SYMBOLIC LINK' "File ${filename} does not point to any file"
  endTestCase
}



#======================================
# Check if script/command line execution is successful
#
# @param $1 failure message
# @param $2 command line
function assertScriptOk {
  export lastTestError=0
  msg=$1
  scriptname=$2
  unset IFS
  beginTestCase RunScript "Check if script runs successfully"
  echo "Commande: $scriptname"
  $scriptname || fail "${msg}" 'SCRIPT' "Command '${scriptname}' failed to execute."
  endTestCase 
}



#======================================
# Check if SQL command on the given database returns the expected number of lines
#
# @param $1 failure message
# @param $2 postgresql database
# @param $3 sql script to run. 
# @param $4 expected number of lines
# @param $5 optional PostgreSQL database user (defaults to postgres)
# @param $6 optional PostgreSQL database server host IP Address (defaults to 127.0.0.1)
# @param $7 optional PostgreSQL database server tcp port (defaults to 5432)
function assertPgSQLLines {
  export lastTestError=0
  msg=$1
  database=$2
  # TODO: escape SQL 
  sql=$(echo "$3" | sed -e 's/\\/\\\\/g' -e 's/\"/\\\"/g')
  expLines=$4

  sqlUser=postgres
  if [ "" != "$5" ]; then
    sqlUser=$5
  fi

  sqlHost=127.0.0.1
  if [ "" != "$6" ]; then
    sqlHost=$6
  fi

  sqlPort=5432
  if [ "" != "$7" ]; then
    sqlPort=$7
  fi

  beginTestCase SQLCountLines "Check number of returned lines for ${sql}"
  lines=$(psql -U ${sqlUser} -h ${sqlHost} -p ${sqlPort} -d ${database} -c "${sql}" -Aqt | wc -l) 
  [ $expLines -eq $lines ] || fail "$msg" 'SQL RESULTS COUNT' "SQL Script [ ${sql} ] returned invalid rows count: $lines (expected: $expLines)."
  # psql ...
  endTestCase
}

# assertUserId
# Checks if a user has the expected UID.
# 
function assertUserId {
  export lastTestError=0
  msg=$1
  user=$2
  expuid=$3
  actuid=$(id -u $user) >> /dev/null 2>&1
  if [ '' == "$actuid" ]; then 
#    echo "User does not exist. Test is skipped"
    return;
  fi
  beginTestCase UserID "Check user ID for $user"
  if [ "$expuid" != "$actuid" ]; then
    fail "$msg" 'USER ID' "User ID for account $user is $actuid (expected: $expuid)."
  fi
  endTestCase
}


#
# Check if file is owned by provided user
# 
function assertFileOwner {
  export lastTestError=0
  msg=$1
  file=$2
  if [ ! -e $file ]; then
    echo "File $file does not exist, skipping test"
    return
  fi
  expOwner=$(id -u $3)
  if [ '' == "$expOwner" ]; then
    echo "Bad owner provided. Skipping test"
    return
  fi
  
  # get owner number

  beginTestCase Ownership "Check ownership for ${file} is to ${expOwner}" 
  owner=$(stat -c %u $file)
  if [ $expOwner != $owner ]; then
    fail "$msg" 'FILE OWNER' "Owner of '$file' is $owner (expected: $expOwner)"
  fi
  endTestCase
}

function assertFileGroup {
  echo "not implemented"
}

function assertFileMaxPerms {
  echo "not implemented"
}

function assertFilesOwner {
  unset IFS
  for fic in $(find $2 -type f); do
    assertFileOwner "$1" $fic "$3"
  done
}

function assertFilesGroup {
  unset IFS
  for fic in $(find $2 -type f); do
    assertFileGroup "$1" $fic "$3"
  done
}

function assertFilesMaxPerms {
  unset IFS
  for fic in $(find $2 -type f); do
    assertFileMaxPerms "$1" $fic "$3"
  done
}

#======================================
# Export public functions to allow
# scripts to use them.
export -f beginTestSuite
export -f endTestSuite
export -f assertNotEmpty
export -f assertEmpty
export -f assertEquals
export -f assertDiffers
export -f assertExists
export -f assertIsFile
export -f assertIsDirectory
export -f assertIsSymLink
export -f assertScriptOk
export -f assertPgSQLLines
export -f assertFileOwner
export -f assertFileGroup
export -f assertFileMaxPerms
export -f assertFilesOwner
export -f assertFilesGroup
export -f assertFilesMaxPerms

