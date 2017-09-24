#!/bin/bash
#
#==============================================================================
#
# BASH UNIT Testing library Sample script
#------------------------------------------------------------------------------
# Description: 
#    This simple script demonstrates how to use the bashunit.sh functions library.
#
# Version: 1.0.0
# Author: TriYop
#==============================================================================

source ./bashUnit.sh

beginTestSuite

# Checks if current dir is a directory
assertNotEmpty "Current directory is an empty string" "$(pwd)"
assertExists "Current directory should exist" "$(pwd)"
assertIsDirectory "Current directory is a directory" "$(pwd)"

# Failing test: check if current directory is a file
assertIsFile "Current directory not Expected to be a file => test should fail" "$(pwd)"


endTestSuite

