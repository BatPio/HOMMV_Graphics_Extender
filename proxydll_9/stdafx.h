// stdafx.h 
#pragma once
// include the Direct3D Library file
#pragma comment (lib, "d3d9.lib")
#pragma comment (lib, "d3dx9.lib")

#define WIN32_LEAN_AND_MEAN		
#include <windows.h>
#include <windowsx.h>
#include <string>
#include <map>
#include <array>
#include <fstream>
#include <tchar.h> 
#include <iostream>
#include <vector>

#define D3D_DEBUG_INFO
#include <d3d9.h>
#include <d3dx9.h>
#include "crc32.h"
#include "myIDirect3D9.h"
#include "myIDirect3DDevice9.h"
