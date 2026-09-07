package lime.graphics.bgfx;

enum abstract BGFXAccess(Int) from Int to Int
{
	var READ = 0;
	var WRITE = 1;
	var READ_WRITE = 2;
}
