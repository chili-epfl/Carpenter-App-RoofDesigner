# Carpenter – the app that plan

App to draw 2d sketch made of points and lines which can be exported as 3D model suitable for 3D printing.

Built with Qt and QML. Works under GNU/Linux, Mac and Windows OS

## Requirements

Assimp 3.3.1 (https://github.com/assimp/assimp)
Quazip (https://github.com/lorenzolightsgdwarf/quazip)
SolveSpace (https://github.com/lorenzolightsgdwarf/solvespace)

### Build Assimp

Clone the repository and checkout the version with tag 3.1.1

```bash
git clone https://github.com/assimp/assimp
cd assimp
git checkout tags/v3.1.1
```

#### Unix-like systems
```bash
mkdir build-unix
cd build-unix
cmake .. -DCMAKE_INSTALL_PREFIX=install/
make
make install
```
Headers and libs will be copied in the path [Path_to_Assimp_Folder]/build-unix/install 
#### Android systems

If you haven't done yet, download and install Android NDK 13d or later. We will refer to NDK folder as ANDROID_NDK_FOLDER.
If using CMake 3.7+ change the android.chaintool.cmake according to [here](https://github.com/a252539783/aosp-platform-ndk/blob/e14807b36bca5a3348cbd6211a62d527276fe82a/build/cmake/android.toolchain.cmake).

```bash
mkdir build-android
cd build-android
cmake .. -DCMAKE_TOOLCHAIN_FILE=[ANDROID_NDK_FOLDER]/build/cmake/android.toolchain.cmake -DANDROID_PLATFORM=android-9 -DANDROID_ARM_MODE=arm -DANDROID_ABI=armeabi-v7a\ with\ NEON -DCMAKE_INSTALL_PREFIX=install/ -DANDROID_CPP_FEATURES="rtti exceptions" -DASSIMP_BUILD_ASSIMP_TOOLS=OFF
make
make install
```
Headers and libs will be copied in the path [Path_to_Assimp_Folder]/build-android/install 

### Build Quazip
```bash
git clone https://github.com/lorenzolightsgdwarf/quazip
```
Quazip is Qt project, so just open it in QtCreator. It requires zlib to be installed and available to the linker (add the path to LIBS if necessary). The project is composed by two subprojects, quazip and qztest. Compilation errors coming from the second project can be ignored.

Configure the kit that you need and remember to add "make install" as build step.
For Android, remember also to disable the build step "Make Install" and "Build Android APK".

### Build SolveSpace

```bash
git clone https://github.com/lorenzolightsgdwarf/solvespace
cd solvespace
git checkout solver
```
Headers are located in the folder [Path_to_solvespace]/include/ 
#### Unix-like systems
```bash
mkdir build-unix
cd build-unix
cmake .. -DCMAKE_CXX_FLAGS=-std=c++11
make 
```
Libs will be located in [Path_to_solvespace]/build-unix/src

#### Andorid systems 

If you haven't done yet, download and install Android NDK 13d or later. We will refer to NDK folder as ANDROID_NDK_FOLDER.
If using CMake 3.7+ change the android.chaintool.cmake according to [here](https://github.com/a252539783/aosp-platform-ndk/blob/e14807b36bca5a3348cbd6211a62d527276fe82a/build/cmake/android.toolchain.cmake).
```bash
mkdir build-android
cd build-android
cmake .. -DCMAKE_TOOLCHAIN_FILE=[ANDROID_NDK_FOLDER]/build/cmake/android.toolchain.cmake -DANDROID_PLATFORM=android-9 -DANDROID_ARM_MODE=arm -DANDROID_ABI=armeabi-v7a\ with\ NEON -DANDROID_CPP_FEATURES="rtti exceptions" -DCMAKE_CXX_FLAGS=-std=c++11
make
```
Libs will be located in [Path_to_solvespace]/build-android/src


### Ready?

The last step is to set the variables 'ASSIMP_DIR' and 'SOLVESPACE_DIR' in the 'carpenter.pro' file to the ansolute paths of assimp and solvespace.


## Third party 

* [FontAwesome](https://fortawesome.github.io/Font-Awesome/) : [SIL OFL 1.1](http://scripts.sil.org/OFL)
* [Material design iconic font](http://zavoloklom.github.io/material-design-iconic-font/) : [SIL OFL 1.1](http://scripts.sil.org/OFL)
* [lodash](https://lodash.com) : [MIT license](https://lodash.com/license)
