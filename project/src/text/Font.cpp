#include <algorithm>
#include <ft2build.h>
#include <graphics/ImageBuffer.h>
#include <list>
#include <SDL3/SDL.h>
#include <system/System.h>
#include <text/Font.h>
#include <utils/File.h>
#include <vector>

#include FT_FREETYPE_H
#include FT_BITMAP_H
#include FT_SFNT_NAMES_H
#include FT_TRUETYPE_IDS_H
#include FT_TRUETYPE_TABLES_H
#include FT_GLYPH_H
#include FT_OUTLINE_H

#ifdef GetGlyphIndices
#undef GetGlyphIndices
#endif

namespace lime
{

	void *Font::library;

	void Font::InitializeLibrary()
	{
		FT_Init_FreeType((FT_Library *)&library);
	}

	void Font::ShutdownLibrary()
	{
		if (library)
		{
			FT_Done_FreeType((FT_Library)library);

			library = 0;
		}
	}

	static unsigned long FT_Stream_Read(FT_Stream stream, unsigned long offset, unsigned char *buffer, unsigned long count)
	{
		File *file = static_cast<File *>(stream->descriptor.pointer);
		file->Seek(offset, SEEK_SET);
		return file->Read(buffer, count);
	}

	static void FT_Stream_Close(FT_Stream stream)
	{
		File *file = static_cast<File *>(stream->descriptor.pointer);

		if (file)
		{
			delete file;
		}

		free(stream);
	}

	Font::Font(Resource *resource, int faceIndex)
	{
		this->face = 0;

		if (resource)
		{
			File *file = resource->path ? new File(resource->path, "rb") : new File(resource->data, true);

			if (!file->handle)
			{
				delete file;
				return;
			}

			file->Seek(0, SEEK_END);

			size_t size = (size_t)file->Tell();

			file->Seek(0, SEEK_SET);

			FT_Stream stream = (FT_Stream)malloc(sizeof(*stream));
			memset(stream, 0, sizeof(*stream));
			stream->read = FT_Stream_Read;
			stream->close = FT_Stream_Close;
			stream->descriptor.pointer = file;
			stream->pos = 0;
			stream->size = (unsigned long)size;

			FT_Open_Args args;
			memset(&args, 0, sizeof(args));
			args.flags = FT_OPEN_STREAM;
			args.stream = stream;

			FT_Face face;

			if (!FT_Open_Face((FT_Library)library, &args, faceIndex, &face))
			{
				this->face = face;

				for (int i = 0; i < ((FT_Face)face)->num_charmaps; i++)
				{
					FT_UShort pid = ((FT_Face)face)->charmaps[i]->platform_id;
					FT_UShort eid = ((FT_Face)face)->charmaps[i]->encoding_id;

					if (((pid == 0) && (eid == 3)) || ((pid == 3) && (eid == 1)))
					{
						FT_Set_Charmap((FT_Face)face, ((FT_Face)face)->charmaps[i]);
					}
				}
			}
			else
			{
				FT_Stream_Close(stream);
			}
		}
	}

	Font::~Font()
	{
		if (face)
		{
			FT_Done_Face((FT_Face)face);
			face = 0;
		}
	}

	int Font::GetAscender()
	{
		return ((FT_Face)face)->ascender;
	}

	int Font::GetDescender()
	{
		return ((FT_Face)face)->descender;
	}

