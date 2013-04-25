require 'formula'

class Vicare < Formula
  version '0.1d2'
  url 'git://github.com/marcomaggi/vicare.git', :revision => '08bd828acfa9382324150b41f4e86c540c10a886'
  depends_on :automake
  depends_on "libffi"
  depends_on "gsl"

  def patches
    DATA
  end

  def install
    system "aclocal"
    system "autoheader"
    system "automake", "--foreign", "--add-missing"
    system "autoconf"

    libffi_cflags = `pkg-config libffi --cflags`.strip!
    libgsl_ldflags = `pkg-config --libs gsl`.strip!
    print "CFLAGS=#{libffi_cflags}\n"
    print "LDFLAGS=#{libgsl_ldflags}\n"
    system './configure', "--enable-libffi",  "--prefix=#{prefix}", "CFLAGS=#{libffi_cflags}", "LDFLAGS=#{libgsl_ldflags}"
    system "make"
    system "make", "install"
  end
end

__END__
diff --git a/scheme/Makefile.am b/scheme/Makefile.am
index 14c3894..d73e327 100644
--- a/scheme/Makefile.am
+++ b/scheme/Makefile.am
@@ -1,6 +1,6 @@
 ## Process this file with automake to produce Makefile.in
 
-nodist_pkglib_DATA=vicare.boot
+nodist_pkgdata_DATA=vicare.boot
 
 EXTRA_DIST=ikarus.boot.4.prebuilt ikarus.boot.8.prebuilt last-revision \
   ikarus.enumerations.ss run-tests.ss \
@@ -104,7 +104,7 @@ EXTRA_DIST=ikarus.boot.4.prebuilt ikarus.boot.8.prebuilt last-revision \
 NEW_BOOT_FILE	= vicare.boot
 NEW_EXECUTABLE	= ../src/vicare
 
-all: $(nodist_pkglib_DATA)
+all: $(nodist_pkgdata_DATA)
 
 $(srcdir)/last-revision:
 	git show | head -1 | cut -d ' ' -f2 >$@
@@ -114,12 +114,12 @@ sizeofvoidp = $(shell grep SIZEOF_VOID_P ../config.h | sed "s/.*\(.\)/\1/g")
 ikarus.config.ss: Makefile last-revision ../config.h
 	echo '(define ikarus-version "$(PACKAGE_VERSION)")' >$@
 	echo '(define ikarus-revision "$(shell cat $(srcdir)/last-revision)")' >>$@
-	echo '(define ikarus-lib-dir "$(pkglibdir)")' >>$@
+	echo '(define ikarus-lib-dir "$(pkgdatadir)")' >>$@
 	echo '(define target "$(target)")' >>$@
 	echo '(define wordsize $(sizeofvoidp))' >>$@
 
 
-CLEANFILES=$(nodist_pkglib_DATA) ikarus.config.ss
+CLEANFILES=$(nodist_pkgdata_DATA) ikarus.config.ss
 MAINTAINERCLEANFILES=last-revision
 
 # To  create the  new  boot image  we  use a  prebuilt  boot image;  the
diff --git a/src/Makefile.am b/src/Makefile.am
index ca4acbb..72aeeb1 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -19,7 +19,7 @@ nodist_vicare_SOURCES = bootfileloc.h
 BUILT_SOURCES = bootfileloc.h
 
 bootfileloc.h: Makefile
-	echo '#define BOOTFILE "$(pkglibdir)/vicare.boot"' >$@
+	echo '#define BOOTFILE "$(pkgdatadir)/vicare.boot"' >$@
 	echo '#define EXEFILE "$(bindir)/vicare"' >>$@
 
 CLEANFILES = bootfileloc.h

