package lime.tools;

import haxe.macro.Expr;

import hxp.HostArchitecture;

@:forward
enum abstract Architecture(String) to String
{
	var ARMV7 = "ARMV7";
	var ARM64 = "ARM64";
	var X86 = "X86";
	var X64 = "X64";

	public static function exists(architecture:String):Bool
	{
		switch (architecture)
		{
			case ARMV7, ARM64, X86, X64:
				return true;
			default:
				return false;
		}
	}

	@:from private static function fromHostArchitecture(hostArchitecture:HostArchitecture):Architecture
	{
		if (hostArchitecture == HostArchitecture.ARMV7)
		{
			return ARMV7;
		}
		else if (hostArchitecture == HostArchitecture.ARM64)
		{
			return ARM64;
		}
		else if (hostArchitecture == HostArchitecture.X86)
		{
			return X86;
		}
		else
		{
			return X64;
		}
	}

	@:from private static function fromString(string:String):Architecture
	{
		if (exists(string))
		{
			return cast string;
		}
		else
		{
			return null;
		}
	}

	/**
		Returns the given `Architecture` if available, or `null` otherwise.
	**/
	public inline function new(name:String)
	{
		this = fromString(name.toUpperCase());
	}

	public inline function is64():Bool
	{
		return this == ARM64 || this == X64;
	}

	public inline function isARM():Bool
	{
		return this.indexOf("ARM") == 0;
	}

	public inline function isX():Bool
	{
		return this == X86 || this == X64;
	}

	@:noCompletion public macro function match(self:Expr, expr:Expr):Expr
	{
		return macro switch ($self)
		{
			case $expr:
				true;
			default:
				false;
		};
	}
}
