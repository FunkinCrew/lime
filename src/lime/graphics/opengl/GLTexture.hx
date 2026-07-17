package lime.graphics.opengl;

#if (!lime_doc_gen || lime_webgl)
#if (lime_webgl && !doc_gen)
typedef GLTexture = js.html.webgl.Texture;
#else
typedef GLTexture = Dynamic;
#end
#end
