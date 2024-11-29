#!/bin/bash

if [ -z "$1" ]; then
  echo "Descrição é obrigatória."
  echo "Forma de uso:"
  echo "./scripts/liquibase-template.sh \"Descrição da alteração\""
  exit 1
fi

DESCRIPTION=$1
DEV_USER=$(git config user.name)
BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$BRANCH" == "master" ]; then
  echo "Crie uma branch para usar este comando."
  echo "Exemplo:"
  echo "git checkout -b <nome-branch>"
  exit 1
fi

XML_FILE="liquibase/changelog/${BRANCH}.xml"
SQL_FILE="liquibase/scripts/${BRANCH}.sql"

cat <<EOL >"$XML_FILE"
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-3.5.xsd">
  <changeSet id="${BRANCH}" author="${DEV_USER}">
    <comment>${DESCRIPTION}</comment>
    <sqlFile path="${SQL_FILE}" encoding="UTF-8" relativeToChangelogFile="false"/>
  </changeSet>
</databaseChangeLog>
EOL

touch "$SQL_FILE"
# code "./$XML_FILE" "./$SQL_FILE" # Descomentar esta ultima linha caso queira abrir o arquivo no VSCode
