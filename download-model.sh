# we do this at runtime since the model is too large
modelsDir="/data/models"
modelName="stable-diffusion-xl-base-1.0"

mkdir -p $modelsDir
cd $modelsDir

if [ ! -d "$modelsDir/$modelName" ]
then
    # make sure we have LFS capability
    git lfs install

    # clone the repo (note: it is huge)
    git clone https://huggingface.co/stabilityai/$modelName
else
    echo "$modelName already exists"
fi
