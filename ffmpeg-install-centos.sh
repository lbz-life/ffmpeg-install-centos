#!/bin/bash

# ffmpeg installation script for centos 
# __author__ : Mansoor (digitz.org)


function banner {

	echo -en "
+++++++++++++++++++++++++++++++++++++++++
+    FFmpeg Installer for CentOS        +
+++++++++++++++++++++++++++++++++++++++++
Please note that this is for Centos 
Choose an option below: 
    1. Install FFmpeg
    2. Uninstall FFmpeg
    3. Exit and do nothing
    Your Choice : "


}


function install {

	echo "Installing dependencies..!"

    # install required dependencies
    yum -y install autoconf automake bzip2 bzip2-devel cmake freetype-devel gcc gcc-c++ git libtool make mercurial pkgconfig zlib-devel

    # create base directory
    mkdir ~/ffmpeg_sources

    # Nasm
    echo "Installing Nasm..."
    cd ~/ffmpeg_sources
    curl -O -L https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2
    tar xjvf nasm-2.14.02.tar.bz2
    cd nasm-2.14.02
    ./autogen.sh
    ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
    make
    make install

    # Yasm
    echo "Installing Yasm..."
    cd ~/ffmpeg_sources
    curl -O -L https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
    tar xzvf yasm-1.3.0.tar.gz
    cd yasm-1.3.0
    ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
    make
    make install

    # x264
    echo "Installing x264..."
    cd ~/ffmpeg_sources
    git clone --depth 1 https://code.videolan.org/videolan/x264.git
    cd x264
    PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
    make
    make install

    # x265
    echo "Installing x265..."
    cd ~/ffmpeg_sources
    hg clone https://bitbucket.org/multicoreware/x265
    cd ~/ffmpeg_sources/x265/build/linux
    cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
    make
    make install

    # libfdk_aac
    echo "Installing libfdk_aac..."
    cd ~/ffmpeg_sources
    git clone --depth 1 https://github.com/mstorsjo/fdk-aac
    cd fdk-aac
    autoreconf -fiv
    ./configure --prefix="$HOME/ffmpeg_build" --disable-shared
    make
    make install

    # libmp3lame
    echo "Installing libmp3lame..."
    cd ~/ffmpeg_sources
    curl -O -L https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
    tar xzvf lame-3.100.tar.gz
    cd lame-3.100
    ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
    make
    make install

    # libopus
    echo "Installing libopus..."
    cd ~/ffmpeg_sources
    curl -O -L https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz
    tar xzvf opus-1.3.1.tar.gz
    cd opus-1.3.1
    ./configure --prefix="$HOME/ffmpeg_build" --disable-shared
    make
    make install

    # libvpx
    echo "Installing libvpx..."
    cd ~/ffmpeg_sources
    git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
    cd libvpx
    ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
    make
    make install

    # ffmpeg
    echo "Installing ffmpeg..."
    cd ~/ffmpeg_sources
    curl -O -L https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
    tar xjvf ffmpeg-snapshot.tar.bz2
    cd ffmpeg
    PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
    --prefix="$HOME/ffmpeg_build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$HOME/ffmpeg_build/include" \
    --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
    --extra-libs=-lpthread \
    --extra-libs=-lm \
    --bindir="$HOME/bin" \
    --enable-gpl \
    --enable-libfdk_aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    --enable-nonfree
    make
    make install
    hash -d ffmpeg

}

function uninstall {
    echo "Removing FFmpeg..!!"
    rm -rf ~/ffmpeg_build ~/ffmpeg_sources ~/bin/{ffmpeg,ffprobe,lame,nasm,vsyasm,x264,yasm,ytasm}
    yum erase autoconf automake bzip2 bzip2-devel cmake freetype-devel gcc gcc-c++ git libtool mercurial zlib-devel
    hash -r
}

function main {

	banner
	read choice
	if [[ $choice -eq 1 ]]; then

		echo "Are you sure you want to install FFmpeg?"
		echo "Press Enter to continue. Ctrl+C to exit"
		read
		install

	elif [[ $choice -eq 2 ]]; then
		
		echo "Are you sure you want to remove FFmpeg?"
		echo "Press Enter to continue. Ctrl+C to exit"
		read
		uninstall

	elif [[ $choice -eq 3 ]]; then

		echo "Chose to exit..!"
		exit

	else
		echo "Invalid option. "
		exit
	fi
}

main
