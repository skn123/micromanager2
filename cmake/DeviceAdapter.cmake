#==============================================================================#
#Adapters - A common framework for building them (Some examples)
#==============================================================================#
SET(MY_ADAPTERS 
  #Andor
  #AndorLaserCombiner
  #AndorSDK3
  #dc1394
  #HIDManager
  #IDS_uEye
  #IIDC
  #ITC18
  #OpenCVgrabber
  #PVCAM
  #PrincetonInstruments
  #QCam
  #ScionCam
  #Sensicam
  #SequenceTester
  #SimpleCam
  #Spot
  #USBManager
  #Video4Linux
  AAAOTF
	#AOTF
	ASIFW1000
	ASIStage
	ASITiger
	ASIWPTR
	Aladdin
	Aquinas
	Arduino
	CARVII
	CSUW1
	Cobolt
	CoherentCube
	CoherentOBIS
	Conix
	Corvus
	#DTOpenLayer
	#DemoCamera
	FocalPoint
	FreeSerialPort
	ImageProcessorChain
	K8055
	K8061
	LeicaDMI
	LeicaDMR
	LeicaDMSTC
	Ludl
	LudlLow
	LumencorSpectra
	MP285
	MaestroServo
	Marzhauser
	Marzhauser-LStep
	MicroPoint
	#Motic_mac
	Neos
	NewportCONEX
	NewportSMC
	Nikon
	NikonTE2000
	OVP_ECS2
	Omicron
	Oxxius
	PI
	PI_GCS
	PI_GCS_2
	#ParallelPort
	Pecon
	Piezosystem_30DV50
	Piezosystem_NV120_1
	Piezosystem_NV40_1
	Piezosystem_NV40_3
	Piezosystem_dDrive
	PrecisExcite
	Prior
	PriorLegacy
	Sapphire
	Scientifica
	SerialManager
	SimpleAutofocus
	#SpectralLMM5
	SutterLambda
	SutterStage
	Thorlabs
	ThorlabsDCxxxx
	ThorlabsFilterWheel
	ThorlabsSC10
	Tofra
	TriggerScope
	#UserDefinedSerial
	Utilities
	VariLC
	Vincent
	#Vortran
	XCite120PC_Exacte
	XCiteLed
	XLight
	Xcite
	#Yokogawa
	Zaber
	ZeissCAN
	#ZeissCAN29
	kdv
	nPoint
	pgFocus
)

FOREACH(Adapter ${MY_ADAPTERS})
  SET(DeviceAdapter_${Adapter}_ENABLE OFF CACHE BOOL "Build ${Adapter} Module")
  IF(DeviceAdapter_${Adapter}_ENABLE)
    SET(${Adapter}_DIR ${PROJECT_SOURCE_DIR}/micromanager2/DeviceAdapters/${Adapter})
    INCLUDE_DIRECTORIES(${${Adapter}_DIR})
    FILE(GLOB_RECURSE ${Adapter}_SRCS  ${${Adapter}_DIR}/*.cpp ${${Adapter}_DIR}/*.h)
    ADD_LIBRARY(mmgr_dal_${Adapter} SHARED 
                                    ${${Adapter}_SRCS}
                                    $<TARGET_OBJECTS:MMDevice_DeviceAdapters>
    )
    #ToDo; Apparently in Linux, we need to change the suffix from .so to .so.0
    SET_TARGET_PROPERTIES(mmgr_dal_${Adapter} PROPERTIES 
                                              COMPILE_FLAGS "-DMODULE_EXPORTS"
                                              DEBUG_POSTFIX "_d") 
    TARGET_LINK_LIBRARIES(mmgr_dal_${Adapter} ${MODULAR_LIBRARY_LIST} ${NOMMODULAR_LIBRARY_LIST})

    SET(INSTALL_LIBS  ${INSTALL_LIBS} mmgr_dal_${Adapter})
  ENDIF()
ENDFOREACH()