#!/bin/zsh

### please do NOT run this script directly
### this file should be run by yarn init-app in root workspace

ANSI_RED='\x1b[31m'
ANSI_GREEN='\x1b[32m'
ANSI_YELLOW='\x1b[33m'
ANSI_BLUE='\x1b[34m'
ANSI_RESET='\x1b[0m'

ERR_HEAD="[${ANSI_RED}ERR${ANSI_RESET}]"
INFO_HEAD="[${ANSI_BLUE}INFO${ANSI_RESET}]"
WARN_HEAD="[${ANSI_YELLOW}WARN${ANSI_RESET}]"
NOMAL_HEAD="[${ANSI_GREEN}NOMAL${ANSI_RESET}]"

SHARED_PATH='./packages/shared/.env.local'
SERVER_PATH='./packages/server/.env.local'
WEB_PATH='./packages/solid_web/.env.local'
ELECTRON_PATH='./packages/electron_app/.env.local'

# all .env file will have this variable
DOYA_MODE='development'

# server .env variable
DOYA_SERVER_PORT='3194'
DB_TYPE='mysql'
DB_USER='root'
DB_PASS=''
DB_HOST='localhost'
DB_PORT='3306'
DB_NAME='youdoya'
DB_URL="${DB_TYPE}://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
DOYA_FIREBASE_SECRET_JSON=''

# electron .env variable
WEB_APIKEY=''
WEB_AUTH_DOMAIN=''
WEB_PROJECT_ID=''
WEB_STORAGE_BUCKET=''
WEB_MSG_SENDER_ID=''
WEB_APP_ID=''

create_dotenv() {
  if [ $# -ne 1 ]; then
    echo "${ERR_HEAD} create dotenv argument incorrect."
    return 1
  fi

  if ! echo '# do NOT edit this file.' >"$1"; then
    echo "${ERR_HEAD} create .env file comment line 1 error"
    return 1
  fi

  if ! echo '# This file is created automatically by run yarn init-app.' >>"$1"; then
    echo "${ERR_HEAD} create .env file comment line 2 error"
    return 1
  fi

  if ! echo "DOYA_ROOT=$(pwd)" >>"$1"; then
    echo "${ERR_HEAD} create .env file DOYA_ROOT error"
    return 1
  fi

  if ! echo "DOYA_MODE=${DOYA_MODE}" >>"$1"; then
    echo "${ERR_HEAD} create .env file DOYA_MODE error"
    return 1
  fi

  return 0
}

set_server_port() {
  echo "${INFO_HEAD} please input a server listening port:"
  vared -r '(default=3194) ' DOYA_SERVER_PORT
  echo "${NOMAL_HEAD} server will listen on port: ${DOYA_SERVER_PORT}"
}

set_prisma_url() {
  echo "${NOMAL_HEAD} will start to init prisma database connection setting..."

  echo "${INFO_HEAD} datebase type: "
  vared -r '(default=mysql) ' DB_TYPE

  echo "${INFO_HEAD} database user name:"
  vared -r '(default=root) ' DB_USER

  echo "${INFO_HEAD} databse user password:"
  vared -r '(default=empty) ' DB_PASS

  echo "${INFO_HEAD} database hostname:"
  vared -r '(default=localhost) ' DB_HOST

  echo "${INFO_HEAD} database port:"
  vared -r '(default=3306) ' DB_PORT

  echo "${INFO_HEAD} database name which you want to use:"
  vared -r 'default=(youdoya) ' DB_NAME

  # change DB_URL with input value
  DB_URL="${DB_TYPE}://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
  echo "your db url is: (${DB_URL}), is OK? [y/n]: "
  while read "DB_OK"; do
    case $DB_OK in
    [Yy]) {
      return 0
    } ;;
    [Nn]) {
      echo "${WARN_HEAD} you say no, please check the database url and run this script again."
      return 1
    } ;;
    *) {
      echo "please answer with Yy or Nn"
    } ;;
    esac
  done
}

set_server_firebase_secret_json() {
  echo "${INFO_HEAD} please input the firebase secret credential json file name (include file extention):"
  vared -rc '(example: my_secret.json) ' SECRET_JSON_NAME
  DOYA_FIREBASE_SECRET_JSON = "$(pwd)/packages/server/${SECRET_JSON_NAME}"
  echo "absolute path to your secret file will be: (${DOYA_FIREBASE_SECRET_JSON}), is OK? [y/n]: "
  while read "SERVER_FIREBASE_OK"; do
    case $SERVER_FIREBASE_OK in
    [Yy]) {
      return 0
    } ;;
    [Nn]) {
      echo "${WARN_HEAD} you say no, please check the filename and run this script again."
      return 1
    } ;;
    *) {
      echo "please answer with Yy or Nn"
    } ;;
    esac
  done
}

set_electron_firebase_apikey() {
  echo "${INFO_HEAD} please input expose firebase borwser apikey:"
  vared WEB_APIKEY
  echo "[${ANSI_YELLOW}NOTICE${ANSI_RESET}] you will expose this key to everyone: (${WEB_APIKEY})"
  echo "[${ANSI_YELLOW}NOTICE${ANSI_RESET}] please make sure it is secure, is OK? [y/n]"
  while read "APIKEY_OK"; do
    case $APIKEY_OK in
    [Yy]) {
      return 0
    } ;;
    [Nn]) {
      echo "${WARN_HEAD} you say no, please check the port and run this script again."
      return 1
    } ;;
    *) {
      echo "please answer with Yy or Nn"
    } ;;
    esac
  done
}

