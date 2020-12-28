// stdafx.h 
#pragma once
// include the Direct3D Library file
#pragma comment (lib, "d3d9.lib")
#pragma comment (lib, "d3dx9.lib")

#include "3rd-party-libs/clog/clog.h"

const int LOG = 0; /* Unique identifier for logger */

#define WIN32_LEAN_AND_MEAN	
#include <algorithm>	
#include <windows.h>
#include <windowsx.h>
#include <string>
#include <map>
#include <array>
#include <fstream>
#include <tchar.h> 
#include <iostream>
#include <vector>
#include <chrono>

#define D3D_DEBUG_INFO
#include <d3d9.h>
#include <d3dx9.h>
#include "3rd-party-libs/crc32/crc32.h"
#include "myIDirect3D9.h"
#include "myIDirect3DDevice9.h"
