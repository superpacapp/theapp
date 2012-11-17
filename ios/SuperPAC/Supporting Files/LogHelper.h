/*
 * Bill Hollings, comment on iphoneincubator
 *
 * There are three levels of logging: debug, info and error, and each can be enabled independently
 * via the LOGGING_LEVEL_DEBUG, LOGGING_LEVEL_INFO, and LOGGING_LEVEL_ERROR switches below, respectively.
 * In addition, ALL logging can be enabled or disabled via the LOGGING_ENABLED switch below.
 *
 * To perform logging, use any of the following function calls in your code:
 *
 *	 LogDebug(fmt, ...) – will print if LOGGING_LEVEL_DEBUG is set on.
 *	 LogInfo(fmt, ...) – will print if LOGGING_LEVEL_INFO is set on.
 *	 LogError(fmt, ...) – will print if LOGGING_LEVEL_ERROR is set on.
 *
 * Each logging entry can optionally automatically include class, method and line information by
 * enabling the LOGGING_INCLUDE_CODE_LOCATION switch.
 *
 * Logging functions are implemented here via macros, so disabling logging, either entirely,
 * or at a specific level, removes the corresponding log invocations from the compiled code,
 * thus completely eliminating both the memory and CPU overhead that the logging calls would add.
 */

// Set this switch to enable or disable ALL logging.
#define LOGGING_ENABLED	 1

// Set any or all of these switches to enable or disable logging at specific levels.
#ifdef DEBUG
#define LOGGING_LEVEL_DEBUG	 1
#else
#define LOGGING_LEVEL_DEBUG  0
#endif

#define LOGGING_LEVEL_INFO	 1
#define LOGGING_LEVEL_ERROR	 1

// Set this switch to set whether or not to include class, method and line information in the log entries.
#define LOGGING_INCLUDE_CODE_LOCATION	1

// ***************** END OF USER SETTINGS ***************

#if !(defined(LOGGING_ENABLED) && LOGGING_ENABLED)
#undef LOGGING_LEVEL_DEBUG
#undef LOGGING_LEVEL_INFO
#undef LOGGING_LEVEL_ERROR
#endif

// Logging format
#define LOG_FORMAT_NO_LOCATION(fmt, lvl, ...) NSLog((@"[%@] " fmt), lvl, ##__VA_ARGS__)
#define LOG_FORMAT_WITH_LOCATION(fmt, lvl, ...) NSLog((@"%s [Line %d] [%@] " fmt), __PRETTY_FUNCTION__, __LINE__, lvl, ##__VA_ARGS__)

#if defined(LOGGING_INCLUDE_CODE_LOCATION) && LOGGING_INCLUDE_CODE_LOCATION
#define LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_WITH_LOCATION(fmt, lvl, ##__VA_ARGS__)
#else
#define LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_NO_LOCATION(fmt, lvl, ##__VA_ARGS__)
#endif

// Debug level logging
#if defined(LOGGING_LEVEL_DEBUG) && LOGGING_LEVEL_DEBUG
#define LogDebug(fmt, ...) LOG_FORMAT(fmt, @"debug", ##__VA_ARGS__)
#else
#define LogDebug(...)
#endif

// Info level logging
#if defined(LOGGING_LEVEL_INFO) && LOGGING_LEVEL_INFO
#define LogInfo(fmt, ...) LOG_FORMAT(fmt, @"info", ##__VA_ARGS__)
#else
#define LogInfo(...)
#endif

// Error level logging
#if defined(LOGGING_LEVEL_ERROR) && LOGGING_LEVEL_ERROR
#define LogError(fmt, ...) LOG_FORMAT(fmt, @"***ERROR***", ##__VA_ARGS__)
#else
#define LogError(...)
#endif