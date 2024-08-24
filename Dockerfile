FROM postgres
ENV POSTGRES_PASSWORD docker
ENV POSTGRES_DB rangers
COPY rangers.sql /docker-entrypoint-initdb.d/
