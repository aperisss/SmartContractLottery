curl -L https://foundry.paradigm.xyz | bash 
source /root/.bashrc
foundryup
mkdir foundrylib
cd foundrylib
forge init 
rm -rf script src test
cd ..