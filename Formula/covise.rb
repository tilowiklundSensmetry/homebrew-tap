require 'formula'

class Covise < Formula
  homepage 'https://www.hlrs.de/covise/'
  desc 'Visualization environment for scientific and engineering data'
  url 'https://github.com/hlrs-vis/covise.git', :using => :git, :revision => 'f5a1086c8b05352701c0ef3288adeea79248c58c'
  version '2016.11'
  head 'https://github.com/hlrs-vis/covise.git'

  option "with-gdcm", "Build with GDCM for DICOM reading"
  option "with-cuda", "Build with CUDA support"
  option "with-qt4", "Build against Qt 4 instead of Qt 5"
  option "with-jpeg", "Build against libjpeg instead of libjpeg-turbo"
  option "with-x11", "Build against X11 and Open Motif"
  option "without-cover", "Build without OpenCOVER VR renderer"

  depends_on "cmake" => :build
  depends_on "swig" => :build

  depends_on "xerces-c"
  depends_on "glew"
  depends_on "jpeg" => :optional
  depends_on "jpeg-turbo" if build.without? "jpeg"
  depends_on "giflib"
  #depends_on "libpng12"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "freetype"
  depends_on "boost"
  depends_on "python3"
  depends_on "homebrew/science/gdcm" if build.with? "gdcm"
  depends_on :fortran => :optional
  depends_on :x11 => :optional
  depends_on "homebrew/x11/openmotif" if build.with? "x11"
  depends_on "hlrs-vis/tap/openinventor" if build.with? "x11"
  depends_on "qt" if build.with? "qt4"
  depends_on "qt5" if build.without? "qt4"
  depends_on "assimp" => :optional
  depends_on "vtk" => :optional
  depends_on "cgns" => :optional
  depends_on "snappy" => :optional
  depends_on "Caskroom/cask/cuda" if build.with? "cuda"

  depends_on "openscenegraph" if build.with? "cover"


  def install
    ENV["COVISEDIR"] = buildpath
    ENV["COVISEDESTDIR"] = buildpath
    ENV["ARCHSUFFIX"] = "macosopt"

    cmake_args = std_cmake_args
    cmake_args << "-DCOVISE_USE_CUDA:BOOL=ON" if build.with? "cuda"
    cmake_args << "-DCOVISE_USE_CUDA:BOOL=OFF" if build.without? "cuda"
    cmake_args << "-DCOVISE_USE_X11:BOOL=ON" if build.with? "x11"
    cmake_args << "-DCOVISE_USE_X11:BOOL=OFF" if build.without? "x11"

    #cmake_args << "-DCOVISE_USE_VIRVO=OFF"
    #cmake_args << "-DCOVISE_BUILD_MODULES=OFF"

    if build.with? "qt4"
        cmake_args << "-DCOVISE_USE_QT4=ON"
        #cmake_args << "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_prefix}"
    else
        cmake_args << "-DCOVISE_USE_QT4=OFF"
        #cmake_args << "-DCMAKE_PREFIX_PATH=#{Formula["qt5"].opt_prefix}"
    end

    mkdir "build.covise" do
        system "cmake", "..", *cmake_args
        system "make install"
    end

    if build.with? "cover"
        mkdir "build.cover" do
            system "cmake", "../src/OpenCOVER", *cmake_args
            system "make install"
        end
    end
  end

  test do
  end
end
