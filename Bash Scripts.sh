'''replaced with Docker Compose

docker network create pg-network

docker run -it \
    -e POSTGRES_USER='root'\
    -e POSTGRES_PASSWORD="root"\
    -e POSTGRES_DB='ny_taxi'\
    -p 5432:5432\
    --network=pg-network \
    --name pg-database\
    postgres:13

docker run -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -p 8080:80 \
    --network=pg-network \
    --name pgadmin\
    dpage/pgadmin4

'''
docker compose up -d

docker build -t taxi_ingest:v001 .

docker run -it \
    --network=2_docker_sql_default \
    taxi_ingest:v001 \
        --user=root \
        --password=root \
        --host=pgdatabase \
        --port=5432 \
        --db=ny_taxi \
        --tb=yellow_taxi_trips \
        --url="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet"