	wchar_t *Font::GetFamilyName()
	{
		wchar_t *family_name = NULL;
		FT_SfntName sfnt_name;
		FT_UInt num_sfnt_names, sfnt_name_index;
		int len, i;

		if (FT_IS_SFNT(((FT_Face)face)))
		{
			num_sfnt_names = FT_Get_Sfnt_Name_Count((FT_Face)face);
			sfnt_name_index = 0;

			while (sfnt_name_index < num_sfnt_names)
			{
				if (!FT_Get_Sfnt_Name((FT_Face)face, sfnt_name_index++, (FT_SfntName *)&sfnt_name) && sfnt_name.name_id == TT_NAME_ID_FULL_NAME)
				{
					if (sfnt_name.platform_id == TT_PLATFORM_MACINTOSH)
					{
						len = sfnt_name.string_len;
						family_name = new wchar_t[len + 1];
						mbstowcs(family_name, (const char *)sfnt_name.string, len);
						family_name[len] = L'\0';
						return family_name;
					}
					else if ((sfnt_name.platform_id == TT_PLATFORM_MICROSOFT) && (sfnt_name.encoding_id == TT_MS_ID_UNICODE_CS))
					{
						len = sfnt_name.string_len / 2;
						family_name = (wchar_t *)malloc((len + 1) * sizeof(wchar_t));

						for (i = 0; i < len; i++)
						{
							family_name[i] = ((wchar_t)sfnt_name.string[i * 2 + 1]) | (((wchar_t)sfnt_name.string[i * 2]) << 8);
						}

						family_name[len] = L'\0';
						return family_name;
					}
				}
			}
		}

		return NULL;
	}

	int Font::GetGlyphIndex(const char *character)
	{
		Uint32 charCode = SDL_StepUTF8(&character, NULL);

		if (charCode == 0)
		{
			charCode = (Uint32)-1;
		}

		return FT_Get_Char_Index((FT_Face)face, charCode);
	}

	void *Font::GetGlyphIndices(const char *characters)
	{
		value indices = alloc_array(0);

		while (*characters != '\0')
		{
			Uint32 character = SDL_StepUTF8(&characters, NULL);

			if (character == 0)
				break;

			val_array_push(indices, alloc_int(FT_Get_Char_Index((FT_Face)face, character)));
		}

		return indices;
	}

	void *Font::GetGlyphMetrics(int index)
	{
		if (FT_Load_Glyph((FT_Face)face, index, FT_LOAD_NO_BITMAP | FT_LOAD_FORCE_AUTOHINT | FT_LOAD_DEFAULT) == 0)
		{
			value metrics = alloc_empty_object();

			alloc_field(metrics, val_id("height"), alloc_int(((FT_Face)face)->glyph->metrics.height));
			alloc_field(metrics, val_id("horizontalBearingX"), alloc_int(((FT_Face)face)->glyph->metrics.horiBearingX));
			alloc_field(metrics, val_id("horizontalBearingY"), alloc_int(((FT_Face)face)->glyph->metrics.horiBearingY));
			alloc_field(metrics, val_id("horizontalAdvance"), alloc_int(((FT_Face)face)->glyph->metrics.horiAdvance));
			alloc_field(metrics, val_id("verticalBearingX"), alloc_int(((FT_Face)face)->glyph->metrics.vertBearingX));
			alloc_field(metrics, val_id("verticalBearingY"), alloc_int(((FT_Face)face)->glyph->metrics.vertBearingY));
			alloc_field(metrics, val_id("verticalAdvance"), alloc_int(((FT_Face)face)->glyph->metrics.vertAdvance));

			return metrics;
		}

		return alloc_null();
	}

	void *Font::GetKerning(int leftIndex, int rightIndex)
	{
		FT_Vector kerning;

		if (FT_Get_Kerning((FT_Face)face, leftIndex, rightIndex, FT_KERNING_DEFAULT, &kerning) == 0)
		{
			value metrics = alloc_empty_object();

			alloc_field(metrics, val_id("x"), alloc_int(kerning.x));
			alloc_field(metrics, val_id("y"), alloc_int(kerning.y));

			return metrics;
		}

		return alloc_null();
	}

	int Font::GetHeight()
	{
		return ((FT_Face)face)->height;
	}

	int Font::GetNumGlyphs()
	{
		return ((FT_Face)face)->num_glyphs;
	}

	int Font::GetUnderlinePosition()
	{
		return ((FT_Face)face)->underline_position;
	}

