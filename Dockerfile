FROM postgres
ENV POSTGRES_PASSWORD docker
ENV POSTGRES_DB final-project-db
COPY final-project-db.sql /docker-entrypoint-initdb.d/ 
# bruv if u want change the file name change the filename in the line above as well
