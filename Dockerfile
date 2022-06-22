FROM comses/osg-julia:1.7.3

ENV JULIA_DEPOT_PATH=/opt/julia/share/julia

WORKDIR /code
COPY . /code

RUN julia install.jl && \
    chmod -R a+rX /opt/julia/share/julia
