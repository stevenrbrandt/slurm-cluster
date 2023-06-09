tar xzvf ~etuser/sim.tgz

# Override for the machine that we want
cp simfactory/mdb/runscripts/slurmjupyter.run configs/sim/RunScript
cp simfactory/mdb/submitscripts/slurmjupyter.sub configs/sim/SubmitScript

ls ./exe/cactus_sim

# MAKE TARBALL
SED_IN_PLACE='t=$(stat -c %y "$0"); sed -i "s!'$PWD'!\$(CCTK_HOME)!g" "$0"; touch -d "$t" "$0"'

find configs/sim -name \*.d -exec bash -c "$SED_IN_PLACE" '{}' \;
find configs/sim -name \*.ccldeps -exec bash -c "$SED_IN_PLACE" '{}' \;
find configs/sim -name \*.deps -exec bash -c "$SED_IN_PLACE" '{}' \;
find configs/sim -name \*.defn -exec bash -c "$SED_IN_PLACE" '{}' \;

tar --exclude etk1.cct.lsu.edu.ini --exclude defs.local.ini -czf ../${PWD##*/}.tar.gz ../${PWD##*/}

cd
rm -fr Cactus CactusSourceJar.git  GetComponents  einsteintoolkit.th
