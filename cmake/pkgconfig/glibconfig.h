/*
 * Compatibility glibconfig.h for the conda-forge GLib runtime.
 *
 * libglib's pkg-config file advertises this generated-header directory, but
 * the current conda-forge package does not ship the generated header.  These
 * values describe the Linux x86_64 Pixi target used by this project.
 */
#ifndef __GLIBCONFIG_H__
#define __GLIBCONFIG_H__

#include <glib/gmacros.h>
#include <limits.h>
#include <float.h>
#include <stdint.h>
#include <sys/poll.h>
#include <sys/socket.h>
#include <sys/types.h>

#define GLIB_HAVE_ALLOCA_H 1
#define GLIB_USING_SYSTEM_PRINTF 1

#define G_MINFLOAT FLT_MIN
#define G_MAXFLOAT FLT_MAX
#define G_MINDOUBLE DBL_MIN
#define G_MAXDOUBLE DBL_MAX
#define G_MINSHORT SHRT_MIN
#define G_MAXSHORT SHRT_MAX
#define G_MAXUSHORT USHRT_MAX
#define G_MININT INT_MIN
#define G_MAXINT INT_MAX
#define G_MAXUINT UINT_MAX
#define G_MINLONG LONG_MIN
#define G_MAXLONG LONG_MAX
#define G_MAXULONG ULONG_MAX

typedef signed char gint8;
typedef unsigned char guint8;
typedef signed short gint16;
typedef unsigned short guint16;
#define G_GINT16_MODIFIER "h"
#define G_GINT16_FORMAT "hi"
#define G_GUINT16_FORMAT "hu"

typedef signed int gint32;
typedef unsigned int guint32;
#define G_GINT32_MODIFIER ""
#define G_GINT32_FORMAT "i"
#define G_GUINT32_FORMAT "u"

#define G_HAVE_GINT64 1
typedef signed long gint64;
typedef unsigned long guint64;
#define G_GINT64_CONSTANT(val) (val##L)
#define G_GUINT64_CONSTANT(val) (val##UL)
#define G_GINT64_MODIFIER "l"
#define G_GINT64_FORMAT "li"
#define G_GUINT64_FORMAT "lu"

#define GLIB_SIZEOF_VOID_P 8
#define GLIB_SIZEOF_LONG 8
#define GLIB_SIZEOF_SIZE_T 8
#define GLIB_SIZEOF_SSIZE_T 8

typedef signed long gssize;
typedef unsigned long gsize;
#define G_GSIZE_MODIFIER "z"
#define G_GSSIZE_MODIFIER "z"
#define G_GSIZE_FORMAT "zu"
#define G_GSSIZE_FORMAT "zd"
#define G_MAXSIZE G_MAXUINT64
#define G_MINSSIZE G_MININT64
#define G_MAXSSIZE G_MAXINT64

typedef gint64 goffset;
#define G_MINOFFSET G_MININT64
#define G_MAXOFFSET G_MAXINT64
#define G_GOFFSET_MODIFIER G_GINT64_MODIFIER
#define G_GOFFSET_FORMAT G_GINT64_FORMAT
#define G_GOFFSET_CONSTANT(val) G_GINT64_CONSTANT(val)

#define G_POLLFD_FORMAT "d"
#define GPOINTER_TO_INT(p) ((gint) (gintptr) (p))
#define GPOINTER_TO_UINT(p) ((guint) (guintptr) (p))
#define GINT_TO_POINTER(i) ((gpointer) (gintptr) (i))
#define GUINT_TO_POINTER(u) ((gpointer) (guintptr) (u))

typedef intptr_t gintptr;
typedef uintptr_t guintptr;
#define G_GINTPTR_MODIFIER "l"
#define G_GINTPTR_FORMAT "li"
#define G_GUINTPTR_FORMAT "lu"

