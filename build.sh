#sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/LineageOS/android -b lineage-20.0 -g default,-mips,-darwin,-notdefault
git clone local_manifest --depth 1 -b master .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# build roms
source $CIRRUS_WORKING_DIR/script/config
timeStart

source build/envsetup.sh
export TZ=Asia/Jakarta
export KBUILD_BUILD_USER=
export KBUILD_BUILD_HOST=
export BUILD_USERNAME=
export BUILD_HOSTNAME=
lunch lineage_device_codename-buildtype
mkfifo reading
tee "${BUILDLOG}" < reading &
build_message "Building Started"
progress &
mka bacon -j8  > reading

retVal=$?
timeEnd
statusBuild
