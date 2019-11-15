FROM arm32v7/ubuntu

WORKDIR /sensor

COPY . ./
RUN apt-get update
RUN apt-get install -y alsa-utils redis-tools  sndfile-programs 

ENTRYPOINT ["bash", "/sensor/soundMeter.sh"]
