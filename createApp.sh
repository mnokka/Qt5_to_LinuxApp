#!/bin/bash
set -e
# V1.0 December 2024   Initial version   mika.nokka1@gmail.com


# Define the source directories **********************************************************************
MYLINUXAPP="MyTest"
QTAPP="QtPasswordGenerator"
SOURCE_DIR="./DistributionKit"
TARGET_DIR="./$MYLINUXAPP"
#******************************************************************************************************

echo "Qt5 app --> LinuxApp creation"
echo ""
echo "1) This tool requires creation of cQtDeployer package first in Qt5 QtCreator Release directory"
echo "Example usage: cqtdeployer -bin QtPasswordGenerator -qmake /home/mika/Qt/5.15.1/gcc_64/bin/qmake "
echo "(see https://wiki.qt.io/CQtDeployer)"
echo
echo "  cd into ...<YourQtApp>/build/Desktop_Qt_5_15_1_GCC_64bit-Release$" 
echo "  -bin <Qt5 Release variant binary name>"
echo "  -qmake <path where qmake installation is"
echo "  let default DistributionKit directory to be generated in ...Release directory"
echo ""
echo "DistributionKit directory must have Linux App Icon file (<LinuxAppName>.png."
echo ""
echo "2) Create Linux AppImage package using appimagetool."
echo "(Dowload: wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage chmod +x appimagetool-x86_64.AppImage)"
echo "Execute tool: ./appimagetool-x86_64.AppImage >LinuxAppName>"
echo ""
echo "Tested on Ubuntu 20,21. Ubuntu may require installation of  libxcb-xinerama0"
echo ""
echo "Runnable LinuxApp will be in ...Release directory named as: <QtAppName>-x86_64.Appimage"
echo ""
echo ""
echo "These are script defined directories:"
echo
echo "Qt5 Release variant app name: $QTAPP"
echo "LinuxApp worktime name:       $MYLINUXAPP"
echo "Qt5 cQtDeployer target as source: $SOURCE_DIR"
echo "Linux App work directory:     $TARGET_DIR"
echo "Linux app to be named:        $QTAPP-x86_64.Appimage"
echo ""

read -p "Do you want to continue? (y/n): " choice
  if [ "$choice" != "y" ]; then
     echo "Exiting script!"
     exit 1
 fi

if [ -d "$SOURCE_DIR" ]; then
    echo "Source directory found: $SOURCE_DIR"
else
    echo "ERROR: no source directory found: $SOURCE_DIR"
    exit 1
fi

if [ -d "$TARGET_DIR" ]; then
    echo "ERROR: directory $TARGET_DIR  exists"
	exit 1
else
    mkdir -p $TARGET_DIR/{bin,lib,plugins,qml,translations}
    echo "Created Linux App needed directories $TARGET_DIR -->  bin,lib,plugins,qml,translations"
fi

if [ -f "$SOURCE_DIR/$MYLINUXAPP.png" ]; then
	echo "Found application image file: $SOURCE_DIR/$MYLINUXAPP.png , copying to ./$MYLINUXAPP/$MYLINUXAPP.png"
	cp --verbose "$SOURCE_DIR/$MYLINUXAPP.png" "./$MYLINUXAPP/$MYLINUXAPP.png"
else
    echo "ERROR: no icon image file in source directory: $SOURCE_DIR/$MYLINUXAPP.png"
	echo "You must provide it to source directory. It is not generated"
    exit 1
fi


cp "$SOURCE_DIR/bin/$QTAPP" "$TARGET_DIR/bin/"
if [ -d "$SOURCE_DIR/lib" ];then
    cp -r --verbose "$SOURCE_DIR/lib/"* "$TARGET_DIR/lib/"
fi
if [ -d "$SOURCE_DIR/plugins" ];then
    cp -r --verbose "$SOURCE_DIR/plugins/"* "$TARGET_DIR/plugins/"
fi
if [ -d "$SOURCE_DIR/qml" ]; then
    cp -r --verbose "$SOURCE_DIR/qml/"* "$TARGET_DIR/qml/"
fi
if [ -d "$SOURCE_DIR/lib" ];then
    cp -r --verbose "$SOURCE_DIR/translations/"* "$TARGET_DIR/translations/"
fi


echo "Creating script $TARGET_DIR/AppRun"
cat << 'EOF' > "$TARGET_DIR/AppRun"
#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")
exec "$DIR/launcher.sh" "$@"
EOF
chmod a+x $TARGET_DIR/AppRun

echo "Creating script $TARGET_DIR/launcher.sh"
cat << EOF > "$TARGET_DIR/launcher.sh"
#!/bin/sh
BASE_DIR=\$(dirname "\$(readlink -f "\$0")")
export PATH="\$BASE_DIR/bin/:\$PATH"
export LD_LIBRARY_PATH="\$BASE_DIR/lib/:\$BASE_DIR:\$LD_LIBRARY_PATH"
export QML_IMPORT_PATH="\$BASE_DIR/qml/:\$QML_IMPORT_PATH"
export QML2_IMPORT_PATH="\$BASE_DIR/qml/:\$QML2_IMPORT_PATH"
export QT_PLUGIN_PATH="\$BASE_DIR/plugins/:\$QT_PLUGIN_PATH"
export QTWEBENGINEPROCESS_PATH="\$BASE_DIR/bin/QtWebEngineProcess"
export QT_QPA_PLATFORM_PLUGIN_PATH="\$BASE_DIR/plugins/platforms"
exec "\$BASE_DIR/bin/$QTAPP" "\$@"
EOF
chmod a+x $TARGET_DIR/launcher.sh





echo "Creating desktop file $TARGET_DIR/$MYLINUXAPP.desktop"
cat << EOF > "$TARGET_DIR/$MYLINUXAPP.desktop"
[Desktop Entry]
Type=Application
Name=$QTAPP
Exec=launcher.sh
Icon=$MYLINUXAPP
Categories=Utility;
EOF



echo "Finding missing libraries $TARGET_DIR/bin/$QTAPP"
ldd $TARGET_DIR/bin/$QTAPP

echo "----------------------------------------------------------------------------------------"
echo "All done! Now you can proceed to create the Linux tAppImage package using appimagetool."
echo
echo "Fetch tool: wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage chmod +x appimagetool-x86_64.AppImage"
echo
echo "Execute tool: ./appimagetool-x86_64.AppImage $MYLINUXAPP"
echo "----------------------------------------------------------------------------------------"
