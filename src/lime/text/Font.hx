package lime.text;

import haxe.io.Bytes;

import lime._internal.backend.native.NativeCFFI;
import lime.app.Future;
import lime.app.Promise;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.math.Vector2;
import lime.net.HTTPRequest;
import lime.utils.Assets;
import lime.utils.UInt8Array;

#if (js && html5)
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.SpanElement;

import lime.utils.Log;
#end

#if !macro
import haxe.io.Path;
#end

#if (!display && !macro)
@:autoBuild(lime._internal.macros.AssetsMacro.embedFont())
#end
@:access(lime._internal.backend.native.NativeCFFI)
@:access(lime.text.Glyph)
class Font
{
	/**
	 * Initialize the library instance for all fonts.
	 */
	public static function init():Void
	{
		#if (lime_cffi && !macro)
		NativeCFFI.lime_font_initialize_library();
		#end
	}

	/**
	 * Shutdown the library instance for all fonts.
	 */
	public static function shutdown():Void
	{
		#if (lime_cffi && !macro)
		NativeCFFI.lime_font_shutdown_library();
		#end
	}

	/**
	 * The ascender value of the font.
	 */
	public var ascender:Int;

	/**
	 * The descender value of the font.
	 */
	public var descender:Int;

	/**
	 * The height of the font.
	 */
	public var height:Int;

	/**
	 * The name of the font.
	 */
	public var name(default, null):String;

	/**
	 * The number of glyphs in the font.
	 */
	public var numGlyphs:Int;

	public var src:Any;
	#if (html5 && js)
	public var fontFace:Dynamic;
	#end

	/**
	 * The underline position of the font.
	 */
	public var underlinePosition:Int;

	/**
	 * The underline thickness of the font.
	 */
	public var underlineThickness:Int;

	/**
	 * The underline position of the font.
	 */
	public var strikethroughPosition:Int;

	/**
	 * The underline thickness of the font.
	 */
	public var strikethroughThickness:Int;

	/**
	 * The units per EM of the font.
	 */
	public var unitsPerEM:Int;

	@:noCompletion private var __fontID:String;
	@:noCompletion private var __fontPath:String;
	#if (js && html5)
	@:noCompletion private var __webFontLoad:Future<Font>;
	@:noCompletion private var __webFontWeight:Int = 400;
	@:noCompletion private var __webFontStyle:String = "normal";

	@:noCompletion private static var __webFontID:Int = 0;
	#end

	@:noCompletion private var __fontPathWithoutDirectory:String;
	@:noCompletion private var __init:Bool;

	/**
	 * Creates a new instance of a Font object.
	 *
	 * @param name Optional name of the font.
	 */
	public function new(name:String = null)
	{
		if (name != null)
		{
			this.name = name;
		}

		if (!__init)
		{
			#if js if (ascender == untyped js.Syntax.code("undefined")) #end ascender = 0;
			#if js
			if (descender == untyped js.Syntax.code("undefined"))
			#end
			descender = 0;
			#if js
			if (height == untyped js.Syntax.code("undefined"))
			#end
			height = 0;
			#if js
			if (numGlyphs == untyped js.Syntax.code("undefined"))
			#end
			numGlyphs = 0;
			#if js
			if (underlinePosition == untyped js.Syntax.code("undefined"))
			#end
			underlinePosition = 0;
			#if js
			if (underlineThickness == untyped js.Syntax.code("undefined"))
			#end
			underlineThickness = 0;
			#if js
			if (unitsPerEM == untyped js.Syntax.code("undefined"))
			#end
			unitsPerEM = 0;

			if (__fontID != null)
			{
				if (Assets.isLocal(__fontID))
				{
					__fromBytes(Assets.getBytes(__fontID), name);
				}
			}
			else if (__fontPath != null)
			{
				__fromFile(__fontPath);
			}
		}
	}

	/**
	 * Creates a Font instance from byte data.
	 *
	 * @param bytes The byte data containing the font.
	 * @return A `Font` instance.
	 */
	public static function fromBytes(bytes:Bytes, wantedFontName:String = null):Font
	{
		if (bytes == null)
			return null;

		var font = new Font();
		font.__fromBytes(bytes, wantedFontName);

		#if (lime_cffi && !macro)
		return (font.src != null) ? font : null;
		#else
		return font;
		#end
	}

