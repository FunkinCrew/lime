package lime._internal.backend.native;

import haxe.Http;
import haxe.Timer;
import haxe.io.Bytes;
import haxe.io.BytesOutput;

import lime.app.Future;
import lime.app.Promise;
import lime.net.HTTPRequest;
import lime.system.ThreadPool;
import lime.system.WorkOutput;

class NativeHTTPRequest
{
	private static var localThreadPool:ThreadPool;
	private static var httpThreadPool:ThreadPool;
	private static var cookieList:Array<String>;

	private var bytes:Bytes;
	private var bytesLoaded:Int;
	private var bytesTotal:Int;
	private var canceled:Bool;
	private var parent:_IHTTPRequest;
	private var promise:Promise<Bytes>;
	private var timeout:Timer;

	public function new()
	{
		timeout = null;
	}

	public function cancel():Void
	{
		canceled = true;

		if (timeout != null)
		{
			timeout.stop();
			timeout = null;
		}
	}

	public function init(parent:_IHTTPRequest):Void
	{
		this.parent = parent;
	}

	public function loadData(uri:String, binary:Bool = true):Future<Bytes>
	{
		if (uri == null)
		{
			return cast Future.withError("The URI must not be null");
		}

		var promise:Promise<Bytes> = new Promise<Bytes>();

		this.promise = promise;

		canceled = false;

		if (uri.indexOf("http://") == -1 && uri.indexOf("https://") == -1)
		{
			if (localThreadPool == null)
			{
				localThreadPool = new ThreadPool(0, 1);
				localThreadPool.onProgress.add(localThreadPool_onProgress);
				localThreadPool.onComplete.add(localThreadPool_onComplete);
				localThreadPool.onError.add(localThreadPool_onError);
			}

			localThreadPool.run(localThreadPool_doWork, {instance: this, uri: uri});
		}
		else
		{
			if (httpThreadPool == null)
			{
				httpThreadPool = new ThreadPool(0, 4);
				httpThreadPool.onProgress.add(httpThreadPool_onProgress);
				httpThreadPool.onComplete.add(httpThreadPool_onComplete);
				httpThreadPool.onError.add(httpThreadPool_onError);
			}

			httpThreadPool.run(httpThreadPool_doWork, {instance: this, uri: uri, binary: binary});
		}

		return promise.future;
	}

	public function loadText(uri:String):Future<String>
	{
		var promise:Promise<String> = new Promise<String>();
		var future:Future<Bytes> = loadData(uri, false);

		future.onProgress(promise.progress);
		future.onError(promise.error);
		future.onComplete(function(bytes:Bytes):Void
		{
			if (bytes == null)
			{
				promise.complete(null);
			}
			else
			{
				promise.complete(bytes.getString(0, bytes.length));
			}
		});

		return promise.future;
	}

	private static function localThreadPool_doWork(state:Dynamic, output:WorkOutput):Void
	{
		var typedState:LocalWorkState = state;
		var instance:NativeHTTPRequest = typedState.instance;
		var path:String = typedState.uri;

		instance.bytes = lime.utils.Bytes.fromFile(path);

		if (instance.bytes != null)
		{
			output.sendProgress({
				instance: instance,
				promise: instance.promise,
				bytesLoaded: instance.bytes.length,
				bytesTotal: instance.bytes.length
			});
			output.sendComplete({instance: instance, promise: instance.promise, result: instance.bytes});
		}
		else
		{
			output.sendError({instance: instance, promise: instance.promise, error: "Cannot load file: " + path});
		}
	}

	private static function localThreadPool_onComplete(state:LocalCompleteState):Void
	{
		var promise:Promise<Bytes> = state.promise;

		if (promise.isError)
		{
			return;
		}

		promise.complete(state.result);

		var instance:NativeHTTPRequest = state.instance;

		if (instance.timeout != null)
		{
			instance.timeout.stop();
			instance.timeout = null;
		}

		instance.bytes = null;
		instance.promise = null;
	}

	private static function localThreadPool_onError(state:LocalErrorState):Void
	{
		var promise:Promise<Bytes> = state.promise;

		promise.error(new _HTTPRequestErrorResponse(state.error, null));

		var instance:NativeHTTPRequest = state.instance;

		if (instance.timeout != null)
		{
			instance.timeout.stop();
			instance.timeout = null;
		}

		instance.bytes = null;
		instance.promise = null;
	}

	private static function localThreadPool_onProgress(state:LocalProgressState):Void
	{
		var promise:Promise<Bytes> = state.promise;

		if (promise.isComplete || promise.isError)
		{
			return;
		}

		promise.progress(state.bytesLoaded, state.bytesTotal);
	}

