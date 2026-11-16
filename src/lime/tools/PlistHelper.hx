package lime.tools;

import hxp.System;

class PlistHelper
{
	public static function mergePlists(workingDirectory:String, projectDirectory:String, destPlist:String):Void
	{
		var tempPlist = System.getTemporaryFile();

		try
		{
			for (fileName in System.readDirectory(projectDirectory))
			{
				if (fileName.substr(-11) != "-Info.plist" || fileName == destPlist)
				{
					continue;
				}

				mergeDict(workingDirectory, destPlist, tempPlist, "", Xml.parse(sys.io.File.getContent(fileName)).firstElement().firstElement());

				System.runProcess(workingDirectory, "/usr/libexec/PlistBuddy", ["-c", 'Merge \'$fileName\'', destPlist], true, true, false);

				System.deleteFile(fileName);
			}
		}
		catch (e:Dynamic)
		{
			System.deleteFile(tempPlist);

			throw e;
		}

		System.deleteFile(tempPlist);
	}

	private static function mergeDict(workingDirectory:String, destPlist:String, tempPlist:String, path:String, dict:Xml):Void
	{
		var key:String = null;

		for (node in dict.elements())
		{
			if (node.nodeName == "key")
			{
				key = node.firstChild() != null ? node.firstChild().nodeValue : null;

				continue;
			}

			if (key == null)
			{
				continue;
			}

			var entry:String = '$path:$key';

			if (node.nodeName == "array")
			{
				mergeArray(workingDirectory, destPlist, tempPlist, entry, node);
			}
			else if (node.nodeName == "dict" && runPlistBuddy(workingDirectory, destPlist, 'Print $entry') != "")
			{
				mergeDict(workingDirectory, destPlist, tempPlist, entry, node);
			}

			key = null;
		}
	}

	private static function mergeArray(workingDirectory:String, destPlist:String, tempPlist:String, entry:String, source:Xml):Void
	{
		var seen:Map<String, Bool> = [];

		var existing:String = runPlistBuddy(workingDirectory, destPlist, 'Print $entry', true);

		if (existing.length == 0)
		{
			runPlistBuddy(workingDirectory, destPlist, 'Add $entry array');
		}
		else
		{
			var destArray:Xml = Xml.parse(existing).firstElement().firstElement();

			if (destArray != null)
			{
				for (item in destArray.elements())
				{
					seen.set(canonical(item), true);
				}
			}
		}

		var items:StringBuf = new StringBuf();

		var count:Int = 0;

		for (item in source.elements())
		{
			var id = canonical(item);

			if (seen.exists(id))
			{
				continue;
			}

			seen.set(id, true);
			items.add(item.toString());
			count++;
		}

		if (count == 0)
		{
			return;
		}

		System.writeText('<?xml version="1.0" encoding="UTF-8"?><plist version="1.0"><array>${items.toString()}</array></plist>', tempPlist);

		runPlistBuddy(workingDirectory, destPlist, 'Merge \'$tempPlist\' $entry');
	}

	private static function canonical(node:Xml):String
	{
		if (node.nodeType == Xml.Element)
		{
			var result = '<${node.nodeName}>';

			for (child in node)
			{
				result += canonical(child);
			}

			return '$result</${node.nodeName}>';
		}

		if (node.nodeType == Xml.PCData || node.nodeType == Xml.CData)
		{
			return StringTools.trim(node.nodeValue);
		}

		return "";
	}

	private static function runPlistBuddy(workingDirectory:String, file:String, command:String, xml:Bool = false):String
	{
		var args:Array<String> = xml ? ["-x", "-c", command, file] : ["-c", command, file];

		var output:String = System.runProcess(workingDirectory, "/usr/libexec/PlistBuddy", args, true, true, true);

		if (output != null && output.length > 0)
		{
			return StringTools.trim(output);
		}

		return "";
	}
}
