FROM comses/osg-julia:1.7.3

ENV JULIA_LOAD_PATH=:/code
ENV JULIA_DEPOT_PATH=:/code

WORKDIR /code
COPY scripts src Manifest.toml Project.toml LICENSE README.md install.jl /code/

RUN julia --project=/code /code/install.jl && \
    chmod -R go+rX /opt/julia/share/julia /code && \
    mkdir results

