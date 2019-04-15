FROM ubuntu:18.04

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get update &&\
    apt-get install -y software-properties-common apt-utils &&\
    add-apt-repository ppa:git-core/ppa &&\
    apt-get update &&\
    apt-get install -y git make wget vim

RUN apt-get install -y openjdk-8-jdk && \
	update-alternatives --config java && \
	apt-get install unzip gcc python python3 python3-pip -y

RUN apt-get install -y libaio-dev
RUN mkdir -p /diobench/

COPY requirements.txt /diobench/

WORKDIR /diobench
RUN pip3 install -r requirements.txt

# TODO
RUN cd /diobench && git clone https://github.com/xdatanext/ddct.git
#RUN cd /diobench/ddct && ./install.py 
RUN cd /diobench && git clone https://github.com/xdatanext/dbmp.git
#RUN cd /diobench/dbmp && ./install.py 

# vdbench
RUN mkdir -p /diobench/vdbench
# TODO: Need a direct URL from Oracle here
#COPY vdbench50407.zip /diobench/vdbench
#RUN cd /diobench/vdbench && unzip vdbench50407.zip 

# fio
RUN cd /diobench && git clone https://github.com/axboe/fio.git
RUN cd /diobench/fio && ./configure
RUN cd /diobench/fio && make
RUN cd /diobench/fio && make install
RUN cd /diobench/fio && make clean
RUN cd /diobench && rm -rf fio 

COPY diobench /bin
RUN mkdir /data

COPY fiorun/ /diobench/fiorun/
COPY vdbrun/ /diobench/vdbrun/

# Removed unnecessary packages
RUN apt-get autoremove -y
# Clear package repository cache
RUN apt-get clean all

ENTRYPOINT ["tail", "-f", "/dev/null"]
