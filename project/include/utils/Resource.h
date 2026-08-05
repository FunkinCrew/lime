#pragma once

#include <hx/CFFIPrime.h>
#include <utils/Bytes.h>

namespace lime
{

	struct Resource
	{
		Resource() : data(NULL), path(NULL) {}
		Resource(const char *path) : data(NULL), path(path) {}
		Resource(Bytes *data) : data(data), path(NULL) {}

		Bytes *data;
		const char *path;
	};

} // namespace lime