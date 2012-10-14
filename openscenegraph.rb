require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Openscenegraph < Formula
  homepage 'http://www.openscenegraph.org'
  url 'http://www.openscenegraph.org/downloads/stable_releases/OpenSceneGraph-3.0.1/source/OpenSceneGraph-3.0.1.zip'
  version '3.0.1'
  sha1 '13c7e39f6d62047ad944d8d28a0f0eb60384ce33'

  def patches
    DATA
  end

  depends_on 'cmake' => :build
  #depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    #system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          #"--prefix=#{prefix}"
    system "cmake", \
        "-DOSG_WINDOWING_SYSTEM:STRING=Cocoa", \
        "-DFFMPEG_LIBAVCODEC_INCLUDE_DIRS=OFF", \
        ".", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test OpenSceneGraph`.
    system "false"
  end
end

__END__
diff --git a/src/OpenThreads/common/Atomic.cpp b/src/OpenThreads/common/Atomic.cpp
index a278825..3d1a918 100644
--- a/src/OpenThreads/common/Atomic.cpp
+++ b/src/OpenThreads/common/Atomic.cpp
@@ -143,7 +143,7 @@ bool
 AtomicPtr::assign(void* ptrNew, const void* const ptrOld)
 {
 #if defined(_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS)
-    return __sync_bool_compare_and_swap(&_ptr, ptrOld, ptrNew);
+    return __sync_bool_compare_and_swap(&_ptr, (void *)ptrOld, ptrNew);
 #elif defined(_OPENTHREADS_ATOMIC_USE_WIN32_INTERLOCKED)
     return ptrOld == InterlockedCompareExchangePointer((PVOID volatile*)&_ptr, (PVOID)ptrNew, (PVOID)ptrOld);
 #elif defined(_OPENTHREADS_ATOMIC_USE_BSD_ATOMIC)
diff --git a/src/osgViewer/DarwinUtils.mm b/src/osgViewer/DarwinUtils.mm
index 5a51287..156cb53 100644
--- a/src/osgViewer/DarwinUtils.mm
+++ b/src/osgViewer/DarwinUtils.mm
@@ -47,6 +47,25 @@
 
 namespace osgDarwin {
 
+//
+// Lion replacement for CGDisplayBitsPerPixel(CGDirectDisplayID displayId)
+//
+size_t displayBitsPerPixel( CGDirectDisplayID displayId )
+{
+
+    CGDisplayModeRef mode = CGDisplayCopyDisplayMode(displayId);
+    size_t depth = 0;
+
+    CFStringRef pixEnc = CGDisplayModeCopyPixelEncoding(mode);
+    if(CFStringCompare(pixEnc, CFSTR(IO32BitDirectPixels), kCFCompareCaseInsensitive) == kCFCompareEqualTo)
+        depth = 32;
+    else if(CFStringCompare(pixEnc, CFSTR(IO16BitDirectPixels), kCFCompareCaseInsensitive) == kCFCompareEqualTo)
+        depth = 16;
+    else if(CFStringCompare(pixEnc, CFSTR(IO8BitIndexedPixels), kCFCompareCaseInsensitive) == kCFCompareEqualTo)
+        depth = 8;
+
+    return depth;
+}
 
 static inline CGRect toCGRect(NSRect nsRect)
 {
@@ -313,7 +332,7 @@ void DarwinWindowingSystemInterface::getScreenSettings(const osg::GraphicsContex
     CGDirectDisplayID id = getDisplayID(si);
     resolution.width = CGDisplayPixelsWide(id);
     resolution.height = CGDisplayPixelsHigh(id);
-    resolution.colorDepth = CGDisplayBitsPerPixel(id);
+    resolution.colorDepth = displayBitsPerPixel(id);
     resolution.refreshRate = getDictDouble (CGDisplayCurrentMode(id), kCGDisplayRefreshRate);        // Not tested
     if (resolution.refreshRate<0) resolution.refreshRate = 0;
 }
@@ -402,7 +421,7 @@ bool DarwinWindowingSystemInterface::setScreenResolutionImpl(const osg::Graphics
     CFDictionaryRef display_mode_values =
         CGDisplayBestModeForParametersAndRefreshRate(
                         displayid, 
-                        CGDisplayBitsPerPixel(displayid), 
+                        displayBitsPerPixel(displayid), 
                         width, height,  
                         refresh,  
                         NULL);
@@ -432,7 +451,7 @@ bool DarwinWindowingSystemInterface::setScreenRefreshRateImpl(const osg::Graphic
     CFDictionaryRef display_mode_values =
         CGDisplayBestModeForParametersAndRefreshRate(
                         displayid, 
-                        CGDisplayBitsPerPixel(displayid), 
+                        displayBitsPerPixel(displayid), 
                         width, height,  
                         refreshRate,  
                         &success);
