package lime.graphics.opengl;

#if (!lime_doc_gen || lime_webgl)
#if (lime_webgl && !doc_gen)
typedef GLQuery = js.html.webgl.Query;
#else
typedef GLQuery = Dynamic;
#end
#end
