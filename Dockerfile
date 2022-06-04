FROM comses/osg-julia:1.7.3

ENV JULIA_LOAD_PATH=/code:

WORKDIR /code
COPY . /code

RUN julia /code/install.jl && \
    chmod -R go+r /opt/julia/share/julia/compiled

