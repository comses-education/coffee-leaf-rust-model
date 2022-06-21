FROM comses/osg-julia:1.7.3

WORKDIR /code
COPY . /code

RUN mkdir -p /results && julia install.jl 

