write_cfgmem  -format mcs -size 16 -interface SPIx2 -loadbit {up 0x00010000 "download.bit" up 0x00400000 "downloaduser.bit" } -loaddata {up 0x00000000 "Boot_V2.2.0.bin" up 0x003C0000 "CameraInfo_V2.3.9.bin" up 0x007D0000 "XML_V1.0.49.zip" up 0x007E0000 "FactoryParam_V2.3.9.bin" up 0x007E1000 "Init_V2.3.9.bin" up 0x00B90000 "4UserParam_0x40B90000.bin" up 0x00BA0000 "RealTime_V2.3.9.bin" } -force -file "flash_params.mcs"