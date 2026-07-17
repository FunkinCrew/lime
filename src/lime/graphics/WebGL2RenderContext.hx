package lime.graphics;

#if (lime_webgl && !doc_gen)
import lime._internal.backend.html5.HTML5WebGL2RenderContext;
import lime.graphics.opengl.*;
import lime.utils.DataPointer;

@:access(lime.graphics.RenderContext)
@:forward()
@:transitive
abstract WebGL2RenderContext(HTML5WebGL2RenderContext) from HTML5WebGL2RenderContext to HTML5WebGL2RenderContext
{
	public inline function bufferData(target:Int, srcData:Dynamic, usage:Int, ?srcOffset:Int, ?length:Int):Void
	{
		if (srcOffset != null)
		{
			this.bufferData(target, srcData, usage, srcOffset, length);
		}
		else
		{
			this.bufferData(target, srcData, usage);
		}
	}

	public inline function bufferSubData(target:Int, dstByteOffset:Int, srcData:Dynamic, ?srcOffset:Int, ?length:Int):Void
	{
		if (srcOffset != null)
		{
			this.bufferSubData(target, dstByteOffset, srcData, srcOffset, length);
		}
		else
		{
			this.bufferSubData(target, dstByteOffset, srcData);
		}
	}

	public inline function compressedTexImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, srcData:Dynamic, ?srcOffset:Int,
			?srcLengthOverride:Int):Void
	{
		if (srcOffset != null)
		{
			this.compressedTexImage2D(target, level, internalformat, width, height, border, srcData, srcOffset, srcLengthOverride);
		}
		else
		{
			this.compressedTexImage2D(target, level, internalformat, width, height, border, srcData);
		}
	}

	public inline function compressedTexSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, srcData:Dynamic,
			?srcOffset:Int, ?srcLengthOverride:Int):Void
	{
		if (srcOffset != null)
		{
			this.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, srcData, srcOffset, srcLengthOverride);
		}
		else
		{
			this.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, srcData);
		}
	}

	public inline function getBufferSubData(target:Int, srcByteOffset:DataPointer, dstData:Dynamic, ?srcOffset:Dynamic, ?length:Int):Void
	{
		if (srcOffset != null)
		{
			this.getBufferSubData(target, srcByteOffset, dstData, srcOffset, length);
		}
		else
		{
			this.getBufferSubData(target, srcByteOffset, dstData);
		}
	}

	public inline function readPixels(x:Int, y:Int, width:Int, height:Int, format:Int, type:Int, pixels:Dynamic, ?dstOffset:Int):Void
	{
		if (dstOffset != null)
		{
			this.readPixels(x, y, width, height, format, type, pixels, dstOffset);
		}
		else
		{
			this.readPixels(x, y, width, height, format, type, pixels);
		}
	}

	public inline function texImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Dynamic, ?format:Int, ?type:Int,
			?srcData:Dynamic, ?srcOffset:Int):Void
	{
		if (srcOffset != null)
		{
			this.texImage2D(target, level, internalformat, width, height, border, format, type, srcData, srcOffset);
		}
		else if (format != null)
		{
			this.texImage2D(target, level, internalformat, width, height, border, format, type, srcData);
		}
		else
		{
			this.texImage2D(target, level, internalformat, width, height, border); // target, level, internalformat, format, type, pixels
		}
	}

	public inline function texSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Dynamic, ?type:Int, ?srcData:Dynamic,
			?srcOffset:Int):Void
	{
		if (srcOffset != null)
		{
			this.texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, srcData, srcOffset);
		}
		else if (type != null)
		{
			this.texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, srcData);
		}
		else
		{
			this.texSubImage2D(target, level, xoffset, yoffset, width, height, format); // target, level, xoffset, yoffset, format, type, pixels
		}
	}

	public inline function uniform1fv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform1fv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform1fv(location, data);
		}
	}

	public inline function uniform1iv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform1iv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform1iv(location, data);
		}
	}

	public function uniform2fv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform2fv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform2fv(location, data);
		}
	}

	public inline function uniform2iv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform2iv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform2iv(location, data);
		}
	}

	public inline function uniform3fv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform3fv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform3fv(location, data);
		}
	}

	public inline function uniform3iv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform3iv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform3iv(location, data);
		}
	}

	public inline function uniform4fv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform4fv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform4fv(location, data);
		}
	}

	public inline function uniform4iv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform4iv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform4iv(location, data);
		}
	}

	public inline function uniformMatrix2fv(location:GLUniformLocation, transpose:Bool, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniformMatrix2fv(location, transpose, data, srcOffset, srcLength);
		}
		else
		{
			this.uniformMatrix2fv(location, transpose, data);
		}
	}

	public inline function uniformMatrix3fv(location:GLUniformLocation, transpose:Bool, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniformMatrix3fv(location, transpose, data, srcOffset, srcLength);
		}
		else
		{
			this.uniformMatrix3fv(location, transpose, data);
		}
	}

	public inline function uniformMatrix4fv(location:GLUniformLocation, transpose:Bool, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniformMatrix4fv(location, transpose, data, srcOffset, srcLength);
		}
		else
		{
			this.uniformMatrix4fv(location, transpose, data);
		}
	}

	@:from private static function fromGL(gl:Class<GL>):WebGL2RenderContext
	{
		return null;
	}

	@:from private static function fromRenderContext(context:RenderContext):WebGL2RenderContext
	{
		return context.webgl2;
	}

	@:from private static function toWebGLRenderContext(gl:WebGLRenderContext):WebGL2RenderContext
	{
		return cast gl;
	}
}
#else
@:forward()
@:transitive
abstract WebGL2RenderContext(Dynamic) from Dynamic to Dynamic
{
	@:from private static function fromRenderContext(context:RenderContext):WebGL2RenderContext
	{
		return null;
	}
}
#end
