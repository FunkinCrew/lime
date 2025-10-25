package lime.graphics.opengl.ext;

@:keep
@:noCompletion class AMD_performance_monitor
{
	public var COUNTER_TYPE_AMD = 0x8BC0;
	public var COUNTER_RANGE_AMD = 0x8BC1;
	public var UNSIGNED_INT64_AMD = 0x8BC2;
	public var PERCENTAGE_AMD = 0x8BC3;
	public var PERFMON_RESULT_AVAILABLE_AMD = 0x8BC4;
	public var PERFMON_RESULT_SIZE_AMD = 0x8BC5;
	public var PERFMON_RESULT_AMD = 0x8BC6;

	@:noCompletion private function new() {}

	// void glGetPerfMonitorGroupsAMD (GLint *numGroups, GLsizei groupsSize, GLuint *groups)
	// void glGetPerfMonitorCountersAMD (GLuint group, GLint *numCounters, GLint *maxActiveCounters, GLsizei counterSize, GLuint *counters)
	// void glGetPerfMonitorGroupStringAMD (GLuint group, GLsizei bufSize, GLsizei *length, GLchar *groupString)
	// void glGetPerfMonitorCounterStringAMD (GLuint group, GLuint counter, GLsizei bufSize, GLsizei *length, GLchar *counterString)
	// void glGetPerfMonitorCounterInfoAMD (GLuint group, GLuint counter, GLenum pname, void *data)
	// void glGenPerfMonitorsAMD (GLsizei n, GLuint *monitors)
	// void glDeletePerfMonitorsAMD (GLsizei n, GLuint *monitors)
	// void glSelectPerfMonitorCountersAMD (GLuint monitor, GLboolean enable, GLuint group, GLint numCounters, GLuint *counterList)
	// void glBeginPerfMonitorAMD (GLuint monitor)
	// void glEndPerfMonitorAMD (GLuint monitor)
	// void glGetPerfMonitorCounterDataAMD (GLuint monitor, GLenum pname, GLsizei dataSize, GLuint *data, GLint *bytesWritten)
}
