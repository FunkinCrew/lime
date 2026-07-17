package lime.graphics.opengl;

#if (!lime_doc_gen || lime_webgl)
#if (lime_webgl && !doc_gen)
typedef GLSync = js.html.webgl.Sync;
#else
typedef GLSync = Dynamic;
#end
#end
