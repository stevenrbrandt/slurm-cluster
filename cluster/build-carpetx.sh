cd ~/
git config --global user.email "sbrandt@cct.lsu.edu"
git config --global user.name "Steven R. Brandt"
curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/${ET_RELEASE}/GetComponents
chmod a+x GetComponents
#curl -o carpetx.cfg -L https://raw.githubusercontent.com/stevenrbrandt/CarpetX/main/scripts/actions-cpu-real64.cfg
perl GetComponents --root CarpetX asterx.th
cd ./CarpetX
./simfactory/bin/sim setup-silent
./simfactory/bin/sim build -j10 --thornlist ~/asterx.th --optionlist ~/carpetx.cfg
