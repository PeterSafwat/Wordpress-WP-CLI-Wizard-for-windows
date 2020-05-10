@ECHO OFF
::Download WP-CLI
ECHO Downloading WP-CLI ...
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

:: Get User Parameters
SETLOCAL
:setProjectName
set projectName=
set /p projectName="Project Name(Defaults to wordpress): "
IF NOT DEFINED projectName GOTO :continueToParameters
echo.%projectName%| findstr /R "[^a-zA-Z0-9-]" >nul 2>&1
if ErrorLevel 1 (
 GOTO :continueToParameters
) ELSE (
 echo %projectName% - Is invalid, spaces or special characters are not allowed.
)
goto :setProjectName

:: Continue with parameters
:continueToParameters
set /p databaseName="Database Name(Defaults to project name): "
set /p databaseUser="Database User(Defaults to root): "
set /p databasePass="Database Pass(Defaults to empty): "
set /p databaseHost="Database Host(Defaults to loclahost): "
set /p siteURL="Site URL(Defaults to project name): "
set /p siteTitle="Site Title(Defaults to project name): "
set /p adminUser="Wordpress Admin User (Defaults to admin): "
set /p adminPass="Wordpress Admin Pass (Defaults to admin): "
set /p adminEmail="Wordpress Admin EMail (Defaults to admin@example.com): "

:: Set Parameters Defaults
IF "%projectName%"=="" (
    set projectName=wordpress
)
IF "%databaseName%"=="" (
    set databaseName=%projectName%
)
IF "%databaseUser%"=="" (
    set databaseUser=root
)
IF "%databasePass%"=="" (
    set databasePass=
)
IF "%databaseHost%"=="" (
    set databaseHost=localhost
)
IF "%siteURL%"=="" (
    set siteURL=%projectName%.test
)
IF "%siteTitle%"=="" (
    set siteTitle=%projectName%
)
IF "%adminUser%"=="" (
    set adminUser=admin
)
IF "%adminPass%"=="" (
    set adminPass=admin
)
IF "%adminEmail%"=="" (
    set adminEmail="admin@example.com"
)

:: Download Wordpress
php wp-cli.phar core download --path=%projectName%

:: Change Directory to Project Folder so the script can execute the next commands.
IF not "%projectName%"=="" (
    cd %projectName%
)

:: Create WP-Config
ECHO Creating Config ...
php ../wp-cli.phar config create --dbname=%databaseName% --dbuser=%databaseUser% --dbpass= --dbhost=%databaseHost%

:: Create DB
ECHO Creating Database ...
php ../wp-cli.phar db create

:: Install Wordpress
ECHO Installing Wordpress ...
php ../wp-cli.phar core install --url=%siteURL% --title=%siteTitle% --admin_user=%adminUser% --admin_password=%adminPass% --admin_email=%adminEmail%

PAUSE