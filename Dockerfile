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
    && rm -r /var/lib/apt/lists/*

                       
RUN useradd -ms /bin/bash apprunner
RUN mkdir /app && chown apprunner /app
COPY requirements.txt /app
RUN python3 -m pip install --no-cache-dir --upgrade pip
RUN python3 -m pip install -r /app/requirements.txt

USER apprunner
WORKDIR /app
CMD ["/usr/local/bin/jupyter", "lab", "--no-browser", "--ip", "0.0.0.0"]
