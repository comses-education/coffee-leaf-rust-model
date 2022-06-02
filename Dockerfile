FROM comses/osg-julia

WORKDIR /code
COPY . /code

RUN julia /code/install.jl && \
    chmod -R go+r /opt/julia/share/julia/compiled

