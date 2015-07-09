NULL = 
ACLOCAL_AMFLAGS = -I m4

lib_LTLIBRARIES = \
	libntkdrpc.la \
	$(NULL)

noinst_LTLIBRARIES = \
	libhelperrpc.la \
	$(NULL)

libhelperrpc_la_SOURCES = \
	common_helpers.vala \
	$(NULL)

libhelperrpc_la_VALAFLAGS = \
	-H helperrpc.h \
	--library helperrpc \
	--pkg gee-0.8 \
	--pkg json-glib-1.0 \
	$(NULL)

libhelperrpc_la_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(JSON_CFLAGS) \
	$(NULL)

libhelperrpc_la_LIBADD = \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(JSON_LIBS) \
	$(NULL)

libntkdrpc_la_SOURCES = \
	common_skeleton.vala \
	common_stub.vala \
	netsukuku_interfaces.vala \
	netsukuku_skeleton.vala \
	netsukuku_stub.vala \
	addendum.vala \
	helperrpc.vapi \
	$(NULL)

libntkdrpc_la_VALAFLAGS = \
	-H ntkdrpc.h \
	--library ntkdrpc \
	--pkg gee-0.8 \
	--pkg json-glib-1.0 \
	--pkg zcd \
	--pkg zcd-tasklet-system \
	$(NULL)

libntkdrpc_la_CPPFLAGS = \
	-w \
	$(GOBJECT_CFLAGS) \
	$(GEE_CFLAGS) \
	$(JSON_CFLAGS) \
	$(ZCD_CFLAGS) \
	$(NULL)

libntkdrpc_la_LIBADD = \
	$(GOBJECT_LIBS) \
	$(GEE_LIBS) \
	$(JSON_LIBS) \
	$(ZCD_LIBS) \
	$(builddir)/libhelperrpc.la \
	$(NULL)

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = \
	ntkdrpc.vapi \
	ntkdrpc.deps \
	$(NULL)

include_HEADERS = \
	ntkdrpc.h \
	$(NULL)

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = \
	ntkdrpc.pc \
	$(NULL)

EXTRA_DIST = \
	ntkdrpc.pc.in \
	$(NULL)

MAINTAINERCLEANFILES = \
	$(srcdir)/helperrpc.vapi \
	$(srcdir)/ntkdrpc.vapi \
	$(NULL)

helperrpc.vapi: libhelperrpc_la_vala.stamp

ntkdrpc.vapi: libntkdrpc_la_vala.stamp

