# Usage: 
# docker run -it --rm --gpus all \
#   -v path/to/host/models/folder:/app/RFdiffusion/models \
#   -v path/to/host/output/folder:path/to/container/output/folder \
#    rfdiffusion ...

FROM nvcr.io/nvidia/cuda:11.6.2-cudnn8-runtime-ubuntu20.04

COPY . /app/RFdiffusion/

RUN apt-get -q update \ 
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  git \
  python3.9 \
  python3-pip \
  && python3.9 -m pip install -q -U --no-cache-dir pip \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove -y \
  && apt-get clean \
  && pip install -q --no-cache-dir \
  dgl==1.0.2+cu116 -f https://data.dgl.ai/wheels/cu116/repo.html \
  torch==1.12.1+cu116 --extra-index-url https://download.pytorch.org/whl/cu116 \
  e3nn==0.3.3 \
  wandb==0.12.0 \
  pynvml==11.0.0 \
  git+https://github.com/NVIDIA/dllogger#egg=dllogger \
  decorator==5.1.0 \
  hydra-core==1.3.2 \
  pyrsistent==0.19.3 \
  icecream==2.1.3 \
  /app/RFdiffusion/env/SE3Transformer

WORKDIR /app/RFdiffusion

ENTRYPOINT ["python3.9", "run_inference.py"]