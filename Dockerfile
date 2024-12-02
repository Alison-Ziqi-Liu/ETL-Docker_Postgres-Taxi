FROM python:3.9.1
RUN apt-get install wget
RUN pip install pandas==2.0.0
RUN pip install sqlalchemy 
RUN pip install psycopg2
RUN pip install pyarrow
RUN pip install numpy==1.26.4

WORKDIR /app
COPY ingest_data.py ingest_data.py

ENTRYPOINT [ "python","ingest_data.py" ]