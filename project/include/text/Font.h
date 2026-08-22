#pragma once

#include <graphics/ImageBuffer.h>
#include <hx/CFFIPrime.h>
#include <system/System.h>
#include <utils/Resource.h>

#ifdef HX_WINDOWS
#undef GetGlyphIndices
#endif

namespace lime
{

	typedef struct
	{
		unsigned long codepoint;
		size_t size;
		int index;
		int height;

	} GlyphInfo;

	typedef struct
	{
		uint32_t index;
		uint32_t width;
		uint32_t height;
		uint32_t x;
		uint32_t y;
		unsigned char data;

	} GlyphImage;

	class Font
	{
	  public:
		static void InitializeLibrary();
		static void ShutdownLibrary();

		Font(Resource *resource, int faceIndex = 0);
		~Font();

		int GetAscender();
		int GetDescender();
		wchar_t *GetFamilyName();
		int GetGlyphIndex(const char *character);
		void *GetGlyphIndices(const char *characters);
		void *GetGlyphMetrics(int index);
		void *GetKerning(int leftIndex, int rightIndex);
		int GetHeight();
		int GetNumGlyphs();
		int GetUnderlinePosition();
		int GetUnderlineThickness();
		int GetStrikethroughPosition();
		int GetStrikethroughThickness();
		int GetUnitsPerEM();
		int RenderGlyph(int index, Bytes *bytes, int offset, int flags);
		int RenderGlyphs(int *indices, int numIndices, Bytes *bytes, int flags);
		void SetSize(size_t size);

		void *face;

	  private:
		static void *library;
	};

} // namespace lime