	/**
	 * Creates a Font instance from a file path.
	 *
	 * @param path The file path of the font.
	 * @return A `Font` instance.
	 */
	public static function fromFile(path:String):Font
	{
		if (path == null)
			return null;

		var font = new Font();
		font.__fromFile(path);

		#if (lime_cffi && !macro)
		return (font.src != null) ? font : null;
		#else
		return font;
		#end
	}

	/**
	 * Loads a Font from byte data asynchronously.
	 *
	 * @param bytes The byte data containing the font.
	 * @return A `Future` containing a `Font` instance.
	 */
	public static function loadFromBytes(bytes:Bytes, wantedFontName:String = null):Future<Font>
	{
		if (bytes == null)
			return cast Future.withError("Could not load font from empty data");

		var font = new Font();
		font.__fromBytes(bytes, wantedFontName);

		#if (js && html5)
		return font.__loadWebFont();
		#else
		return Future.withValue(font);
		#end
	}

	/**
	 * Loads a Font from a file path asynchronously.
	 *
	 * @param path The file path of the font.
	 * @return A `Future` containing a `Font` instance.
	 */
	public static function loadFromFile(path:String):Future<Font>
	{
		#if (js && html5)
		if (path == null || path == "")
			return cast Future.withError("Could not load font: empty path");

		var request = new HTTPRequest<Bytes>();
		var fileName = Path.withoutDirectory(Path.withoutExtension(path));

		return request.load(path).then(function(bytes)
		{
			if (bytes == null)
				return cast Future.withError("Could not load font: " + path);

			return loadFromBytes(bytes, fileName);
		});
		#else
		var request = new HTTPRequest<Font>();

		return request.load(path).then(function(font)
		{
			if (font != null)
				return Future.withValue(font);
			else
				return cast Future.withError("");
		});
		#end
	}

	/**
	 * Loads a Font by its name asynchronously.
	 *
	 * @param path The name of the font.
	 * @return A `Future` containing a `Font` instance.
	 */
	public static function loadFromName(path:String):Future<Font>
	{
		#if (js && html5)
		var font = new Font();
		return font.__loadFromName(path);
		#else
		return cast Future.withError("");
		#end
	}

