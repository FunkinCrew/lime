package lime.graphics.opengl;

#if (!lime_doc_gen || lime_webgl)
#if (lime_webgl && !doc_gen)
typedef GLBuffer = js.html.webgl.Buffer;
#else
typedef GLBuffer = Dynamic;
#end
#end
