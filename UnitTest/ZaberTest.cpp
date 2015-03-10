#include "micromanager2/MMCore/MMCore.h"
#include "UnitTest/Common/PropertyTypes.h"
#include "UnitTest/Common/DeviceTypes.h"
#include <iostream>
#include <iomanip>
#include <assert.h>
#include <sstream>

int main(int argc, char* argv[])
{
  // get module and device names
  if (argc < 4)
  {
    std::cout << "Error. Module and/or device name not specified!" << std::endl;
    std::cout << argv[0]<<" <module_name (\"Zaber\" or \"Zaber_d\")> <device_name (\"Stage\")> <Port (\"COM1\"), (\"COM2\") ....>" << std::endl;
    return 1;
  }
  else if (argc > 4)
  {
    std::cout << "Error. Too many parameters!" << std::endl;
    std::cout << argv[0] << " <module_name (\"Zaber\" or \"Zaber_d\")> <device_name (\"Stage\")> <Port (\"COM1\"), (\"COM2\") ....>" << std::endl;
    return 1;
  }
  std::string moduleName(argv[1]); // "Zaber" or "Zaber_d"
  std::string deviceName(argv[2]); // "Stage / XYStage"
  std::string port(argv[3]);  // Port ("COM1", "COM3" ..and so on)
  std::string label = "COM3";
  CMMCore core;
  //core.enableStderrLog(true);
  core.enableDebugLog(true);
  try
  {
    // This line loads the device. As from the device test:
    // core.loadDevice(label.c_str(), moduleName.c_str(), deviceName.c_str());
    // Thus label = "Stage";
    //      moduleName = Zaber / Zaber_d (depending on Release or Debug modes)
    //      deviceName = "Zaber Stage";
    std::cout << "Loading " << deviceName << " from library " << moduleName << "..." << std::endl;
    core.loadDevice(label.c_str(), moduleName.c_str(), deviceName.c_str());
    std::cout << "Done." << std::endl;

    // Set some properties regarding the port
    core.setProperty(label.c_str(), "Port", port.c_str());
    std::cout << "Initializing..." << std::endl;
    core.initializeDevice(label.c_str());
    std::cout << "Done." << std::endl;
    /*
    // Obtain device properties
    // ------------------------
    std::vector<std::string> props(core.getDevicePropertyNames(label.c_str()));
    for (auto i=0; i < props.size(); ++i)
    {
      std::cout << props[i] << " (" << ::getPropertyTypeVerbose(core.getPropertyType(label.c_str(), props[i].c_str())) << ") = "
                            << core.getProperty(label.c_str(), props[i].c_str()) << std::endl;
    }
    */
    // unload the device
    // -----------------
    core.unloadAllDevices();
  }
  catch (CMMError& err)
  {
    std::cout << err.getMsg();
    return 1;
  }

  // declare success
  // ---------------
  std::cout << "Device " + deviceName + " PASSED" << std::endl;
  return 0;
}//end of function