	int Font::GetUnderlineThickness()
	{
		return ((FT_Face)face)->underline_thickness;
	}

	int Font::GetStrikethroughPosition()
	{
		TT_OS2 *os2 = (TT_OS2 *)FT_Get_Sfnt_Table(((FT_Face)face), ft_sfnt_os2);

		if (os2 && os2->version != 0xFFFFU)
		{
			return os2->yStrikeoutPosition;
		}

		return 0;
	}

	int Font::GetStrikethroughThickness()
	{
		TT_OS2 *os2 = (TT_OS2 *)FT_Get_Sfnt_Table(((FT_Face)face), ft_sfnt_os2);

		if (os2 && os2->version != 0xFFFFU)
		{
			return os2->yStrikeoutSize;
		}

		return 0;
	}

	int Font::GetUnitsPerEM()
	{
		return ((FT_Face)face)->units_per_EM;
	}

	int Font::RenderGlyph(int index, Bytes *bytes, int offset, int flags)
	{
		int loadFlags = FT_LOAD_FORCE_AUTOHINT | FT_LOAD_DEFAULT;

		if (flags)
		{
			loadFlags |= flags;
		}

		if (FT_Load_Glyph((FT_Face)face, index, loadFlags) == 0)
		{
			if (FT_Render_Glyph(((FT_Face)face)->glyph, FT_RENDER_MODE_LCD) == 0)
			{
				FT_Bitmap bitmap = ((FT_Face)face)->glyph->bitmap;

				int height = bitmap.rows;
				int width = bitmap.width / 3; // Due to each pixel now has 3 components (R, G, B)
				int pitch = bitmap.pitch;

				if (width == 0 || height == 0)
				{
					return 0;
				}

				// We calculate the size needed for the glyph image, including metadata and 24-bit RGB color data
				uint32_t size = sizeof(GlyphImage) + (width * height * 4);

				if (bytes->length < size + offset)
				{
					bytes->Resize(size + offset);
				}

				GlyphImage *data = (GlyphImage *)(bytes->b + offset);

				// We should initialize the GlyphImage struct here with zero to avoid uninitialized values
				memset(data, 0, sizeof(GlyphImage));

				data->index = index;
				data->width = width;
				data->height = height;
				data->x = ((FT_Face)face)->glyph->bitmap_left;
				data->y = ((FT_Face)face)->glyph->bitmap_top;

				unsigned char *position = &data->data;

				// Copy the bitmap data row by row, copying each RGB triplet and adding padding for 32-bit alignment
				for (int i = 0; i < height; i++)
				{
					for (int j = 0; j < width; j++)
					{
						unsigned char r = bitmap.buffer[i * pitch + j * 3 + 0];
						unsigned char g = bitmap.buffer[i * pitch + j * 3 + 1];
						unsigned char b = bitmap.buffer[i * pitch + j * 3 + 2];
						unsigned char a = (r + g + b) / 3;

						// Red
						position[(i * width + j) * 4 + 0] = r;
						// Green
						position[(i * width + j) * 4 + 1] = g;
						// Blue
						position[(i * width + j) * 4 + 2] = b;
						// Alpha
						position[(i * width + j) * 4 + 3] = a;
					}
				}

				return size;
			}
		}

		return 0;
	}

	int Font::RenderGlyphs(int *indices, int numIndices, Bytes *bytes, int flags)
	{
		int offset = 0;
		int totalOffset = 4;
		uint32_t count = 0;

		for (int i = 0; i < numIndices; i++)
		{
			offset = RenderGlyph(indices[i], bytes, totalOffset, flags);

			if (offset > 0)
			{
				totalOffset += offset;
				count++;
			}
		}

		if (count > 0)
		{
			*(uint32_t *)(bytes->b) = count;
		}

		return totalOffset;
	}

	void Font::SetSize(size_t size)
	{
		FT_Set_Char_Size((FT_Face)face, 0, static_cast<int>(size * 64), 0, 0);
	}

} // namespace lime
