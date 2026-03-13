package;

import ::APP_MAIN::;

@:access(lime.app.Application)
@:access(lime.system.System)

@:dox(hide) class ApplicationMain
{
	public static function main()
	{
		lime.system.System.__registerEntryPoint("::APP_FILE::", create);

		#if (!html5 || munit)
		create(null);
		#end
	}

	public static function create(config:Dynamic):Void
	{
		#if !disable_preloader_assets
		ManifestResources.init(config);
		#end

		#if !munit

		::if (WIN_ORIENTATION != "auto")::
		lime.system.System.setHint("ORIENTATIONS", ::if (WIN_ORIENTATION == "portrait")::"Portrait PortraitUpsideDown"::else::"LandscapeLeft LandscapeRight"::end::);
		::end::

		final appMeta:Map<String, String> = [];

		appMeta.set("build", "::meta.buildNumber::");
		appMeta.set("company", "::meta.company::");
		appMeta.set("file", "::APP_FILE::");
		appMeta.set("name", "::meta.title::");
		appMeta.set("packageName", "::meta.packageName::");
		appMeta.set("version", "::meta.version::");

		var app = new ::APP_MAIN::(appMeta);

		::foreach windows::
		var attributes:lime.ui.WindowAttributes =
			{
				allowHighDPI: ::allowHighDPI::,
				alwaysOnTop: ::alwaysOnTop::,
				transparent: ::transparent::,
				borderless: ::borderless::,
				// display: ::display::,
				element: null,
				frameRate: ::fps::,
				#if !web fullscreen: ::fullscreen::, #end
				height: ::height::,
				hidden: #if munit true #else ::hidden:: #end,
				maximized: ::maximized::,
				minimized: ::minimized::,
				parameters: ::parameters::,
				resizable: ::resizable::,
				title: "::title::",
				width: ::width::,
				x: ::x::,
				y: ::y::,
			};

		attributes.context =
			{
				antialiasing: ::antialiasing::,
				background: ::background::,
				colorDepth: ::colorDepth::,
				depth: ::depthBuffer::,
				hardware: ::hardware::,
				stencil: ::stencilBuffer::,
				type: null,
				vsync: ::vsync::
			};

		if (app.window == null)
		{
			if (config != null)
			{
				for (field in Reflect.fields(config))
				{
					if (Reflect.hasField(attributes, field))
					{
						Reflect.setField(attributes, field, Reflect.field(config, field));
					}
					else if (Reflect.hasField(attributes.context, field))
					{
						Reflect.setField(attributes.context, field, Reflect.field(config, field));
					}
				}
			}

			#if sys
			lime.system.System.__parseArguments(attributes);
			#end
		}

		app.createWindow(attributes);
		::end::
		#else
		app.window.context.attributes.background = ::WIN_BACKGROUND::;
		app.window.frameRate = ::WIN_FPS::;
		#end

		// preloader.create ();

		#if !disable_preloader_assets
		for (library in ManifestResources.preloadLibraries)
		{
			app.preloader.addLibrary(library);
		}

		for (name in ManifestResources.preloadLibraryNames)
		{
			app.preloader.addLibraryName(name);
		}
		#end

		app.preloader.load();

		#if !munit
		start(app);
		#end
	}

	public static function start(app:lime.app.Application = null):Void
	{
		#if !munit

		var result = app.exec();

		#if (sys && !ios && !webassembly)
		lime.system.System.exit(result);
		#end

		#else

		new ::APP_MAIN::();

		#end
	}
}
