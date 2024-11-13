FROM amazonlinux:2

RUN yum update -y
RUN yum erase openssl-devel -y
RUN yum install wget tar gzip zip gcc make openssl11 openssl11-devel libffi-devel bzip2-devel mesa-libGL -y

# Install Python 3.11
WORKDIR /
RUN wget https://www.python.org/ftp/python/3.12.6/Python-3.12.6.tgz
RUN tar -xzvf Python-3.12.6.tgz
WORKDIR /Python-3.12.6
RUN ./configure --prefix=/usr --enable-optimizations
RUN make -j $(nproc)
RUN make altinstall

# Install Python packages
RUN mkdir /packages
RUN mkdir -p /packages/opencv-python-3.12/python/lib/python3.12/site-packages
RUN pip3.12 install opencv-python-headless  -t /packages/opencv-python-3.12/python/lib/python3.12/site-packages

# Create zip files for Lambda Layer deployment
WORKDIR /packages/opencv-python-3.12/
RUN zip -r9 /packages/opencv-python-312.zip .
WORKDIR /packages/
RUN rm -rf /packages/opencv-python-3.12/
