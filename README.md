# micromanager2
A CMake enabled version of Micromanager from https://www.micro-manager.org/wiki/Micro-Manager_Source_Code

This code follows the principle of CMake with an out-of-source build and without using any hand-rolled solution files. Currently this project should compile under Windows (MSVC). Porting it to Mac OSX and Linux will involve setting the required preprocessor macros. In addition, some device adapters have not been enabled as the required pre-processors / third party libraries would need to be set by CMake. 
