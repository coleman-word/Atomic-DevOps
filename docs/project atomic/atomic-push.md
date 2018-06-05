NAME
atomic-push - push Image to repository

SYNOPSIS
atomic push [-a][--activation_key[=ACTIVATION_KEY]] [--anonymous] [--debug] [-h|--help] [--insecure] [--pulp] [-p][--password[=PASSWORD]] [-r][--repository_id[=REPOSITORY_ID]] [--satellite] [--sign-by] [--t][--type] [-u][--username[=USERNAME]] [-U][--url[=URL]] [--verify_ssl[=VERIFY_SSL]]

DESCRIPTION
atomic push will push the image to the repository. Defaults to docker repository; can also upload to satellite or pulp repository.

OPTIONS:
-a ACTIVATION_KEY --activation_key ACTIVATION_KEY Activation Key

--anonymous Push without a username or password

--debug Debug mode

-h --help Print usage statement

--insecure Indicate that the regsitry does not require HTTPS or certificate verification.

-p PASSWORD --password PASSWORD Password for remote registry

--pulp Push using the pulp protocol, defaults to using docker push

--r REPO_ID --repository_id REPO_ID Repository ID

--satellite Upload using the satellite protocol; defaults to using docker push

--sign-by Override the default signing identity defined in /etc/atomic.conf. Atomic push will always sign if there is a default identity or you pass an indentity here. If there is a default identity, you can pass None to --sign-by and signing will be disabled.

-t REGISTRY_TYPE --type REGISTRY_TYPE Change the registry type, docker|atomic. atomic registry type is an OpenShift-based registry with an API supporting image signatures. Default is docker.

-u USERNAME --username USERNAME Username for remote registry

-U URL --url URL URL for remote registry

--verify_ssl Flag to verify ssl of registry

