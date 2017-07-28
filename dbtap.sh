#!/bin/sh

SSH_HOST=$1

DB_NAME=$2
DB_USER=$3
DB_PASS=$4

S3_BUCKET_NAME=$5

TMP_DB_HOST=$6

TAP_ID=`date +'%y-%m-%d_%H-%M-%S'`
DUMPDIR_NAME=${DB_NAME}_dump_${TAP_ID}
TARBALL_NAME=$DUMPDIR_NAME.tar.gz
ANONDIR_NAME=${DUMPDIR_NAME}_anonymized
TARANON_NAME=$ANONDIR_NAME.tar.gz

# Create dump tarball
ssh $SSH_HOST 'bash -s' <<EOF
	mongodump -d $DB_NAME --authenticationDatabase $DB_NAME -u $DB_USER -p $DB_PASS -o $DUMPDIR_NAME
	tar czvf $TARBALL_NAME $DUMPDIR_NAME
EOF

# Download dump tarball
scp $SSH_HOST:$TARBALL_NAME $TARBALL_NAME

# Remove dump tarball
ssh $SSH_HOST 'bash -s' <<EOF
	rm -r $TARBALL_NAME $DUMPDIR_NAME
EOF

# Upload to S3
aws s3 cp $TARBALL_NAME s3://$S3_BUCKET_NAME/mongodb/$TARBALL_NAME

# Create anonymized dump tarball
tar xzf $TARBALL_NAME
mongorestore -h $TMP_DB_HOST -d $DB_NAME $DUMPDIR_NAME/$DB_NAME
mongo < anonymize.js
mongodump -h $TMP_DB_HOST -d $2 -o ${ANONDIR_NAME}
tar czvf ${TARANON_NAME} ${ANONDIR_NAME}
