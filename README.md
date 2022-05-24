# [FCC Periodic Table](https://www.freecodecamp.org/learn/relational-database/build-a-periodic-table-database-project/build-a-periodic-table-database)

This was put together for the Relational Database (Beta) course on [FCC](https://www.freecodecamp.org/learn/relational-database/). 
The aim was to:
* alter the schema of a PostgreSQL database
* create an interactive Bash program that uses a PostgreSQL database.
* use version control on the interactive Bash program

## Project Improvements

I have extended this project in the following ways:
* local development with Docker

## Setup

Clone the Repository

```
$ git clone git@github.com:normanrichardson/FCC-Periodic-Table.git
$ cd FCC-Periodic-Table
```

### Running postgres with Docker:
Using the standard postgres docker image create the container:
```
$ docker run --name=periodic-table-proj \
-e POSTGRES_USER=freecodecamp \
-e POSTGRES_PASSWORD=1234 \
-e POSTGRES_DB=periodic_table \
-v "$(pwd)"/.:/home \
-d \
--rm \
postgres:latest
```
This will:
* launch a new container named periodic-table-proj in the background (see `$ docker ps`). 
* remove the container after stopping it.
* map the `./` directory onto the container's directory `home`. 
The mapped files are accessible within the container and the host.

Launch psql in the periodic-table-proj container and redirect the `periodic_table_start.sql` file:
```
$ docker exec -it -w /home/src/ periodic-table-proj \
psql -U freecodecamp -d periodic_table -f periodic_table_start.sql
```
This will initialise the data for the project.


Launch psql in the periodic-table-proj container and run the `sql_component.sql` file:
```
$ docker exec -it -w /home/src/ periodic-table-proj \
psql -U freecodecamp -d periodic_table -f sql_component.sql
```
This will perform the project specific updates to the database.

Run the `git_component.sh` bash script on the host in the project folder
```
./src/git_component.sh
```
This will initialize the project specific git repositiory, create branches and commits in the `periodic_table` folder.

Run the `element.sh` bash script on the container with arguments (here He):
```
$ docker exec -it -w /home/periodic_table periodic-table-proj \
./element.sh He
```

Dump the file as required by the project description
```
$ docker exec -i -w /home/ periodic-table-proj \
pg_dump -cC --inserts -U freecodecamp periodic_table > periodic_table.sql
```

Stop the container
```
docker stop periodic-table-proj
```
