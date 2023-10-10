#FROM nvidia/cuda:12.2.0-devel-ubuntu20.04
# let's try to downgrade the version of CUDA
FROM nvidia/cuda:11.8.0-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive

# Use login shell to read variables from `~/.profile` (to pass dynamic created variables between RUN commands)
SHELL ["sh", "-lc"]

RUN apt update

# base stuff
RUN apt --yes install build-essential wget curl rpl

RUN echo "Build started at: $(date "+%Y-%m-%d %H:%M")"

# NodeJS - NEW, MORE ANNOYING WAY
RUN apt --yes install -y ca-certificates gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
ENV NODE_MAJOR=18
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt update
RUN apt --yes install nodejs

# git and file management
RUN apt --yes install git git-lfs unzip
RUN git lfs install

# Python
RUN apt --yes install python3 python3-pip
RUN python3 -m pip install --no-cache-dir --upgrade pip

# Set up a new user named "user" with user ID 1000
RUN useradd -o -u 1000 user

# Switch to the "user" user
USER user

ENV PYTHON_BIN /usr/bin/python3
ENV PATH /usr/local/cuda-11.8/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH

# Set home to the user's home directory
ENV HOME=/home/user \
	PATH=/home/user/.local/bin:$PATH

# Set the working directory to the user's home directory
WORKDIR $HOME/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY --chown=user package*.json $HOME/app

# Install node dependencies
RUN npm install

# Download the Hotshot-XL source code (from GitHub)
RUN git clone https://github.com/hotshotco/Hotshot-XL.git

WORKDIR $HOME/app/Hotshot-XL

# Download the Hotshot-XL model weights (from Hugging Face)
RUN git clone https://huggingface.co/hotshotco/Hotshot-XL

# Download the Hotshot-XL model trained on 512px
RUN git clone https://huggingface.co/hotshotco/SDXL-512


# should we do this to install pytorch with cuda support?
#ARG PYTORCH='2.0.1'
#ARG TORCH_VISION=''
#ARG TORCH_AUDIO=''
#ARG CUDA='cu118'
#RUN [ ${#PYTORCH} -gt 0 ] && VERSION='torch=='$PYTORCH'.*' ||  VERSION='torch'; python3 -m pip install --no-cache-dir -U $VERSION --extra-index-url https://download.pytorch.org/whl/$CUDA
#RUN [ ${#TORCH_VISION} -gt 0 ] && VERSION='torchvision=='TORCH_VISION'.*' ||  VERSION='torchvision'; python3 -m pip install --no-cache-dir -U $VERSION --extra-index-url https://download.pytorch.org/whl/$CUDA
#RUN [ ${#TORCH_AUDIO} -gt 0 ] && VERSION='torchaudio=='TORCH_AUDIO'.*' ||  VERSION='torchaudio'; python3 -m pip install --no-cache-dir -U $VERSION --extra-index-url https://download.pytorch.org/whl/$CUDA

# copy the list of dependencies
# COPY --chown=user requirements.txt $HOME/app/Hotshot-XL/requirements.txt

# Install the source code dependencies
# RUN python3 -m pip install --no-cache-dir -r $HOME/app/Hotshot-XL/requirements.txt

COPY requirements.txt ./
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Let's go back to the app working dir
WORKDIR $HOME/app

# Let's copy everything
COPY --chown=user . $HOME/app

RUN echo "Build ended at: $(date "+%Y-%m-%d %H:%M")"

EXPOSE 7860

CMD [ "npm", "run", "start" ]
