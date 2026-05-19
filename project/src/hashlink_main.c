#ifdef HX_WIN_MAIN
extern int wmain(int argc, wchar_t *argv[]);

int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
	return wmain(__argc, __wargv);
}
#endif