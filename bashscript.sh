docker compose up -d 

docker build -t ingest_python:v01 .

docker run -it \
    --network=2_docker_sql_default \
    ingest_python:v01 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=ny_taxi \
    --tb=green_taxi_trips \
    --url='https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2019-09.parquet'    

docker run -it \
    --network=2_docker_sql_default \
    ingest_python:v01 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=ny_taxi \
    --tb=taxi_zone \
    --url='https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv'    