set_electron_firebase_config() {
  echo "${NOMAL_HEAD} will start setting firebase config, if you don't know what is this, please check your firebase project setting."

  echo "${INFO_HEAD} please input firebase authentication domain:"
  vared WEB_AUTH_DOMAIN

  echo "${INFO_HEAD} please input firebase project id:"
  vared WEB_PROJECT_ID

  echo "${INFO_HEAD} please input firebase storage bucket:"
  vared WEB_STORAGE_BUCKET

  echo "${INFO_HEAD} please input firebase message sender id:"
  vared WEB_MSG_SENDER_ID

  echo "${INFO_HEAD} please input firebase app id:"
  vared WEB_APP_ID

  echo "${NOMAL_HEAD} your electron app will use follow setting to init firebase:"
  echo "{"
  echo "  authDomain: ${WEB_AUTH_DOMAIN}"
  echo "  projectId: ${WEB_PROJECT_ID}"
  echo "  storageBucket: ${WEB_STORAGE_BUCKET}"
  echo "  messageSenderId: ${WEB_MSG_SENDER_ID}"
  echo "  appId: ${WEB_APP_ID}"
  echo "}"

  echo "is OK? [y/n]"
  while read "FIREBASE_OK"; do
    case $FIREBASE_OK in
    [Yy]) {
      return 0
    } ;;
    [Nn]) {
      echo "${WARN_HEAD} you say no, please check the your firebaes config and run this script again."
      return 1
    } ;;
    *) {
      echo "please answer with Yy or Nn"
    } ;;
    esac
  done
}

init_server() {
  if ! create_dotenv $SERVER_PATH; then
    echo "${ERR_HEAD} create server .env file error"
    return 1
  fi

  # read value from user input
  if ! set_server_port; then
    echo "${ERR_HEAD} set server port error"
    return 1
  fi
  if ! set_prisma_url; then
    echo "${ERR_HEAD} set prisma url error"
    return 1
  fi
  if ! set_server_firebase_secret_json; then
    echo "${ERR_HEAD} set server firebase secret json error"
    return 1
  fi

  # write value into .env file
  if ! echo "DOYA_SERVER_PORT=${DOYA_SERVER_PORT}" >>"$SERVER_PATH"; then
    echo "${ERR_HEAD} write server port to .env file error"
    return 1
  fi
  if ! echo "DOYA_DB_URL=${DB_URL}" >>"${SERVER_PATH}"; then
    echo "${ERR_HEAD} write db url to .env file error."
    return 1
  fi
  if ! echo "DOYA_FIREBASE_SECRET_JSON=${DOYA_FIREBASE_SECRET_JSON}" >>"${SERVER_PATH}"; then
    echo "${ERR_HEAD} write server filebase secret json to .env file error."
    return 1
  fi

  return 0
}

init_electron() {
  if ! create_dotenv $ELECTRON_PATH; then
    echo "${ERR_HEAD} create electron .env file error"
    return 1
  fi

  # read value from user input
  if ! set_electron_firebase_apikey; then
    echo "${ERR_HEAD} set electron firebase apikey error"
    return 1
  fi
  if ! set_electron_firebase_config; then
    echo "${ERR_HEAD} set electron fireabse config error"
    return 1
  fi

  # write value into .env file
  if ! echo "WEB_APIKEY=${WEB_APIKEY}" >>"${ELECTRON_PATH}"; then
    echo "${ERR_HEAD} write electron firebase apikey to .env file error"
    return 1
  fi
  if ! echo "WEB_AUTH_DOMAIN=${WEB_AUTH_DOMAIN}" >>"${ELECTRON_PATH}"; then
    echo "${ERR_HEAD} write electron auth domain to .env file error"
    return 1
  fi
  if ! echo "WEB_PROJECT_ID=${WEB_PROJECT_ID}" >>"${ELECTRON_PATH}"; then
    echo "${ERR_HEAD} write electron project id to .env file error"
    return 1
  fi
  if ! echo "WEB_STORAGE_BUCKET=${WEB_STORAGE_BUCKET}" >>"${ELECTRON_PATH}"; then
    echo "${ERR_HEAD} write electron storage bucket to .env file error"
    return 1
  fi
  if ! echo "WEB_MSG_SENDER_ID=${WEB_MSG_SENDER_ID}" >>"${ELECTRON_PATH}"; then
    echo "${ERR_HEAD} write electron message sender id to .env file error"
    return 1
  fi
  if ! echo "WEB_APP_ID=${WEB_APP_ID}" >>"${ELECTRON_PATH}"; then
    echo "${ERR_HEAD} write electron app id to .env file error"
    return 1
  fi

  return 0
}

init_web() {
  if ! create_dotenv $WEB_PATH; then
    return 1
  fi

  return 0
}

select_mode() {
  echo "${INFO_HEAD} please select the application mode with [p(production) / d(development)]"
  while read "SELECT_MODE"; do
    case $SELECT_MODE in
    [Pp]) {
      DOYA_MODE='production'
      echo "${NOMAL_HEAD} youdoya will running in ${DOYA_MODE} mode."
      return 0
    } ;;
    [Dd]) {
      DOYA_MODE='development'
      echo "${NOMAL_HEAD} youdoya will running in ${DOYA_MODE} mode."
      return 0
    } ;;
    *) {
      echo "please answer with Pp or Dd"
    } ;;
    esac
  done
}

main() {
  echo "[${ANSI_GREEN}START${ANSI_RESET}] init start..."
  # make logs directory for server write log to file
  if [ ! -d "./logs" ]; then
    mkdir logs
  fi

  if ! select_mode; then
    exit 1
  fi

  if ! init_server; then
    exit 1
  fi

  if ! init_electron; then
    exit 1
  fi

  if ! init_web; then
    exit 1
  fi

  echo "[${ANSI_GREEN}DONE${ANSI_RESET}] init app successfully."
  exit 0
}

main
