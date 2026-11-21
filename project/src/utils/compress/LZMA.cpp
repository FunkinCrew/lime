#include <LzmaLib.h>
#include <string.h>
#include <utils/compress/LZMA.h>

namespace lime
{

	bool LZMA::Compress(Bytes *data, Bytes *result)
	{
		if (data == NULL || data->b == NULL || data->length <= 0)
		{
			result->Resize(0);

			return false;
		}

		SizeT inputBufferSize = data->length;
		SizeT maxOutputSize = inputBufferSize + inputBufferSize / 5 + (1 << 16);
		result->Resize(LZMA_PROPS_SIZE + sizeof(UInt64) + maxOutputSize);

		Byte *outPtr = result->b;
		SizeT propsSize = LZMA_PROPS_SIZE;
		UInt64 uncompressedLength = (UInt64)inputBufferSize;
		memcpy(outPtr + LZMA_PROPS_SIZE, &uncompressedLength, sizeof(UInt64));

		Byte *compressedDataPtr = outPtr + LZMA_PROPS_SIZE + sizeof(UInt64);
		SizeT actualCompressedSize = maxOutputSize;
		SRes res = LzmaCompress(compressedDataPtr, &actualCompressedSize, data->b, inputBufferSize, outPtr, &propsSize, -1, (1 << 20), -1, -1, -1, -1, 1);

		if (res == SZ_OK)
		{
			result->Resize(LZMA_PROPS_SIZE + sizeof(UInt64) + actualCompressedSize);

			return true;
		}

		result->Resize(0);

		return false;
	}

	bool LZMA::Decompress(Bytes *data, Bytes *result)
	{
		if (data == NULL || data->b == NULL || data->length < (LZMA_PROPS_SIZE + sizeof(UInt64)))
		{
			result->Resize(0);

			return false;
		}

		Byte *inPtr = data->b;
		UInt64 uncompressedLength = 0;
		memcpy(&uncompressedLength, inPtr + LZMA_PROPS_SIZE, sizeof(UInt64));

		result->Resize((int)uncompressedLength);

		SizeT outSize = (SizeT)uncompressedLength;
		SizeT inSize = data->length - LZMA_PROPS_SIZE - sizeof(UInt64);
		Byte *compressedDataPtr = inPtr + LZMA_PROPS_SIZE + sizeof(UInt64);
		SRes res = LzmaUncompress(result->b, &outSize, compressedDataPtr, &inSize, inPtr, LZMA_PROPS_SIZE);

		if (res != SZ_OK)
		{
			result->Resize(0);

			return false;
		}

		return true;
	}

} // namespace lime