#define GLIB_MAJOR_VERSION 2
#define GLIB_MINOR_VERSION 88
#define GLIB_MICRO_VERSION 2

#define G_OS_UNIX 1
#define G_OS_POSIX 1

#define G_VA_COPY va_copy
#define G_HAVE_ISO_VARARGS 1
#define G_HAVE_GNUC_VARARGS 1
#define G_HAVE_GNUC_VISIBILITY 1

#define G_THREADS_ENABLED
#define G_THREADS_IMPL_POSIX
#define G_ATOMIC_LOCK_FREE 1

#define GINT16_TO_LE(val) ((gint16) (val))
#define GUINT16_TO_LE(val) ((guint16) (val))
#define GINT16_TO_BE(val) ((gint16) GUINT16_SWAP_LE_BE (val))
#define GUINT16_TO_BE(val) (GUINT16_SWAP_LE_BE (val))
#define GINT32_TO_LE(val) ((gint32) (val))
#define GUINT32_TO_LE(val) ((guint32) (val))
#define GINT32_TO_BE(val) ((gint32) GUINT32_SWAP_LE_BE (val))
#define GUINT32_TO_BE(val) (GUINT32_SWAP_LE_BE (val))
#define GINT64_TO_LE(val) ((gint64) (val))
#define GUINT64_TO_LE(val) ((guint64) (val))
#define GINT64_TO_BE(val) ((gint64) GUINT64_SWAP_LE_BE (val))
#define GUINT64_TO_BE(val) (GUINT64_SWAP_LE_BE (val))
#define GLONG_TO_LE(val) ((glong) GINT64_TO_LE (val))
#define GULONG_TO_LE(val) ((gulong) GUINT64_TO_LE (val))
#define GLONG_TO_BE(val) ((glong) GINT64_TO_BE (val))
#define GULONG_TO_BE(val) ((gulong) GUINT64_TO_BE (val))
#define GINT_TO_LE(val) ((gint) GINT32_TO_LE (val))
#define GUINT_TO_LE(val) ((guint) GUINT32_TO_LE (val))
#define GINT_TO_BE(val) ((gint) GINT32_TO_BE (val))
#define GUINT_TO_BE(val) ((guint) GUINT32_TO_BE (val))
#define GSIZE_TO_LE(val) ((gsize) GUINT64_TO_LE (val))
#define GSSIZE_TO_LE(val) ((gssize) GINT64_TO_LE (val))
#define GSIZE_TO_BE(val) ((gsize) GUINT64_TO_BE (val))
#define GSSIZE_TO_BE(val) ((gssize) GINT64_TO_BE (val))
#define G_BYTE_ORDER G_LITTLE_ENDIAN

#define GLIB_SYSDEF_POLLIN = POLLIN
#define GLIB_SYSDEF_POLLOUT = POLLOUT
#define GLIB_SYSDEF_POLLPRI = POLLPRI
#define GLIB_SYSDEF_POLLHUP = POLLHUP
#define GLIB_SYSDEF_POLLERR = POLLERR
#define GLIB_SYSDEF_POLLNVAL = POLLNVAL

#define G_MODULE_SUFFIX ".so"
typedef pid_t GPid;
#define G_PID_FORMAT "i"
#define GLIB_SYSDEF_AF_UNIX AF_UNIX
#define GLIB_SYSDEF_AF_INET AF_INET
#define GLIB_SYSDEF_AF_INET6 AF_INET6
#define GLIB_SYSDEF_MSG_OOB MSG_OOB
#define GLIB_SYSDEF_MSG_PEEK MSG_PEEK
#define GLIB_SYSDEF_MSG_DONTROUTE MSG_DONTROUTE

#define G_DIR_SEPARATOR '/'
#define G_DIR_SEPARATOR_S "/"
#define G_SEARCHPATH_SEPARATOR ':'
#define G_SEARCHPATH_SEPARATOR_S ":"

#endif /* __GLIBCONFIG_H__ */
