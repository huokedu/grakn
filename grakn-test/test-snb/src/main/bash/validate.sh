#!/bin/bash

source snb-env.sh

LDBC_VALIDATION_CONFIG=${WORKSPACE}/grakn-test/test-snb/src/main/bash/readwrite_grakn--ldbc_driver_config--db_validation.properties

# execute validation
mvn install -DskipTests --also-make --projects grakn-test/test-snb
mvn exec:java --projects grakn-test/test-snb -Dexec.mainClass=com.ldbc.driver.Client -Dexec.args="
    -db ai.grakn.GraknDb \
    -P ${LDBC_VALIDATION_CONFIG} \
    -vdb ${CSV_DATA}/validation_params.csv \
    -p ldbc.snb.interactive.parameters_dir ${CSV_DATA} \
    -p ai.grakn.uri ${ENGINE} \
    -p ai.grakn.keyspace ${KEYSPACE}"

# check for errors from LDBC
FAILURES=$(cat ${CSV_DATA}/validation_params-failed-actual.json)
if [ "${FAILURES}" == "[ ]" ]; then
        echo "Validation completed without failures."
else
        echo "There were failures during validation."
        echo ${FAILURES}
        exit 1
fi
