# we do this at runtime since the model is too large
modelsDir="/data/models"
sdxlModelName="stable-diffusion-xl-base-1.0"

echo "sanity check: listing for files and folders in the current working dir"
ls -la

echo "sanity check: listing for files and folders in the Hotshot-XL dir"
cd Hotshot-XL
ls -la
cd ..

mkdir -p $modelsDir
cd $modelsDir

if [ ! -d "$modelsDir/$sdxlModelName" ]
then
    # make sure we have LFS capability
    git lfs install

    # clone the repo (note: it is huge)
    # git clone https://huggingface.co/stabilityai/$modelName

    # edit: actually let's not download the huge git repo of SDXL
    # but only the unet
    mkdir -p $sdxlModelName
    cd $sdxlModelName
    wget https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/unet/diffusion_pytorch_model.safetensors
    cd ..
else
    echo "$modelsDir/$sdxlModelName already exists"
fi

if [ ! -d "$modelsDir/hotshotco" ]
then
    # make sure we have LFS capability
    git lfs install

    mkdir -p hotshotco
    cd hotshotco
    git clone https://huggingface.co/hotshotco/Hotshot-XL
    cd ..
else
    echo "$modelsDir/$hotshotco already exists"
fi

cd ..
