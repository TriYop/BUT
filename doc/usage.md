# bashUnit
## What is it about

bashUnit is a simple library designed for continuous integration pipelines integration of bash based tests
which generate xUnit compatible XML reports. Those reports may be deployed into CI orchestrator dashboard.

## How to use it ?

to use this library, you will need to import bashUnit.sh into your test script.

    #!/usr/bin/env bash
    source bashUnit.sh
    
    beginTestSuite
    # Here come all your tests and assertions
    endTestSuite

## What kind of assertions my I use ?
### String based assertions

#### assertNotEmpty

> Checks if actual value is not empty (String length is more than 0)

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
actual value | String | Value that is expected not to be empty


#### assertEmpty

> Checks if actual value is empty (String length is 0)

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
actual value | String | Value that is expected to be empty


#### assertEquals

> Checks if actual value is the same as the reference one.

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
reference value | String | Reference value
actual value | String | Value to be checked


#### assertDiffers

> Checks if actual value is different from the reference one

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
reference value | String | Reference value
actual value | String | Value to be checked


### FileSystem based assertions
#### assertExists

> Checks if provided file name refers to an existing file or directory (filesystem entry)

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
file name | String | File name to be checked

#### assertIsFile

> Checks if provided file name refers to a regular file (neither a directory, nor a symlink, ...)

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
file name | String | File name to be checked

#### assertIsReadableFile

> Checks if provided file name refers to a readable file

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
file name | String | File name to be checked

#### assertIsDirectory

> Checks if provided file name refers to a directory

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
file name | String | File name to be checked

#### assertIsSymLink

> Checks if provided file name refers to a symbolic link

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
file name | String | File name to be checked

### Process / DB results assertions
#### assertScriptOk

> Checks if provided script runs and returns 0 on exit

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
script name | String | Name of the script to be checked

#### assertPgSQLLines

> Checks if the provided SQL query returns the expected number of lines
> 
> This assertion expects the database to handle "trusted" account for testing purpose.

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
database name | String | PostgreSQL database Name
SQL query | String | SQL Query to run on the provided database
expected lines | Integer | number of lines expected to be returned by SQL query
*database user* | String | user name to connect database. Defaults to `postgres`
*database address* | String | database server address, IP or FQDN. Defaults to `127.0.0.1`
*database port* | Integer | database server listening port. Defaults to `5432`

### System configuration assertions
#### assertUserId

> Checks if user with provided name has expected UID

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
user name | String | User *login* name
user UID | Integer | User numerical UID

#### assertFileOwner

> Checks if provided file is owned by the expected owner

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
file name | String | File name to be checked
user | String | User name or UID who should be owner of the file

#### assertFileGroup

> Checks if file belongs to the expected group
>
> *Not yet implemented*

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
file name | String | File name to be checked
group | String |  Group name or GID that should own the file

#### assertFileMaxPerms

> Checks if file permissions are at least as restrictive as provided
>
> *Not yet implemented*

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
file name | String | File name to be checked
permission | String | Expected filesystem permissions provided as numeric octal value: 0000 to 7777


### Batch checks
#### assertFilesOwner

> Checks if all files in the provided directory have the same provided owner.

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
dir name | String | directory where files will be checked
user | String | User name or UID who should be owner of the files

#### assertFilesGroup

> Checks if all files in the provided directory have the same provided group.
>
> *Not yet implemented*

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
dir name | String | directory where files will be checked
group | String | Group name or GID that should own all files in the directory

#### assertFilesMaxPerms

> Checks if permissions on all files in the provided directory ar at least as restrictive as the provided one.
>
> *Not yet implemented*

Parameter | Type | Description
--- | --- | --
failure message | String | failure message that comes along the failure notice
dir name | String | directory where files will be checked
permission | String | Expected filesystem permissions provided as numeric octal value: 0000 to 7777















