FROM comses/osg-julia:1.7.3

ENV JULIA_LOAD_PATH=/code:
ENV JULIA_DEPOT_PATH=/code/.julia:/opt/julia/share/julia

WORKDIR /code
COPY . /code

RUN julia /code/install.jl && \
    chmod -R go+rX /opt/julia/share/julia /code

