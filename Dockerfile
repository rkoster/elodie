FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends ca-certificates libimage-exiftool-perl python2.7 python-pip python-pyexiv2 wget make && \
    pip install --upgrade pip setuptools && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*


RUN wget http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-10.20.tar.gz && \
    gzip -dc Image-ExifTool-10.20.tar.gz  | tar -xf - && \
    cd Image-ExifTool-10.20 && perl Makefile.PL && \
    make install && cd ../ && rm -r Image-ExifTool-10.20

COPY requirements.txt /opt/elodie/requirements.txt
COPY docs/requirements.txt /opt/elodie/docs/requirements.txt
COPY elodie/tests/requirements.txt /opt/elodie/elodie/tests/requirements.txt
WORKDIR /opt/elodie
RUN pip install -r docs/requirements.txt && \
    pip install -r elodie/tests/requirements.txt && \
    rm -rf /root/.cache/pip

COPY . /opt/elodie

CMD ["/bin/bash"]
