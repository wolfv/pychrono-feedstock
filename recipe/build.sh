mkdir ./build
cd ./build

HOST_PY_VER=`python -c 'import sys; print(str(sys.version_info[0])+"."+str(sys.version_info[1]))'`

if [ ! -d "${PREFIX}/include/python${HOST_PY_VER}" ]; then
    HOST_PY_VER="${HOST_PY_VER}m"
fi

if [ `uname` == Darwin ]; then
    PY_LIB="libpython${HOST_PY_VER}.dylib"
else
    PY_LIB="libpython${HOST_PY_VER}.so"
fi

CONFIGURATION=Release
# Configure step
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DBUILD_DEMOS:BOOL=OFF \
      -DENABLE_MODULE_CASCADE:BOOL=OFF \
      -DENABLE_UNIT_CASCADE:BOOL=ON \
      -DENABLE_MODULE_IRRLICHT:BOOL=OFF \
      -DENABLE_MODULE_POSTPROCESS:BOOL=ON \
      -DENABLE_MODULE_VEHICLE:BOOL=ON \
      -DENABLE_MODULE_FSI:BOOL=ON \
      -DENABLE_OPENMP:BOOL=ON \
      -DENABLE_MODULE_PYTHON:BOOL=ON \
      -DENABLE_MODULE_COSIMULATION:BOOL=OFF \
      -DENABLE_MODULE_MATLAB:BOOL=OFF \
      -DENABLE_MODULE_MKL:BOOL=OFF \
      -DENABLE_MODULE_PARALLEL:BOOL=OFF \
      -DENABLE_MODULE_OPENGL:BOOL=OFF \
      -DENABLE_MODULE_OGRE:BOOL=OFF \
      -DENABLE_MODULE_IRRLICHT:BOOL=OFF \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DPYTHON_EXECUTABLE=$PYTHON \
      -DEIGEN3_INCLUDE_DIR:PATH=$PREFIX/include/eigen3 \
      ./..

# Build step
# on linux travis, limit the number of concurrent jobs otherwise
# gcc gets out of memory
cmake --build . --config "$CONFIGURATION"

cmake --build . --config "$CONFIGURATION" --target install

mkdir -p $PREFIX/lib/python$HOST_PY_VER/site-packages
cp -r $PREFIX/share/chrono/python/* $PREFIX/lib/python$HOST_PY_VER/site-packages
