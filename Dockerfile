# This Dockerfile can be used for testing the script in an isolated environment.
FROM debian

COPY bootstrap .

RUN apt-get update
RUN apt-get install -y sudo
RUN apt-get install -y wget

CMD ["bash"]
