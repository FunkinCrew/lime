#ifdef HX_WINDOWS
#define _WIN32_DCOM
#include <iostream>
#include <wbemidl.h>
#include <comutil.h>
#pragma comment(lib, "wbemuuid.lib")
#include <windows.h>
#endif

#include <system/System.h>


namespace lime {


	#ifdef LIME_HASHLINK
	bool System::_isHL = (hl_nan () != 0);
	#else
	bool System::_isHL = false;
	#endif


	void System::GCEnterBlocking () {

		if (!_isHL) {

			gc_enter_blocking ();

		}

	}


	void System::GCExitBlocking () {

		if (!_isHL) {

			gc_exit_blocking ();

		}

	}


	void System::GCTryEnterBlocking () {

		if (!_isHL) {

			// TODO: Only supported in HXCPP 4.3
			// gc_try_blocking ();

		}

	}


	void System::GCTryExitBlocking () {

		if (!_isHL) {

			// TODO: Only supported in HXCPP 4.3
			//gc_try_unblocking ();

		}

	}


	#if defined (HX_WINDOWS)
	char* GetWMIValue (BSTR query, BSTR field) {

		HRESULT hres = 0;
		IWbemLocator *pLoc = NULL;
		IWbemServices *pSvc = NULL;
		IEnumWbemClassObject* pEnumerator = NULL;
		IWbemClassObject *pclsObj = NULL;
		ULONG uReturn = 0;
		char* result = NULL;

		hres = CoCreateInstance (CLSID_WbemLocator, 0, CLSCTX_INPROC_SERVER, IID_IWbemLocator, (LPVOID *) &pLoc);

		if (FAILED (hres)) {

			return NULL;

		}

		hres = pLoc->ConnectServer (_bstr_t (L"ROOT\\CIMV2"), NULL, NULL, 0, NULL, 0, 0, &pSvc);

		if (FAILED (hres)) {

			pLoc->Release ();
			return NULL;

		}

		hres = CoSetProxyBlanket (pSvc, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE, NULL, RPC_C_AUTHN_LEVEL_CALL, RPC_C_IMP_LEVEL_IMPERSONATE, NULL, EOAC_NONE);

		if (FAILED (hres)) {

			pSvc->Release ();
			pLoc->Release ();
			return NULL;

		}

		hres = pSvc->ExecQuery (bstr_t (L"WQL"), query, WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY, NULL, &pEnumerator);

		if (FAILED (hres)) {

			pSvc->Release ();
			pLoc->Release ();
			return NULL;

		}

		while (pEnumerator) {

			HRESULT hr = pEnumerator->Next (WBEM_INFINITE, 1, &pclsObj, &uReturn);

			if (uReturn == 0) {

				break;

			}

			VARIANT vtProp;
			hr = pclsObj->Get (field, 0, &vtProp, 0, 0);
			int len = WideCharToMultiByte (CP_UTF8, 0, vtProp.bstrVal, -1, NULL, 0, NULL, NULL);
			result = (char*)malloc(len);
			WideCharToMultiByte (CP_UTF8, 0, vtProp.bstrVal, -1, result, len, NULL, NULL);
			VariantClear (&vtProp);
			pclsObj->Release ();

		}

		pSvc->Release ();
		pLoc->Release ();
		pEnumerator->Release ();

		return result;
	}
	#endif


	char* System::GetDeviceModel () {

		#if defined (HX_WINDOWS)
		return GetWMIValue (_bstr_t(L"SELECT * FROM Win32_ComputerSystemProduct"), _bstr_t(L"Version"));
		#else
		return NULL;
		#endif

	}


	char* System::GetDeviceVendor () {

		#if defined (HX_WINDOWS)
		return GetWMIValue (_bstr_t(L"SELECT * FROM Win32_ComputerSystemProduct"), _bstr_t(L"Vendor"));
		#else
		return NULL;
		#endif

	}


	char* System::GetPlatformLabel () {

		#if defined (HX_WINDOWS)
		return GetWMIValue (_bstr_t(L"SELECT * FROM Win32_OperatingSystem"), _bstr_t(L"Caption"));
		#else
		return NULL;
		#endif

	}


	char* System::GetPlatformName () {

		return NULL;

	}


	char* System::GetPlatformVersion () {

		#if defined (HX_WINDOWS)
		return GetWMIValue (_bstr_t(L"SELECT * FROM Win32_OperatingSystem"), _bstr_t(L"Version"));
		#else
		return NULL;
		#endif

	}


	#if defined (HX_WINDOWS)
	int System::GetWindowsConsoleMode (int handleType) {

		DWORD mode = 0;

		HANDLE handle = GetStdHandle ((DWORD)handleType);

		if (handle) {

			GetConsoleMode (handle, &mode);

		}

		return mode;

	}
	#endif


	#if defined (HX_WINDOWS)
	bool System::SetWindowsConsoleMode (int handleType, int mode) {

		HANDLE handle = GetStdHandle ((DWORD)handleType);

		if (handle) {

			return SetConsoleMode (handle, (DWORD)mode);

		}

		return false;

	}
	#endif

	int System::GetDeviceOrientation () {

		return 0; // SDL_ORIENTATION_UNKNOWN

	}

	void System::EnableDeviceOrientationChange (bool enable) {

	}

}