	private static function httpThreadPool_doWork(state:Dynamic, output:WorkOutput):Void
	{
		var typedState:HttpWorkState = state;
		var instance:NativeHTTPRequest = typedState.instance;
		var uri:String = typedState.uri;
		var parent:_IHTTPRequest = instance.parent;
		var http:Http = new Http(uri);
		var data:Bytes = parent.data;

		if (data == null && parent.formData != null)
		{
			for (key in parent.formData.keys())
			{
				http.setParameter(key, Std.string(parent.formData.get(key)));
			}
		}

		if (data != null)
		{
			http.setPostData(data.toString());
		}

		var contentType:String = parent.contentType;

		if (parent.headers != null)
		{
			for (header in parent.headers)
			{
				if (header.name == "Content-Type")
				{
					contentType = header.value;
				}
				else
				{
					http.setHeader(header.name, header.value);
				}
			}
		}

		if (contentType != null)
		{
			http.setHeader("Content-Type", contentType);
		}

		if (parent.userAgent != null)
		{
			http.setHeader("User-Agent", parent.userAgent);
		}

		if (parent.manageCookies && cookieList != null && cookieList.length > 0)
		{
			http.setHeader("Cookie", cookieList.join("; "));
		}

		var responseStatus:Int = 0;
		var responseOutput:BytesOutput = new BytesOutput();

		http.onStatus = function(status:Int):Void
		{
			responseStatus = status;
		};

		http.onBytes = function(bytes:Bytes):Void
		{
			if (bytes != null && bytes.length > 0)
			{
				responseOutput.writeBytes(bytes, 0, bytes.length);
			}
		};

		try
		{
			var methodStr:String = Std.string(parent.method).toUpperCase();
			var hasPostData:Bool = (data != null || parent.formData != null);
			var isPost:Bool = (methodStr == "POST" || methodStr == "PUT" || hasPostData);

			http.customRequest(isPost, responseOutput, null, methodStr);

			var resultBytes:Bytes = responseOutput.getBytes();

			output.sendProgress({
				instance: instance,
				promise: instance.promise,
				bytesLoaded: resultBytes.length,
				bytesTotal: resultBytes.length
			});

			output.sendComplete({
				instance: instance,
				promise: instance.promise,
				status: responseStatus,
				result: resultBytes
			});
		}
		catch (e:Dynamic)
		{
			output.sendError({
				instance: instance,
				promise: instance.promise,
				status: responseStatus,
				error: Std.string(e),
				responseData: responseOutput.getBytes()
			});
		}
	}

	private static function httpThreadPool_onComplete(state:HttpCompleteState):Void
	{
		var instance:NativeHTTPRequest = state.instance;

		if (instance.canceled)
		{
			return;
		}

		var promise:Promise<Bytes> = state.promise;

		if (promise.isError)
		{
			return;
		}

		instance.parent.responseStatus = state.status;

		if ((state.status >= 200 && state.status < 400) || state.status == 0)
		{
			promise.complete(state.result);
		}
		else
		{
			promise.error(new _HTTPRequestErrorResponse("Status " + state.status, state.result));
		}

		cleanup(instance);
	}

	private static function httpThreadPool_onError(state:HttpErrorState):Void
	{
		var instance:NativeHTTPRequest = state.instance;

		if (instance.canceled)
		{
			return;
		}

		var promise:Promise<Bytes> = state.promise;

		promise.error(new _HTTPRequestErrorResponse(state.error, null));

		instance.parent.responseStatus = state.status;

		cleanup(instance);
	}

	private static function httpThreadPool_onProgress(state:HttpProgressState):Void
	{
		var instance:NativeHTTPRequest = state.instance;

		if (instance.canceled)
		{
			return;
		}

		var promise:Promise<Bytes> = state.promise;

		if (promise.isComplete || promise.isError)
		{
			return;
		}

		promise.progress(state.bytesLoaded, state.bytesTotal);
	}

	private static function cleanup(instance:NativeHTTPRequest):Void
	{
		if (instance.timeout != null)
		{
			instance.timeout.stop();
			instance.timeout = null;
		}

		instance.bytes = null;
		instance.promise = null;
	}
}

private typedef LocalWorkState =
{
	var instance:NativeHTTPRequest;
	var uri:String;
}

private typedef LocalCompleteState =
{
	var instance:NativeHTTPRequest;
	var promise:Promise<Bytes>;
	var result:Bytes;
}

private typedef LocalErrorState =
{
	var instance:NativeHTTPRequest;
	var promise:Promise<Bytes>;
	var error:String;
}

private typedef LocalProgressState =
{
	var instance:NativeHTTPRequest;
	var promise:Promise<Bytes>;
	var bytesLoaded:Int;
	var bytesTotal:Int;
}

private typedef HttpWorkState =
{
	var instance:NativeHTTPRequest;
	var uri:String;
	@:optional var binary:Bool;
}

private typedef HttpCompleteState =
{
	var instance:NativeHTTPRequest;
	var promise:Promise<Bytes>;
	var status:Int;
	var result:Bytes;
}

private typedef HttpErrorState =
{
	var instance:NativeHTTPRequest;
	var promise:Promise<Bytes>;
	var status:Int;
	var error:String;
	var responseData:Bytes;
}

private typedef HttpProgressState =
{
	var instance:NativeHTTPRequest;
	var promise:Promise<Bytes>;
	var bytesLoaded:Int;
	var bytesTotal:Int;
}
