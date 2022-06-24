FROM comses/osg-julia:1.7.3

LABEL maintainer="CoMSES Net <support@comses.net>"

ENV JULIA_DEPOT_PATH=/opt/julia/share/julia

WORKDIR /code
COPY install.jl *.toml /code
RUN julia install.jl && \
    chmod -R a+rX /opt/julia/share/julia

# now copy the rest of the things over
COPY . /code
