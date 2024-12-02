import pandas as pd 
import pyarrow.parquet as pq
import argparse, os, sys
from sqlalchemy import create_engine
import os

def main(params):
    #arguments
    user=params.user
    password=params.password
    host=params.host
    port=params.port
    db=params.db
    url=params.url
    tb=params.tb 

    #read file
    file_name = url.rsplit('/', 1)[-1].strip()
    os.system(f'curl {url.strip()} -O {file_name}')

    if '.csv' in file_name:
        df_r1=pd.read_csv(file_name,nrows=1)
        batches=pd.read_csv(file_name,iterator=True,chunksize=100000)
    elif '.parquet' in file_name:
        pf=pq.ParquetFile(file_name)
        df_r1=next(pf.iter_batches(batch_size=1)).to_pandas()
        batches=pf.iter_batches(batch_size=100000)
    else:
        print('Error: only csv/parquet file')
        sys.exit()

    #create table (with pandas df)
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    df_r1.head(0).to_sql(name=tb,con=engine,if_exists='replace')

    #insert data
    t=0
    for batch in batches:
        t+=1

        if '.csv' in file_name:
            batch_df = batch
        else:
            batch_df = batch.to_pandas()

        print(f'inserting batch {t}...')
        batch_df.to_sql(name=tb,con=engine,if_exists='append')
    
    print('inserted!')

if __name__=='__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--user')
    parser.add_argument('--password')
    parser.add_argument('--host')
    parser.add_argument('--port')
    parser.add_argument('--db')
    parser.add_argument('--url')
    parser.add_argument('--tb')
    args=parser.parse_args()

    main(args)
