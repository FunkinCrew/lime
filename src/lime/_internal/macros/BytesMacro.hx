package lime._internal.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

class BytesMacro
{
	macro public static function build():Array<Field>
	{
		var fields:Array<Field> = Context.getBuildFields();

		for (field in fields)
		{
			if (field.name != "b") continue;

			switch (field.kind)
			{
				case FVar(_, __):
					field.access.remove(AFinal);
				default:
			}
		}

		return fields;
	}
}
#end