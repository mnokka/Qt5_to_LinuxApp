# Qt5_to_LinuxApp
Tools and procedures how to use Qt5 Release image for producing LinuxApp image


**cQtDeployer**

* cQtDeployer creates DistributionKit directory for Linux

**create.sh**

* Provided script creates source directory for LinuxApp image tool using DistributionKit as a source

**appimagetool**

* Appimagetool creates final runnable Linux app image


## Example 

External tools needed: 
1) **CQtDeployer**  https://wiki.qt.io/CQtDeployer
2) ** Linux AppImage creator** (wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage )
<br>
<br>
    Using *QtPasswordGenerator* as Qt5 app name. 
    
    Using *MyTest* as Linux app worktime name.
<br>
<br>
1) Build Qt5 Release application with QtCreator

2) Go into created directory: ....../QtPasswordGenerator /build/Desktop_Qt_5_15_1_GCC_64bit-Release

3) Build DistributionKit directory: *cqtdeployer -bin QtPasswordGenerator -qmake /home/mika/Qt/5.15.1/gcc_64/bin/qmake* 

    -qmake option for qmake installation directory

4) Create and copy Linux App Icon file MyTest.png in DistributionKit directory (just any created png image)

5) Add used directory and naming info to createApp.sh script

 *  Example: 

    MYLINUXAPP="MyTest"
 
    QTAPP="QtPasswordGenerator"
 
    SOURCE_DIR="./DistributionKit"
 
    TARGET_DIR="./$MYLINUXAPP"

6) Execute *createApp.sh* in release directory   

7) Create Linux AppImage package using appimagetool:  *./appimagetool-x86_64.AppImage MyTest*

8) Runnable LinuxApp will be in same Qt Release directory named as: QtPasswordGenerator-x86_64.Appimage
<br>
<br>
Tested on Ubuntu 20,21. Ubuntu may require installation of  libxcb-xinerama0



