FROM python:3.8-bullseye

ARG PACKAGES="ffmpeg build-essential unzip gcsfuse"

ARG DEBIAN_FRONTEND=noninteractive
RUN \
    echo "deb https://packages.cloud.google.com/apt gcsfuse-bullseye main" | tee /etc/apt/sources.list.d/gcsfuse.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -qq $PACKAGES && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install poetry 

WORKDIR /app

# Clone the repository and download assets
RUN mkdir audioclip
RUN cd audioclip 
RUN wget https://zenodo.org/record/7969521/files/assets.zip?download=1 
RUN unzip ./assets.zip?download=1 
RUN cd ../

# Package install
COPY . ./
RUN poetry config virtualenvs.create false
RUN poetry install --no-root



ENV PYTHONPATH "${PYTHONPATH}:/app:/app/audioclip:/app:/app/src"
ENTRYPOINT [ "./entrypoint.sh" ]

