package lime.graphics.opengl;

#if (!lime_doc_gen || lime_webgl)
#if (lime_webgl && !doc_gen)
typedef GLContextAttributes = js.html.webgl.ContextAttributes;
#else
typedef GLContextAttributes = Dynamic;
#end
#end
