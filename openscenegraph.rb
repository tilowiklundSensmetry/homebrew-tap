require 'formula'

class Openscenegraph < Formula
  homepage 'http://www.openscenegraph.org'
  url 'http://www.openscenegraph.org/downloads/developer_releases/OpenSceneGraph-3.2.1.zip'
  sha1 '5c666531f7d487075fd692d89f1e05036306192a'
  patch :p0, :DATA

  depends_on 'cmake' => :build

  def install
    system "cmake", \
        "-DOSG_WINDOWING_SYSTEM:STRING=Cocoa", \
        "-DFFMPEG_LIBAVCODEC_INCLUDE_DIRS=OFF", \
        ".", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps
  end

  test do
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test OpenSceneGraph`.
    system "false"
  end
end

__END__
--- CMakeLists.txt.dist	2015-05-07 09:22:27.000000000 +0200
+++ CMakeLists.txt	2015-05-07 09:23:01.000000000 +0200
@@ -836,10 +836,7 @@
         # remain unset.
 
         IF (APPLE)
-            # set standard lib, clang defaults to c++0x
-            set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++98")
-            set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libstdc++")
-            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++98 -stdlib=libstdc++ -Wno-overloaded-virtual -Wno-conversion")
+            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-overloaded-virtual -Wno-conversion")
             set(WARNING_CFLAGS "")
         ENDIF()
 ENDIF()
