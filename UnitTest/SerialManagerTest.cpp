#include "MMCore/MMCore.h"
#include "UnitTest/Common/PropertyTypes.h"
#include "UnitTest/Common/DeviceTypes.h"
#include <iostream>
#include <iomanip>
#include <assert.h>
#include <sstream>
#include <vector>
void SendToSerial(char device, char command, int data, std::vector<char>* program)
{
  if (data < 0) { data = 256 ^ 4 + data; }

  char byte_6 = data >> 24;
  data = data - (byte_6 << 24);
  char byte_5 = data >> 16;
  data = data - (byte_5 << 16);
  char byte_4 = data >> 8;
  data = data - (byte_4 << 8);
  char byte_3 = data;

  (*program)[0] = device;
  (*program)[1] = command;
  (*program)[2] = byte_3;
  (*program)[3] = byte_4;
  (*program)[4] = byte_5;
  (*program)[5] = byte_6;

}//end of function

int GetFromSerial(std::vector<char>* response)
{
  if (response->size() != 6) return -1;
  int result = (( (*response)[5] << 24) & 0xFF000000)
              + (((*response)[4] << 16) & 0x00FF0000)
              + (((*response)[3] << 8) & 0x0000FF00)
              + (((*response)[2]) & 0x000000FF);
  return result;
}

int main(int argc, char* argv[])
{
  // get module and device names
  if (argc < 3)
  {
    std::cout << "Error. Module and/or device name not specified!" << std::endl;
    std::cout << argv[0]<<" <module_name (\"SerialManager\" or \"SerialManager_d\")> <Port (\"COM1\"), (\"COM2\") ....>" << std::endl;
    return 1;
  }
  else if (argc > 4)
  {
    std::cout << "Error. Too many parameters!" << std::endl;
    std::cout << argv[0] << " <module_name (\"Zaber\" or \"Zaber_d\")> <Port (\"COM1\"), (\"COM2\") ....>" << std::endl;
    return 1;
  }
  std::string moduleName(argv[1]); 
  std::string port(argv[2]);  // Port ("COM1", "COM3" ..and so on)
  std::string label = port;
  CMMCore core;

  // Enable debugging if required
  core.enableStderrLog(true);
  core.enableDebugLog(true);
  try
  {
    // This line loads the "device: which the SerialManager library. Note that unlike
    // other adapters, deviceName is actually the Port that needs to be opened.
    core.loadDevice(label.c_str(), moduleName.c_str(), port.c_str());

    // Set some properties regarding the port
    core.setProperty(label.c_str(), "BaudRate", (double)9600);

    // Now, we try to initialize the port
    std::cout << "Trying to open Port: " << port<<std::endl;
    core.initializeDevice(label.c_str());
    std::cout << "Done." << std::endl;

    std::vector<char> program(6,0);
    SendToSerial(1, 53, 45, &program);
    // now try and write this data
    core.writeToSerialPort(label.c_str(),program);
    // and read the response
    //char* bb = new char[6];
    //std::string val1 = core.getSerialPortAnswer(label.c_str(), "ok");
    std::vector<char> response = core.readFromSerialPort(label.c_str());
    int vPos = GetFromSerial(&response);
    std::cout << "Curr Pos: "<<vPos<<std::endl;
    // Now, as a simple test, we try to get the absolute position of the translation stage
    //core.writeToSerialPort(label.c_str(),)
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
  std::cout << "Device " + port + " PASSED" << std::endl;
  return 0;
}//end of function
