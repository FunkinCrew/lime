package lime.graphics.opengl;

#if (!lime_doc_gen || lime_webgl)
#if (lime_webgl && !doc_gen)
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLShader;
import lime.graphics.WebGLRenderContext;
import lime.utils.Log;

@:forward()
abstract GLProgram(js.html.webgl.Program) from js.html.webgl.Program to js.html.webgl.Program
{
	public static function fromSources(gl:WebGLRenderContext, vertexSource:String, fragmentSource:String):GLProgram
	{
		var vertexShader = GLShader.fromSource(gl, vertexSource, gl.VERTEX_SHADER);
		var fragmentShader = GLShader.fromSource(gl, fragmentSource, gl.FRAGMENT_SHADER);

		var program = gl.createProgram();
		gl.attachShader(program, vertexShader);
		gl.attachShader(program, fragmentShader);
		gl.linkProgram(program);

		if (gl.getProgramParameter(program, GL.LINK_STATUS) == 0)
		{
			var message = "Unable to initialize the shader program";
			message += "\n" + GL.getProgramInfoLog(program);
			Log.error(message);
		}

		return program;
	}
}
#else
@:forward abstract GLProgram(Dynamic) from Dynamic to Dynamic
{
	public static function fromSources(gl:Dynamic, vertexSource:String, fragmentSource:String):GLProgram
	{
		return null;
	}
}
#end
#end
