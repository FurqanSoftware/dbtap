# DBTap

A simple contraption for taking automated backups of a remote MongoDB instance, uploading it to Amazon S3 and generating anonymized copy of the database.

## How It Works

1. Connects to a remote host through SSH.
2. Creates a MongoDB database dump.
3. Creates a Tarball of the dump directory.
4. Downlods the tarball.
5. Removes the tarball and dump directory from the remote host.
6. Uploads the tarball to bucket in Amazon S3.
7. Anonymizes the dump. (This is done by importing the database to a temporary MongoDB instance and running a JavaScript file through the MongoDB shell. You can remove sensitive information from the dump.)
8. Exports the anonymized dump as a GitLab artifact that developers can download.

Bonus: You can schedule automatic regular backups through GitLab pipeline with the help of the .gitlab-ci.yml file.
