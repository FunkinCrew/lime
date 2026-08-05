#include "LzmaDec.h"
#include "LzmaEnc.h"

#include <string.h>
#include <utils/compress/LZMA.h>

namespace lime
{

	extern "C"
	{
		SRes LZMA_progress(void *p, UInt64 inSize, UInt64 outSize)
		{
			return SZ_OK;
		}

		void *LZMA_alloc(void *p, size_t size)
		{
			return malloc(size);
		}

		void LZMA_free(void *p, void *address)
		{
			if (address)
			{
				free(address);
			}
		}
	}

	void LZMA::Compress(Bytes *data, Bytes *result)
	{
		if (data == NULL || data->b == NULL || data->length <= 0)
		{
			result->Resize(0);
			return;
		}

		SizeT inputBufferSize = data->length;
		SizeT maxOutputSize = inputBufferSize + inputBufferSize / 5 + (1 << 16);
		result->Resize(LZMA_PROPS_SIZE + sizeof(UInt64) + maxOutputSize);

		Byte *outPtr = result->b;
		CLzmaEncProps props = {0};
		LzmaEncProps_Init(&props);
		props.dictSize = (1 << 20);
		props.writeEndMark = 0;
		props.numThreads = 1;

		SizeT propsSize = LZMA_PROPS_SIZE;
		UInt64 uncompressedLength = (UInt64)inputBufferSize;
		memcpy(outPtr + LZMA_PROPS_SIZE, &uncompressedLength, sizeof(UInt64));

		Byte *compressedDataPtr = outPtr + LZMA_PROPS_SIZE + sizeof(UInt64);
		SizeT actualCompressedSize = maxOutputSize;
		ICompressProgress progress = {LZMA_progress};
		ISzAlloc alloc = {LZMA_alloc, LZMA_free};
		SRes res = LzmaEncode(compressedDataPtr, &actualCompressedSize, data->b, inputBufferSize, &props, outPtr, &propsSize, props.writeEndMark, &progress, &alloc, &alloc);

		if (res == SZ_OK)
		{
			result->Resize(LZMA_PROPS_SIZE + sizeof(UInt64) + actualCompressedSize);
		}
		else
		{
			result->Resize(0);
		}
	}

	void LZMA::Decompress(Bytes *data, Bytes *result)
	{
		if (data == NULL || data->b == NULL || data->length < (LZMA_PROPS_SIZE + sizeof(UInt64)))
		{
			result->Resize(0);
			return;
		}

		Byte *inPtr = data->b;
		UInt64 uncompressedLength = 0;
		memcpy(&uncompressedLength, inPtr + LZMA_PROPS_SIZE, sizeof(UInt64));

		result->Resize((int)uncompressedLength);

		SizeT outSize = (SizeT)uncompressedLength;
		SizeT inSize = data->length - LZMA_PROPS_SIZE - sizeof(UInt64);
		Byte *compressedDataPtr = inPtr + LZMA_PROPS_SIZE + sizeof(UInt64);
		ELzmaStatus status = LZMA_STATUS_NOT_SPECIFIED;
		ISzAlloc alloc = {LZMA_alloc, LZMA_free};
		SRes res = LzmaDecode(result->b, &outSize, compressedDataPtr, &inSize, inPtr, LZMA_PROPS_SIZE, LZMA_FINISH_ANY, &status, &alloc);

		if (res != SZ_OK)
		{
			result->Resize(0);
		}
	}

} // namespace lime