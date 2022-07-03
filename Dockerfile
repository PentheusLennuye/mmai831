FROM python:3.10-bullseye
ARG TARGETPLATFORM

# Provides a container with all needed for some MMAI831 shallow ML on Jupyter.
# As there is no tensorflow, works on arm and amd without Buildkit.

# Build:
# docker build -t <image name> .  # e.g. docker build -t gmc/mmai .

# Run:
# docker run --rm -v $(pwd):/app -p 8888:8888 <image name> [notebook]

LABEL author='George Cummings'
USER root
RUN apt-get update -y \
    && apt-get install -y cmake libgl1-mesa-glx ffmpeg libsm6 libxext6 \
                       libxrender-dev protobuf-compiler \
                       nodejs npm software-properties-common 

# Install R
#RUN apt-add-repository 'deb http://cloud.r-project.org/bin/linux/debian bullseye-cran40/'
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
RUN apt-get update -y && apt-get -y install r-base

# Clean up
RUN rm -r /var/lib/apt/lists/*

RUN useradd -ms /bin/bash apprunner
RUN mkdir /app && chown apprunner /app
COPY requirements.txt /app
RUN python3 -m pip install --no-cache-dir --upgrade pip
RUN python3 -m pip install -r /app/requirements.txt
RUN Rscript -e "install.packages('IRkernel')"
RUN Rscript -e "IRkernel::installspec(user = FALSE)"
RUN /usr/local/bin/jupyter labextension install @techrah/text-shortcuts

# Pandoc
RUN apt update
RUN apt -y install pandoc

USER apprunner
COPY dockerconfig/tracker.jupyterlab-settings /tmp
ENV USERSETTINGSDIR /home/apprunner/.jupyter/lab/user-settings
RUN mkdir -p $USERSETTINGSDIR/\@jupyterlab/notebook-extension
RUN cp /tmp/tracker.jupyterlab-settings \
     $USERSETTINGSDIR/\@jupyterlab/notebook-extension/
WORKDIR /app

CMD ["/usr/local/bin/jupyter", "lab", "--no-browser", "--ip", "0.0.0.0"]
