FROM debian:12.9

RUN apt-get -y update && apt-get -y install nasm binutils gdb make

WORKDIR /app
COPY . /app/
COPY tests /app/tests
COPY libs /app/libs

RUN make

ENTRYPOINT ["make", "tests"]