	/**
	 * Retrieves a glyph from the font by a character.
	 *
	 * @param character The character whose glyph to retrieve.
	 * @return A `Glyph` instance representing the glyph of the character.
	 */
	public function getGlyph(character:String):Glyph
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_font_get_glyph_index(src, character);
		#else
		return -1;
		#end
	}

	/**
	 * Retrieves an array of glyphs for a set of characters.
	 *
	 * @param characters The string containing characters to retrieve glyphs for.
	 * @return An array of `Glyph` instances representing the glyphs of the characters.
	 */
	public function getGlyphs(characters:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^`'\"/\\&*()[]{}<>|:;_-+=?,. "):Array<Glyph>
	{
		#if (lime_cffi && !macro)
		return NativeCFFI.lime_font_get_glyph_indices(src, characters);
		#else
		return null;
		#end
	}

	/**
	 * Retrieves metrics for a given glyph.
	 *
	 * @param glyph The glyph whose metrics to retrieve.
	 * @return A `GlyphMetrics` instance containing the metrics of the glyph.
	 */
	public function getGlyphMetrics(glyph:Glyph):GlyphMetrics
	{
		#if (lime_cffi && !macro)
		var value:Dynamic = NativeCFFI.lime_font_get_glyph_metrics(src, glyph);

		var metrics = new GlyphMetrics();
		metrics.advance = new Vector2(value.horizontalAdvance, value.verticalAdvance);
		metrics.height = value.height;
		metrics.horizontalBearing = new Vector2(value.horizontalBearingX, value.horizontalBearingY);
		metrics.verticalBearing = new Vector2(value.verticalBearingX, value.verticalBearingY);
		return metrics;
		#else
		return null;
		#end
	}

	/**
	 * Retrieves kerning vector between two glyphs.
	 *
	 * @param leftGlyph The left glyph in the kern pair.
	 * @param rightGlyph The right glyph in the kern pair.
	 * @return A `GlyphKerning` instance containing the kerning vector between the given glyphs.
	 */
	public function getGlyphKerning(leftGlyph:Glyph, rightGlyph:Glyph):GlyphKerning
	{
		#if (lime_cffi && !macro)
		var value:Dynamic = NativeCFFI.lime_font_get_glyph_kerning(src, leftGlyph, rightGlyph);

		var kerning = new GlyphKerning();
		kerning.x = value.x;
		kerning.y = value.y;
		return kerning;
		#else
		return null;
		#end
	}

	/**
	 * Sets the font size.
	 *
	 * @param size The size to set the font to.
	 */
	public function setSize(size:Int):Void
	{
		#if (lime_cffi && !macro)
		NativeCFFI.lime_font_set_size(src, size);
		#end
	}

	/**
	 * Renders a specific glyph to an image.
	 *
	 * @param glyph The glyph to render.
	 * @param flags Additional FreeType load flags to apply when rasterizing.
	 * @return An `Image` instance representing the rendered glyph.
	 */
	public function renderGlyph(glyph:Glyph, ?flags:Int = 0):Image
	{
		#if (lime_cffi && !macro)
		// Allocate an estimated buffer size
		var bytes:Bytes = Bytes.alloc(0);

		// Call native function to render glyph and get byte data
		bytes = NativeCFFI.lime_font_render_glyph(src, glyph, bytes, flags);

		if (bytes != null && bytes.length > 0)
		{
			var dataPosition = 0;

			// Extract glyph information from the byte array
			var index:Int = bytes.getInt32(dataPosition);
			dataPosition += 4;

			var width:Int = bytes.getInt32(dataPosition);
			dataPosition += 4;

			var height:Int = bytes.getInt32(dataPosition);
			dataPosition += 4;

			var x:Int = bytes.getInt32(dataPosition);
			dataPosition += 4;

			var y:Int = bytes.getInt32(dataPosition);
			dataPosition += 4;

			// Check if width and height are valid before proceeding
			if (width <= 0 || height <= 0)
			{
				return null;
			}

			// Extract pixel data from the byte array, accounting for 32-bit RGBA data
			var pitch = width * 4;

			// Create a new Bytes array to store the extracted bitmap data without padding
			var dataBytes = Bytes.alloc(width * height * 4);

			// Extract row by row to handle RGBA data
			for (i in 0...height)
			{
				dataBytes.blit(i * width * 4, bytes, dataPosition + (i * pitch), width * 4);
			}

			// Create ImageBuffer and Image from the extracted data
			var buffer = new ImageBuffer(new UInt8Array(dataBytes), width, height, 32);
			var image = new Image(buffer, 0, 0, width, height);
			image.x = x;
			image.y = y;

			return image;
		}
		#end

		return null;
	}

	/**
	 * Renders a set of glyphs to images.
	 *
	 * @param glyphs The glyphs to render.
	 * @param flags Additional FreeType load flags to apply when rasterizing.
	 * @return A `Map` containing glyphs mapped to their corresponding images.
	 */
	public function renderGlyphs(glyphs:Array<Glyph>, ?flags:Int = 0):Map<Glyph, Image>
	{
		#if (lime_cffi && !macro)
		var uniqueGlyphs = new Map<Int, Bool>();

		for (glyph in glyphs)
		{
			uniqueGlyphs.set(glyph, true);
		}

		var glyphList = [];

		for (key in uniqueGlyphs.keys())
		{
			glyphList.push(key);
		}

		// Allocate an estimated buffer size
		var bytes:Bytes = Bytes.alloc(0);

		// Call native function to render glyphs and get byte data
		bytes = NativeCFFI.lime_font_render_glyphs(src, glyphList, bytes, flags);

		if (bytes != null && bytes.length > 0)
		{
			var bytesPosition = 0;
			var count = bytes.getInt32(bytesPosition);
			bytesPosition += 4;

			var bufferWidth = 128;
			var bufferHeight = 128;
			var offsetX = 0;
			var offsetY = 0;
			var maxRows = 0;

			var width:Int;
			var height:Int;
			var i = 0;

			while (i < count)
			{
				bytesPosition += 4;
				width = bytes.getInt32(bytesPosition);
				bytesPosition += 4;
				height = bytes.getInt32(bytesPosition);
				bytesPosition += 4;

				bytesPosition += (4 * 2) + width * height;

				if (offsetX + width > bufferWidth)
				{
					offsetY += maxRows + 1;
					offsetX = 0;
					maxRows = 0;
				}

				if (offsetY + height > bufferHeight)
				{
					if (bufferWidth < bufferHeight)
					{
						bufferWidth *= 2;
					}
					else
					{
						bufferHeight *= 2;
					}

					offsetX = 0;
					offsetY = 0;
					maxRows = 0;
					bytesPosition = 4;
					i = 0;
					continue;
				}

				offsetX += width + 1;

				if (height > maxRows)
				{
					maxRows = height;
				}

				i++;
			}

			var map = new Map<Int, Image>();
			var buffer = new ImageBuffer(null, bufferWidth, bufferHeight, 8);
			var dataPosition = 0;
			var data = Bytes.alloc(bufferWidth * bufferHeight);

			bytesPosition = 4;
			offsetX = 0;
			offsetY = 0;
			maxRows = 0;

			var index:Int;
			var x:Int;
			var y:Int;
			var image:Image;

			for (i in 0...count)
			{
				index = bytes.getInt32(bytesPosition);
				bytesPosition += 4;
				width = bytes.getInt32(bytesPosition);
				bytesPosition += 4;
				height = bytes.getInt32(bytesPosition);
				bytesPosition += 4;
				x = bytes.getInt32(bytesPosition);
				bytesPosition += 4;
				y = bytes.getInt32(bytesPosition);
				bytesPosition += 4;

				if (offsetX + width > bufferWidth)
				{
					offsetY += maxRows + 1;
					offsetX = 0;
					maxRows = 0;
				}

				for (i in 0...height)
				{
					dataPosition = ((i + offsetY) * bufferWidth) + offsetX;
					data.blit(dataPosition, bytes, bytesPosition, width);
					bytesPosition += width;
				}

				image = new Image(buffer, offsetX, offsetY, width, height);
				image.x = x;
				image.y = y;

				map.set(index, image);

				offsetX += width + 1;

				if (height > maxRows)
				{
					maxRows = height;
				}
			}

			buffer.data = new UInt8Array(data);

			return map;
		}
		#end

		return null;
	}

	@:noCompletion private function __copyFrom(other:Font):Void
	{
		if (other != null)
		{
			ascender = other.ascender;
			descender = other.descender;
			height = other.height;
			name = other.name;
			numGlyphs = other.numGlyphs;
			src = other.src;
			underlinePosition = other.underlinePosition;
			underlineThickness = other.underlineThickness;
			unitsPerEM = other.unitsPerEM;

			__fontID = other.__fontID;
			__fontPath = other.__fontPath;
			__fontPathWithoutDirectory = other.__fontPathWithoutDirectory;

			#if (html5 && js)
			fontFace = other.fontFace;
			#end

			__init = true;
		}
	}

	@:noCompletion private function __fromBytes(bytes:Bytes, fontName:String = null):Void
	{
		__fontPath = __fontPathWithoutDirectory = null;

		#if (js && html5)
		if (bytes == null || bytes.length == 0) return; // i will not load an empty font bytes
		var ogName = fontName ?? name;
		__parseFontMetadata(bytes);


		if (ogName != null)
		{
			name = ogName;
		}

		// Just to be sure fonts from same family wont use their internal css crap in browser.
		if (name == null || name.length == 0)
		{
			var webFontName = "__lime_font_" + Std.string(__webFontID++);
			name = webFontName;
		}

		var descriptors:Dynamic = {
			weight: Std.string(__webFontWeight),
			style: __webFontStyle
		};

		fontFace = untyped js.Syntax.code("new FontFace({0}, {1}, {2})", name, bytes.getData(), descriptors);

		src = bytes;

		__webFontLoad = null;
		__init = true;
		#elseif (lime_cffi && !macro)
		src = NativeCFFI.lime_font_load_bytes(bytes);

		__initializeSource();
		#end
	}

	@:noCompletion private function __fromFile(path:String):Void
	{
		#if (js && html5)
		var bytes:Bytes = null;

		if (Assets.exists(path))
		{
			bytes = Assets.getBytes(path);
		}

		if (bytes != null)
		{
			var fileName = Path.withoutDirectory(Path.withoutExtension(path));
			__fromBytes(bytes, fileName);
			src = bytes;
		} else {
			src = null;
			__init = true;
		}
		#elseif (lime_cffi && !macro)
		src = NativeCFFI.lime_font_load_file(path);

		__initializeSource();
		#end
		__fontPath = path;
		__fontPathWithoutDirectory = Path.withoutDirectory(__fontPath);
	}

	@:noCompletion private function __initializeSource():Void
	{
		#if (lime_cffi && !macro)
		if (src != null)
		{
			if (name == null)
			{
				name = NativeCFFI.lime_font_get_family_name(src);
			}

			ascender = NativeCFFI.lime_font_get_ascender(src);
			descender = NativeCFFI.lime_font_get_descender(src);
			height = NativeCFFI.lime_font_get_height(src);
			numGlyphs = NativeCFFI.lime_font_get_num_glyphs(src);
			underlinePosition = NativeCFFI.lime_font_get_underline_position(src);
			underlineThickness = NativeCFFI.lime_font_get_underline_thickness(src);
			strikethroughPosition = NativeCFFI.lime_font_get_strikethrough_position(src);
			strikethroughThickness = NativeCFFI.lime_font_get_strikethrough_thickness(src);
			unitsPerEM = NativeCFFI.lime_font_get_units_per_em(src);
		}
		#end

		__init = true;
	}

	#if (js && html5)
	@:noCompletion private function __loadWebFont():Future<Font>
	{
		if (fontFace == null && name != null)
		{
			return __loadFromName(name);
		}

		if (__webFontLoad != null)
			return __webFontLoad;

		var promise = new Promise<Font>();
		__webFontLoad = promise.future;

		if (fontFace == null)
		{
			promise.error("Could not load web font \"" + name + "\": missing FontFace");
			return __webFontLoad;
		}

		untyped fontFace.load().then(function(_)
		{
			untyped Browser.document.fonts.add(fontFace);
			promise.complete(this);
		}, function(error)
		{
			Log.warn("Could not load web font \"" + name + "\": " + Std.string(error));
			promise.error("Could not load web font \"" + name + "\": " + Std.string(error));
		});

		return __webFontLoad;
	}
	#end

	@:noCompletion private function __loadFromName(name:String):Future<Font>
	{
		var promise = new Promise<Font>();

		#if (js && html5)
		this.name = name;

		var userAgent = Browser.navigator.userAgent.toLowerCase();
		var isSafari = (userAgent.indexOf(" safari/") >= 0 && userAgent.indexOf(" chrome/") < 0);
		var isUIWebView = ~/(iPhone|iPod|iPad).*AppleWebKit(?!.*Version)/i.match(userAgent);

		if (!isSafari && !isUIWebView && untyped (Browser.document).fonts && untyped (Browser.document).fonts.load)
		{
			untyped (Browser.document).fonts.load("1em \"" + name + "\"").then(function(_)
			{
				promise.complete(this);
			}, function(error)
			{
				Log.warn("Could not load web font \"" + name + "\": " + Std.string(error));
				promise.error("Could not load web font \"" + name + "\": " + Std.string(error));
			});
		}
		else
		{
			var node1 = __measureFontNode("'" + name + "', sans-serif");
			var node2 = __measureFontNode("'" + name + "', serif");

			var width1 = node1.offsetWidth;
			var width2 = node2.offsetWidth;

			var interval = -1;
			var timeout = 3000;
			var intervalLength = 50;
			var intervalCount = 0;
			var loaded:Bool;
			var timeExpired:Bool;

			var checkFont = function()
			{
				intervalCount++;

				loaded = (node1.offsetWidth != width1 || node2.offsetWidth != width2);
				timeExpired = (intervalCount * intervalLength >= timeout);

				if (loaded || timeExpired)
				{
					Browser.window.clearInterval(interval);
					node1.parentNode.removeChild(node1);
					node2.parentNode.removeChild(node2);
					node1 = null;
					node2 = null;

					if (timeExpired)
					{
						Log.warn("Could not load web font \"" + name + "\"");
					}

					promise.complete(this);
				}
			}

			interval = Browser.window.setInterval(checkFont, intervalLength);
		}
		#else
		promise.error("");
		#end

		return promise.future;
	}

	#if (js && html5)
	private static function __measureFontNode(fontFamily:String):SpanElement
	{
		var node:SpanElement = cast Browser.document.createElement("span");
		node.setAttribute("aria-hidden", "true");
		var text = Browser.document.createTextNode("BESbswy");
		node.appendChild(text);
		var style = node.style;
		style.display = "block";
		style.position = "absolute";
		style.top = "-9999px";
		style.left = "-9999px";
		style.fontSize = "300px";
		style.width = "auto";
		style.height = "auto";
		style.lineHeight = "normal";
		style.margin = "0";
		style.padding = "0";
		style.fontVariant = "normal";
		style.whiteSpace = "nowrap";
		style.fontFamily = fontFamily;
		Browser.document.body.appendChild(node);
		return node;
	}

	// Doing it manually because HTML doesn't have any api to do that
	@:noCompletion private function __parseFontMetadata(bytes:Bytes):Void
	{
		if (bytes == null || bytes.length < 12)
			return;

		var sfntOffset = 0;

		if (__readTag(bytes, 0) == "ttcf")
		{
			if (bytes.length < 16)
				return;

			sfntOffset = __readUInt32(bytes, 12);

			if (sfntOffset < 0 || sfntOffset + 12 > bytes.length)
				return;
		}

		if (sfntOffset + 12 > bytes.length)
			return;

		var sfVersion = __readUInt32(bytes, sfntOffset);

		// Valid SFNT versions:
		// 0x00010000 = TrueType
		// 0x4F54544F = "OTTO" = OpenType/CFF
		// 0x74727565 = "true"
		// 0x74797031 = "typ1"
		// These aren't colors btw
		if (sfVersion != 0x00010000 && sfVersion != 0x4F54544F && sfVersion != 0x74727565 && sfVersion != 0x74797031)
		{
			return;
		}

		var numTables = __readUInt16(bytes, sfntOffset + 4);

		var tableDirectory = sfntOffset + 12;

		if (tableDirectory + numTables * 16 > bytes.length)
			return;

		var headOffset = -1;
		var hheaOffset = -1;
		var maxpOffset = -1;
		var nameOffset = -1;
		var postOffset = -1;
		var os2Offset = -1;

		for (i in 0...numTables)
		{
			var recordOffset = tableDirectory + i * 16;

			var tag = __readTag(bytes, recordOffset);
			var offset = __readUInt32(bytes, recordOffset + 8);
			var length = __readUInt32(bytes, recordOffset + 12);

			// Prevent malformed fonts from causing out-of-range access.
			if (offset < 0 || length < 0 || offset > bytes.length || length > bytes.length - offset)
			{
				continue;
			}

			switch (tag)
			{
				case "head":
					headOffset = offset;

				case "hhea":
					hheaOffset = offset;

				case "maxp":
					maxpOffset = offset;

				case "name":
					nameOffset = offset;

				case "post":
					postOffset = offset;

				case "OS/2":
					os2Offset = offset;
			}
		}

		if (headOffset >= 0 && headOffset + 46 <= bytes.length)
		{
			unitsPerEM = __readUInt16(bytes, headOffset + 18);

			// macStyle bit 1 = italic
			if ((__readUInt16(bytes, headOffset + 44) & 0x0002) != 0)
			{
				__webFontStyle = "italic";
			}

			// Avoid invalid zero values.
			if (unitsPerEM <= 0)
			{
				unitsPerEM = 1;
			}
		}

		if (hheaOffset >= 0 && hheaOffset + 10 <= bytes.length)
		{
			ascender = __readInt16(bytes, hheaOffset + 4);
			descender = __readInt16(bytes, hheaOffset + 6);

			var lineGap = __readInt16(bytes, hheaOffset + 8);

			height = ascender - descender + lineGap;

			if (height < 0)
			{
				height = 0;
			}
		}

		if (maxpOffset >= 0 && maxpOffset + 6 <= bytes.length)
		{
			numGlyphs = __readUInt16(bytes, maxpOffset + 4);
		}

		if (postOffset >= 0 && postOffset + 12 <= bytes.length)
		{
			underlinePosition = __readInt16(bytes, postOffset + 8);
			underlineThickness = __readInt16(bytes, postOffset + 10);
		}

		if (nameOffset >= 0)
		{
			var fontName = __readFontName(bytes, nameOffset);

			if (fontName != null && fontName.length > 0)
			{
				name = fontName;
			}
		}

		if (os2Offset >= 0 && os2Offset + 30 <= bytes.length)
		{
			// OS/2 usWeightClass
			var weight = __readUInt16(bytes, os2Offset + 4);
			if (weight >= 1 && weight <= 1000)
			{
				__webFontWeight = weight;
			}

			// OS/2 fsSelection bit 0 = italic
			if (os2Offset + 64 <= bytes.length && (__readUInt16(bytes, os2Offset + 62) & 0x0001) != 0)
			{
				__webFontStyle = "italic";
			}

			strikethroughThickness = __readUInt16(bytes, os2Offset + 26);
			strikethroughPosition = __readInt16(bytes, os2Offset + 28);
		}
		else
		{
			strikethroughPosition = Std.int(unitsPerEM * 0.25);
			strikethroughThickness = Std.int(unitsPerEM * 0.05);
		}
	}

	@:noCompletion private static function __readFontName(bytes:Bytes, tableOffset:Int):String
	{
		if (tableOffset < 0 || tableOffset + 6 > bytes.length)
			return null;

		var count = __readUInt16(bytes, tableOffset + 2);
		var stringOffset = __readUInt16(bytes, tableOffset + 4);

		var recordsOffset = tableOffset + 6;

		if (recordsOffset + count * 12 > bytes.length)
			return null;

		var bestName:String = null;
		var bestScore:Int = -1;

		for (i in 0...count)
		{
			var recordOffset = recordsOffset + i * 12;

			var platformID = __readUInt16(bytes, recordOffset);
			var encodingID = __readUInt16(bytes, recordOffset + 2);
			var languageID = __readUInt16(bytes, recordOffset + 4);
			var nameID = __readUInt16(bytes, recordOffset + 6);
			var length = __readUInt16(bytes, recordOffset + 8);
			var offset = __readUInt16(bytes, recordOffset + 10);

			// Name ID 1 = Font Family Name
			if (nameID != 1)
				continue;

			var stringStart = tableOffset + stringOffset + offset;

			if (stringStart < 0 || stringStart > bytes.length || length > bytes.length - stringStart)
			{
				continue;
			}

			var value:String = null;
			var score = 0;

			// Windows Unicode
			if (platformID == 3)
			{
				value = __decodeUTF16BE(bytes, stringStart, length);
				score = 100;

				// Prefer English (US)
				if (languageID == 0x0409)
					score += 10;
			}
			// Unicode platform
			else if (platformID == 0)
			{
				value = __decodeUTF16BE(bytes, stringStart, length);
				score = 90;
			}
			// Macintosh Roman
			else if (platformID == 1 && encodingID == 0)
			{
				value = __decodeMacRoman(bytes, stringStart, length);
				score = 80;

				// Macintosh English
				if (languageID == 0)
				{
					score += 10;
				}
			}

			if (value == null)
			{
				continue;
			}

			value = StringTools.trim(value);

			if (value.length == 0)
			{
				continue;
			}

			if (score > bestScore)
			{
				bestScore = score;
				bestName = value;
			}
		}

		return bestName;
	}

	@:noCompletion private static inline function __readUInt16(bytes:Bytes, offset:Int):Int
	{
		return (bytes.get(offset) << 8) | bytes.get(offset + 1);
	}

	@:noCompletion private static inline function __readInt16(bytes:Bytes, offset:Int):Int
	{
		var value = (bytes.get(offset) << 8) | bytes.get(offset + 1);

		if (value & 0x8000 != 0)
			value -= 0x10000;

		return value;
	}

	@:noCompletion private static inline function __readUInt32(bytes:Bytes, offset:Int):Int
	{
		return (bytes.get(offset) << 24) | (bytes.get(offset + 1) << 16) | (bytes.get(offset + 2) << 8) | bytes.get(offset + 3);
	}

	@:noCompletion private static function __readTag(bytes:Bytes, offset:Int):String
	{
		var result = new StringBuf();

		result.add(String.fromCharCode(bytes.get(offset)));
		result.add(String.fromCharCode(bytes.get(offset + 1)));
		result.add(String.fromCharCode(bytes.get(offset + 2)));
		result.add(String.fromCharCode(bytes.get(offset + 3)));

		return result.toString();
	}

	@:noCompletion private static function __decodeUTF16BE(bytes:Bytes, offset:Int, length:Int):String
	{
		if (length <= 0 || (length & 1) != 0)
			return null;

		var result = new StringBuf();

		var end = offset + length;
		var position = offset;

		while (position + 1 < end)
		{
			var code = __readUInt16(bytes, position);
			position += 2;

			result.add(String.fromCharCode(code));
		}

		return result.toString();
	}

	@:noCompletion private static function __decodeASCII(bytes:Bytes, offset:Int, length:Int):String
	{
		if (length <= 0)
			return null;

		var result = new StringBuf();

		for (i in 0...length)
		{
			var value = bytes.get(offset + i);

			if (value == 0)
				continue;

			if (value >= 32 && value <= 126)
				result.add(String.fromCharCode(value));
			else
				result.add("?");
		}

		return result.toString();
	}

	@:noCompletion private static function __decodeMacRoman(bytes:Bytes, offset:Int, length:Int):String
	{
		if (length <= 0)
			return null;

		var result = new StringBuf();

		for (i in 0...length)
		{
			var value = bytes.get(offset + i);

			if (value < 128)
			{
				result.add(String.fromCharCode(value));
				continue;
			}

			/*
			 * Macintosh Roman 128-255.
			 *
			 * This table contains the standard MacRoman Unicode mapping.
			 */
			var map = [
				0x00C4, 0x00C5, 0x00C7, 0x00C9, 0x00D1, 0x00D6, 0x00DC, 0x00E1,
				0x00E0, 0x00E2, 0x00E4, 0x00E3, 0x00E5, 0x00E7, 0x00E9, 0x00E8,
				0x00EA, 0x00EB, 0x00ED, 0x00EC, 0x00EE, 0x00EF, 0x00F1, 0x00F3,
				0x00F2, 0x00F4, 0x00F6, 0x00F5, 0x00FA, 0x00F9, 0x00FB, 0x00FC,
				0x00A8, 0x00B0, 0x00C6, 0x00D8, 0x00C7, 0x00D8, 0x00A5, 0x00B5,
				0x00E6, 0x00F8, 0x00C9, 0x00C9, 0x00AA, 0x00BA, 0x00E9, 0x00F1,
				0x00A1, 0x00BF, 0x00AC, 0x00A9, 0x00A3, 0x00A5, 0x00D6, 0x00DC,
				0x00A2, 0x00A7, 0x00F4, 0x00F6, 0x00F2, 0x00F3, 0x00F5, 0x00FA,
				0x00F9, 0x00FB, 0x00FC, 0x00A1, 0x00BF, 0x00B0, 0x00B2, 0x00B3,
				0x00B4, 0x00A8, 0x00B7, 0x00B6, 0x00C0, 0x00C3, 0x00D5, 0x0152,
				0x0153, 0x2013, 0x2014, 0x201C, 0x201D, 0x2018, 0x2019, 0x00F7,
				0x25CA, 0x00FF, 0x0178, 0x2044, 0x20AC, 0x2039, 0x203A, 0xFB01,
				0xFB02, 0x2020, 0x2021, 0x00B7, 0x00B6, 0x201A, 0x201E, 0x2030,
				0x00C2, 0x00CA, 0x00C1, 0x00CB, 0x00C8, 0x00CD, 0x00CE, 0x00CF,
				0x00CC, 0x00D3, 0x00D4, 0xF8FF, 0x00D2, 0x00DA, 0x00DB, 0x00D9,
				0x0131, 0x02C6, 0x02DC, 0x00AF, 0x02D8, 0x02D9, 0x02DA, 0x00B8,
				0x02DD, 0x02DB, 0x02C7, 0x2014, 0x00C3, 0x00D5, 0x00A0, 0x00C0,
				0x00C2, 0x00CA, 0x00C1, 0x00CB, 0x00C8, 0x00CD, 0x00CE, 0x00CF,
				0x00CC, 0x00D3, 0x00D4, 0x00D2, 0x00DA, 0x00DB, 0x00D9, 0x00D5,
				0x00D0, 0x00D1, 0x00D2, 0x00D3, 0x00D4, 0x00D5, 0x00D6, 0x00D7,
				0x00D8, 0x00D9, 0x00DA, 0x00DB, 0x00DC, 0x00DD, 0x00DE, 0x00DF,
				0x00E0, 0x00E1, 0x00E2, 0x00E3, 0x00E4, 0x00E5, 0x00E6, 0x00E7,
				0x00E8, 0x00E9, 0x00EA, 0x00EB, 0x00EC, 0x00ED, 0x00EE, 0x00EF,
				0x00F0, 0x00F1, 0x00F2, 0x00F3, 0x00F4, 0x00F5, 0x00F6, 0x00F7,
				0x00F8, 0x00F9, 0x00FA, 0x00FB, 0x00FC, 0x00FD, 0x00FE, 0x00FF
			];

			var index = value - 128;

			if (index >= 0 && index < map.length)
				result.add(String.fromCharCode(map[index]));
			else
				result.add("\uFFFD");
		}

		return result.toString();
	}
	#end
}
