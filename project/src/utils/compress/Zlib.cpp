#include <utils/compress/Zlib.h>
#include <zlib.h>

namespace lime
{

	void Zlib::Compress(ZlibType type, Bytes *data, Bytes *result)
	{
		if (data == NULL || data->b == NULL || data->length <= 0)
		{
			result->Resize(0);
			return;
		}

		int windowBits = 15;

		switch (type)
		{
			case DEFLATE:
				windowBits = -15;
				break;
			case GZIP:
				windowBits = 31;
				break;
			default:
				break;
		}

		z_stream stream = {0};

		if (deflateInit2(&stream, Z_BEST_COMPRESSION, Z_DEFLATED, windowBits, 8, Z_DEFAULT_STRATEGY) != Z_OK)
		{
			result->Resize(0);
			return;
		}

		int maxBufferSize = deflateBound(&stream, data->length);

		result->Resize(maxBufferSize);

		stream.next_in = (Bytef *)data->b;
		stream.avail_in = data->length;
		stream.next_out = (Bytef *)result->b;
		stream.avail_out = maxBufferSize;

		int ret = deflate(&stream, Z_FINISH);

		deflateEnd(&stream);

		if (ret == Z_STREAM_END)
		{
			result->Resize((int)stream.total_out);
		}
		else
		{
			result->Resize(0);
		}
	}

	void Zlib::Decompress(ZlibType type, Bytes *data, Bytes *result)
	{
		if (data == NULL || data->b == NULL || data->length <= 0)
		{
			result->Resize(0);
			return;
		}

		int windowBits = 15;

		switch (type)
		{
			case DEFLATE:
				windowBits = -15;
				break;
			case GZIP:
				windowBits = 31;
				break;
			default:
				break;
		}

		z_stream stream = {0};

		if (inflateInit2(&stream, windowBits) != Z_OK)
		{
			result->Resize(0);
			return;
		}

		stream.next_in = (Bytef *)data->b;
		stream.avail_in = data->length;

		int capacity = data->length > 16384 ? data->length * 4 : 65536;

		result->Resize(capacity);

		int status = Z_OK;

		while (status == Z_OK)
		{
			if (stream.total_out >= (uLong)capacity)
			{
				capacity *= 2;
				result->Resize(capacity);
			}

			stream.next_out = (Bytef *)(result->b + stream.total_out);
			stream.avail_out = capacity - stream.total_out;

			status = inflate(&stream, Z_NO_FLUSH);
		}

		inflateEnd(&stream);

		if (status == Z_STREAM_END)
		{
			result->Resize((int)stream.total_out);
		}
		else
		{
			result->Resize(0);
		}
	}

} // namespace lime