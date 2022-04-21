FROM postgis/postgis:13-master

RUN apt-get update \
    && apt-get install postgresql-contrib postgresql-plpython3-13 -y \
    && apt-get install python3 -y \
    && apt-get install python3-pip -y \
    && pip install psycopg2-binary \
    && pip install pyquaternion \
