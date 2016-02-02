PKGS=( com.example.android.testing.blueprint.flavor2 com.example.android.testing.blueprint.flavor1 )

DEVICE_SERIAL="emulator-5554"

./gradlew assemble
./gradlew assembleAndroidTest

adb -s ${DEVICE_SERIAL} install -r app/build/outputs/apk/app-*flavor1-debug-androidTest-unaligned.apk
adb -s ${DEVICE_SERIAL} install -r app/build/outputs/apk/app-*flavor1-debug-androidTest-unaligned.apk
adb -s ${DEVICE_SERIAL} install -r app/build/outputs/apk/app-*flavor1-debug-unaligned.apk
adb -s ${DEVICE_SERIAL} install -r app/build/outputs/apk/app-*flavor2-debug-unaligned.apk

for PKG_NAME in "${PKGS[@]}"
do
  adb -s ${DEVICE_SERIAL} shell pm grant ${PKG_NAME} android.permission.DUMP
  adb -s ${DEVICE_SERIAL} shell am instrument -w ${PKG_NAME}.test/android.support.test.runner.AndroidJUnitRunner
  adb -s ${DEVICE_SERIAL} pull /sdcard/Android/data/${PKG_NAME}/files/testdata ./testdata/${PKG_NAME}/${DEVICE_SERIAL}/
  adb -s ${DEVICE_SERIAL} pull /storage/emulated/0/Android/data/${PKG_NAME}/files/testdata ./testdata/${PKG_NAME}/${DEVICE_SERIAL}/
  adb -s ${DEVICE_SERIAL} pull /storage/emulated/legacy/Android/data/${PKG_NAME}/files/testdata ./testdata/${PKG_NAME}/${DEVICE_SERIAL}/
done
