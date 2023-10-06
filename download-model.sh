# we do this at runtime since the model is too large
modelsDir="/data/models"
modelName="stable-diffusion-xl-base-1.0"

mkdir -p $modelsDir
cd $modelsDir

if [ ! -d "$modelsDir/$modelName" ]
then
    # make sure we have LFS capability
    # git lfs install

    # clone the repo (note: it is huge)
    # git clone https://huggingface.co/stabilityai/$modelName

    # edit: actually let's not download the huge git repo of SDXL
    # but only the unet
    mkdir $modelName
    cd $modelName
    wget https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/unet/diffusion_pytorch_model.safetensors
    cd ..
else
    echo "$modelName already exists"
fi
cd ..
