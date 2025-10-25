package lime.graphics.opengl.ext;

@:keep
@:noCompletion class INTEL_performance_query
{
	public var PERFQUERY_SINGLE_CONTEXT_INTEL = 0x00000000;
	public var PERFQUERY_GLOBAL_CONTEXT_INTEL = 0x00000001;
	public var PERFQUERY_WAIT_INTEL = 0x83FB;
	public var PERFQUERY_FLUSH_INTEL = 0x83FA;
	public var PERFQUERY_DONOT_FLUSH_INTEL = 0x83F9;
	public var PERFQUERY_COUNTER_EVENT_INTEL = 0x94F0;
	public var PERFQUERY_COUNTER_DURATION_NORM_INTEL = 0x94F1;
	public var PERFQUERY_COUNTER_DURATION_RAW_INTEL = 0x94F2;
	public var PERFQUERY_COUNTER_THROUGHPUT_INTEL = 0x94F3;
	public var PERFQUERY_COUNTER_RAW_INTEL = 0x94F4;
	public var PERFQUERY_COUNTER_TIMESTAMP_INTEL = 0x94F5;
	public var PERFQUERY_COUNTER_DATA_UINT32_INTEL = 0x94F8;
	public var PERFQUERY_COUNTER_DATA_UINT64_INTEL = 0x94F9;
	public var PERFQUERY_COUNTER_DATA_FLOAT_INTEL = 0x94FA;
	public var PERFQUERY_COUNTER_DATA_DOUBLE_INTEL = 0x94FB;
	public var PERFQUERY_COUNTER_DATA_BOOL32_INTEL = 0x94FC;
	public var PERFQUERY_QUERY_NAME_LENGTH_MAX_INTEL = 0x94FD;
	public var PERFQUERY_COUNTER_NAME_LENGTH_MAX_INTEL = 0x94FE;
	public var PERFQUERY_COUNTER_DESC_LENGTH_MAX_INTEL = 0x94FF;
	public var PERFQUERY_GPA_EXTENDED_COUNTERS_INTEL = 0x9500;

	@:noCompletion private function new() {}

	// void glBeginPerfQueryINTEL (GLuint queryHandle)
	// void glCreatePerfQueryINTEL (GLuint queryId, GLuint *queryHandle)
	// void glDeletePerfQueryINTEL (GLuint queryHandle)
	// void glEndPerfQueryINTEL (GLuint queryHandle)
	// void glGetFirstPerfQueryIdINTEL (GLuint *queryId)
	// void glGetNextPerfQueryIdINTEL (GLuint queryId, GLuint *nextQueryId)
	// void glGetPerfCounterInfoINTEL (GLuint queryId, GLuint counterId, GLuint counterNameLength, GLchar *counterName, GLuint counterDescLength, GLchar *counterDesc, GLuint *counterOffset, GLuint *counterDataSize, GLuint *counterTypeEnum, GLuint *counterDataTypeEnum, GLuint64 *rawCounterMaxValue)
	// void glGetPerfQueryDataINTEL (GLuint queryHandle, GLuint flags, GLsizei dataSize, void *data, GLuint *bytesWritten)
	// void glGetPerfQueryIdByNameINTEL (GLchar *queryName, GLuint *queryId)
	// void glGetPerfQueryInfoINTEL (GLuint queryId, GLuint queryNameLength, GLchar *queryName, GLuint *dataSize, GLuint *noCounters, GLuint *noInstances, GLuint *capsMask)
}
