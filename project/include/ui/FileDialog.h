#pragma once
#include <functional>
#include <string>
#include <ui/Window.h>
#include <vector>

namespace lime
{

	class FileDialog
	{
	  public:
		static void OpenDirectory(Window *window = nullptr, const char *title = nullptr, std::function<void(const char *const *, int, int)> callback = nullptr, const char *defaultPath = nullptr, bool allowMultiple = false);
		static void OpenFile(Window *window = nullptr, const char *title = nullptr, std::function<void(const char *const *, int, int)> callback = nullptr, const char **names = nullptr, const char **patterns = nullptr, int filterCount = 0, const char *defaultPath = nullptr, bool allowMultiple = false);
		static void SaveFile(Window *window = nullptr, const char *title = nullptr, std::function<void(const char *const *, int, int)> callback = nullptr, const char **names = nullptr, const char **patterns = nullptr, int filterCount = 0, const char *defaultPath = nullptr);
	};

} // namespace lime
