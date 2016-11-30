require 'formula'

class Libvncserver < Formula
  homepage 'https://libvnc.github.io'
  url 'https://github.com/LibVNC/libvncserver.git', :using => :git, :revision => '4c6bdcb460b18c05f98144217b16dc5922b3c52e'
  version '0.9.10a'

  depends_on 'cmake' => :build

  depends_on 'libjpeg-turbo'
  depends_on 'libpng'
  depends_on 'libgcrypt'

  def install
    #system "./configure", "--with-jpeg=#{HOMEBREW_PREFIX}/opt/jpeg-turbo", "--prefix=#{prefix}"
    cmake_args = std_cmake_args
    cmake_args << "-DLIBVNCSERVER_WITH_WEBSOCKETS:BOOL=OFF" # doesn't build

    mkdir "build" do
        system "cmake", "..", *cmake_args
        system "make install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <rfb/rfbclient.h>
      int main() {
        
	rfbGetClient(8, 3, 4);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lvncclient", "-o", "test"
    system "./test"

  end
end
