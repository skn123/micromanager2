#==============================================================================#
#MMDevice Sources - Has to be there for every adapter
#==============================================================================#
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR}/micromanager2/MMDevice)
FILE(GLOB MMDevice_SRCS_FOR_MMCore  ${PROJECT_SOURCE_DIR}/micromanager2/MMDevice/*.cpp
                                    ${PROJECT_SOURCE_DIR}/micromanager2/MMDevice/*.h)
                        
#Create a duplicate. This is to force CMake to initialize a build with a different
#set of pre-processor defines.
SET(MMDevice_SRCS_FOR_DeviceAdapters ${MMDevice_SRCS_FOR_MMCore})
#Apparently MMDevice needs to be compiled with an additional definition if MMCore is
#being built. The definitions are needed as there are in-built functions using 
#export symbols.
ADD_LIBRARY(MMDevice_MMCore OBJECT ${MMDevice_SRCS_FOR_MMCore})
SET_TARGET_PROPERTIES(  MMDevice_MMCore PROPERTIES 
                        COMPILE_FLAGS "-DMMCORE_MODULE_EXPORTS -DMODULE_EXPORTS") 

#Use CMake's object property to build Object files  
ADD_LIBRARY(MMDevice_DeviceAdapters OBJECT ${MMDevice_SRCS_FOR_DeviceAdapters})
SET_TARGET_PROPERTIES(  MMDevice_DeviceAdapters PROPERTIES 
                        COMPILE_FLAGS "-DMODULE_EXPORTS") 
SET(MMGR_DIRS ${MMGR_DIRS} ${PROJECT_SOURCE_DIR}/micromanager2/MMDevice)
                        