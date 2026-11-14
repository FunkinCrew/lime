#include <hx/CFFIPrime.h>
#include <string.h>
#include <system/ValuePointer.h>
#include <utils/Bytes.h>
#include <utils/HaxeResource.h>

namespace lime
{

	static ValuePointer *listNamesMethod = 0;
	static ValuePointer *getBytesMethod = 0;

	void HaxeResource::Init(ValuePointer *inListNamesMethod, ValuePointer *inGetBytesMethod)
	{
		if (listNamesMethod)
			delete listNamesMethod;
		if (getBytesMethod)
			delete getBytesMethod;

		listNamesMethod = inListNamesMethod;
		getBytesMethod = inGetBytesMethod;
	}

	bool HaxeResource::GetBytes(const char *name, std::vector<unsigned char> &outData)
	{
		outData.clear();

		if (!getBytesMethod || !name)
			return false;

		value result = (value)getBytesMethod->Call((void *)alloc_string(name));
		if (!result || val_is_null(result))
			return false;

		Bytes bytes((value)result);
		if (bytes.length > 0 && !bytes.b)
			return false;

		outData.assign(bytes.b, bytes.b + bytes.length);
		return true;
	}

	bool HaxeResource::GetString(const char *name, std::string &outString)
	{
		std::vector<unsigned char> data;
		if (!GetBytes(name, data))
			return false;

		outString.assign(data.begin(), data.end());
		return true;
	}

	std::vector<std::string> HaxeResource::ListNames()
	{
		std::vector<std::string> names;

		if (!listNamesMethod)
			return names;

		value result = (value)listNamesMethod->Call();
		if (!result || val_is_null(result))
			return names;

		int size = val_array_size(result);

		for (int i = 0; i < size; i++)
		{
			const char *name = val_string(val_array_i(result, i));
			if (name)
				names.push_back(name);
		}

		return names;
	}

} // namespace lime
