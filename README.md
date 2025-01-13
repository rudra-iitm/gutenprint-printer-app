# Gutenprint Printer Application

## INTRODUCTION

This repository contains a Printer Application for printing with the
Gutenprint printer driver. This allows high-quality printing on a wide
range of inkjet, lasre, and dye-sublimation printers, especially
inkjets from Epson and Canon, PCL laser printers (both monochrome and
color), and dye-sublimation photo printers. This driver is especially
recommended for photos and fine-art printing. It is also an
alternative to the [Ghostscript Printer
Application](https://github.com/OpenPrinting/ghostscript-printer-app)
for PCL 4/5c/e laser printers.

It uses [PAPPL](https://www.msweet.org/pappl) to support IPP printing
from multiple operating systems. In addition, it uses the resources of
[cups-filters 2.x](https://github.com/OpenPrinting/cups-filters)
(filter functions in libcupsfilters, libppd) and
[pappl-retrofit](https://github.com/OpenPrinting/pappl-retrofit)
(encapsulating classic CUPS drivers in Printer Applications). The code
of pappl-retrofit is derived from the
[hp-printer-app](https://github.com/michaelrsweet/hp-printer-app).

The printer driver itself and the software to communicate with the
printer hardware is taken from the [Gutenprint
project](http://gimp-print.sourceforge.net/), also the Information
about supported printer models and their capabilities.

Your contributions are welcome. Please post [issues and pull
requests](https://github.com/OpenPrinting/gutenprint-printer-app).

**Note: Gutenprint is an actively maintained project, therefore it
would also be the correct way if Gutenprint gets turned into a Printer
Application by its maintainers, or at least this be offered as an
alternative to the classic CUPS driver. Especially they should create
a native Printer Application, meaning that it does not use PPDs, CUPS
filters, and CUPS backends internally. As soon as the Gutenprint
project provides a native Printer Application, this Printer
Application retro-fitting the CUPS driver will get discontinued.**

Please check whether your printer is a driverless IPP printer
(AirPrint, Mopria, IPP Everywhere, Wi-Fi Direct Print, prints from
phones) as in this case you do not need any Printer Application at
all. Most modern printers, even the cheapest models, are driverless
IPP printers. Even USB-only printers can be driverless IPP, and you
can generally use driverless IPP via USB, try
[ipp-usb](https://github.com/OpenPrinting/ipp-usb) for these cases
first.


### Properties

- A Printer Application providing the Gutenprint CUPS Raster printer
  driver and all printer's PPDs of Gutenprint. This allows easy
  printing in high quality, including photos on photo paper. The
  specialized CUPSbackend for dye sublimation printers with
  proprietary USB communication protocols is also included.

- The Printer Application checks the supported number of
  vendor-specific options/attributes of the installed PAPPL library,
  `PAPPL_MAX_VENDOR` and uses the expert PPDs only if 256 or more
  vendor-specific options are supported, otherwise the simplified PPDs
  are used. By default, the number is 32 and in the Snap we modify it
  to be 256, meaning that the Gutenprint Printer Application Snap in
  the Snap Store uses expert PPDs, while a quick build with `make`,
  using an installed standard PAPPL library uses the simplified PPD
  files.

- Available printer devices are discovered (and used) with CUPS'
  backends and with Gutenprint's dye-sublimation printer backend in
  addition and not with PAPPL's own backends. This way dye-sublimation
  printers are discovered with the correct backend for their totally
  proprietary communication protocol. Also quirk workarounds for USB
  printers with compatibility problems are used (and are editable) and
  Gutenprint output can get send to the printer via IPP, IPPS
  (encrypted!), and LPD in addition to socket (usually port 9100). The
  SNMP backend can get configured (community, address scope).

- If you have an unusual system configuration or a personal firewall
  your printer will perhaps not get discovered. In this situation the
  fully manual "Network Printer" entry in combination with the
  hostname/IP field can be helpful.

- PWG Raster, Apple Raster or image input data does not get converted
  to PostScript or PDF, it is only converted/scaled to the required
  color space and resolution and then fed into the Gutenprint CUPS
  Raster driver.

- PDF and PostScript input data is rendered into raster data using
  Ghostscript.

- The information about which printer models are supported and which
  are their capabilities is based on the PPD files which get
  auto-generated by Gutenprint when using it with CUPS. The PPD
  generator is included in the Snap.

- Standard job IPP attributes are mapped to the driver's option
  settings best fitting to them so that users can print from any type
  of client (like for example a phone or IoT device) which only
  supports standard IPP attributes and cannot retrive the PPD
  options. Trays, media sizes, media types, and duplex can get mapped
  easily, but when it comes to color and quality it gets more complex,
  as relevant options differ a lot in the PPD files. Here we use an
  algorithm which automatically (who wants hand-edit ~3000 PPD files
  for the assignments) finds the right set of option settings for each
  combination of `print-color-mode` (`color`/`monochrome`),
  `print-quality` (`draft`/`normal`/`high`), and
  `print-content-optimize`
  (`auto`/`photo`/`graphics`/`text`/`text-and-graphics`) in the PPD of
  the current printer. So you have easy access to the full quality or
  speed of your printer without needing to deal with printer-specific
  option settings (the original options are still accessible via web
  admin interface).

### To Do

- PDF test page, for example generated with the bannertopdf filter, or
  perhaps even a Raster test page.

- Human-readable strings for vendor options (Needs support by PAPPL:
  [Issue #58: Localization
  support](https://github.com/michaelrsweet/pappl/issues/58))

- Internationalization/Localization (Needs support by PAPPL: [Issue
  #58: Localization
  support](https://github.com/michaelrsweet/pappl/issues/58))

- SNMP Ink level check via ps_status() function (Needs support by PAPPL:
  [Issue #83: CUPS does IPP and SNMP ink level polls via backends,
  PAPPL should have functions for
  this](https://github.com/michaelrsweet/pappl/issues/83))


## THE SNAP

### Installing and building

To just run and use this Printer Application, simply install it from
the Snap Store:

```
sudo snap install --edge gutenprint-printer-app
```

Then follow the instructions below for setting it up.

To build the Snap by yourself, in the main directory of this
repository run

```
snapcraft snap
```

This will download all needed packages and build the Gutenprint
Printer Application. Note that PAPPL and cups-filters (upcoming 2.0)
are pulled directly from their GIT repositories, as there are no
appropriate releases yet. This can also lead to the fact that this
Printer Application will suddenly not build any more.

To install the resulting Snap run

```
sudo snap install --dangerous gutenprint-printer-app_1.0_amd64.snap
```


### Setting up

The Printer Application will automatically be started as a server daemon.

Enter the web interface

```
http://localhost:8000/
```

Use the web interface to add a printer. Supply a name, select the
discovered printer, then select make and model. Also set the installed
accessories, loaded media and the option defaults. Accessory
configuration and option defaults can also offen get polled from the
printer.

Then print PDF, PostScript, JPEG, Apple Raster, or PWG Raster files
with

```
gutenprint-printer-app FILE
```

or print with CUPS, CUPS (and also cups-browsed) discover and treat
the printers set up with this Printer Application as driverless IPP
printers (IPP Everywhere and AirPrint).

See

```
gutenprint-printer-app --help
```

for more options.

Use the "-o log-level=debug" argument for verbose logging in your
terminal window.

You can add files to `/var/snap/gutenprint-printer-app/common/usb/`
for additional USB quirk rules. Edit the existing files only for quick
tests, as they get replaced at every update of the Snap (to introduce
new rules).

You can edit the
`/var/snap/gutenprint-printer-app/common/cups/snmp.conf` file for
configuring SNMP network printer discovery.

## THE ROCK (OCI CONTAINER IMAGE)

### Install from Docker Hub
#### Prerequisites

1. **Docker Installed**: Ensure Docker is installed on your system. You can download it from the [official Docker website](https://www.docker.com/get-started).
```sh
  sudo snap install docker
```

#### Step-by-Step Guide

You can pull the `gutenprint-printer-app` Docker image from either the GitHub Container Registry or Docker Hub.

**From GitHub Container Registry** <br>
To pull the image from the GitHub Container Registry, run the following command:
```sh
  sudo docker pull ghcr.io/openprinting/gutenprint-printer-app:latest
```

To run the container after pulling the image from the GitHub Container Registry, use:
```sh
  sudo docker run -d \
      --name gutenprint-printer-app \
      --network host \
      -e PORT=<port> \
      ghcr.io/openprinting/gutenprint-printer-app:latest
```

**From Docker Hub** <br>
Alternatively, you can pull the image from Docker Hub, by running:
```sh
  sudo docker pull openprinting/gutenprint-printer-app
```

To run the container after pulling the image from Docker Hub, use:
```sh
  sudo docker run -d \
      --name gutenprint-printer-app \
      --network host \
      -e PORT=<port> \
      openprinting/gutenprint-printer-app:latest
```

- `PORT` is an optional environment variable used to start the printer-app on a specified port. If not provided, it will start on the default port 8000 or, if port 8000 is busy, on 8001 and so on.
- **The container must be started in `--network host` mode** to allow the Printer-Application instance inside the container to access and discover printers available in the local network where the host system is in.
- Alternatively using the internal network of the Docker instance (`-p <port>:8000` instead of `--network host -e PORT=<port>`) only gives access to local printers running on the host system itself.

### Setting Up and Running gutenprint-printer-app locally

#### Prerequisites

**Docker Installed**: Ensure Docker is installed on your system. You can download it from the [official Docker website](https://www.docker.com/get-started) or from the Snap Store:
```sh
  sudo snap install docker
```

**Rockcraft**: Rockcraft should be installed. You can install Rockcraft using the following command:
```sh
  sudo snap install rockcraft --classic
```

**Skopeo**: Skopeo should be installed to compile `*.rock` files into Docker images. It comes bundled with Rockcraft, so no separate installation is required.

#### Step-by-Step Guide

**Build gutenprint-printer-app rock**

The first step is to build the Rock from the `rockcraft.yaml`. This image will contain all the configurations and dependencies required to run gutenprint-printer-app.

Open your terminal and navigate to the directory containing your `rockcraft.yaml`, then run the following command:

```sh
  rockcraft pack -v
```

**Compile to Docker Image**

Once the rock is built, you need to compile docker image from it.

```sh
  sudo rockcraft.skopeo --insecure-policy copy oci-archive:<rock_image> docker-daemon:gutenprint-printer-app:latest
```

**Run the gutenprint-printer-app Docker Container**

```sh
  sudo docker run -d \
      --name gutenprint-printer-app \
      --network host \
      -e PORT=<port> \
      gutenprint-printer-app:latest
```
- `PORT` is an optional environment variable used to start the printer-app on a specified port. If not provided, it will start on the default port 8000 or, if port 8000 is busy, on 8001 and so on.
- **The container must be started in `--network host` mode** to allow the Printer-Application instance inside the container to access and discover printers available in the local network where the host system is in.
- Alternatively using the internal network of the Docker instance (`-p <port>:8000` instead of `--network host -e PORT=<port>`) only gives access to local printers running on the host system itself.

#### Setting up

Enter the web interface

```sh
http://localhost:<port>/
```

Use the web interface to add a printer. Supply a name, select the
discovered printer, then select make and model. Also set the installed
accessories, loaded media and the option defaults. If the printer is a
PostScript printer, accessory configuration and option defaults can
also often get polled from the printer.

<!-- Begin Included Components -->

<!-- End Included Components -->

## BUILDING WITHOUT PACKAGING OR INSTALLATION

You can also do a "quick-and-dirty" build without snapping and without
needing to install [PAPPL](https://www.msweet.org/pappl),
[cups-filters 2.x](https://github.com/OpenPrinting/cups-filters), and
[pappl-retrofit](https://github.com/OpenPrinting/pappl-retrofit) into
your system. You need a directory with the latest GIT snapshot of
PAPPL, the latest GIT snapshot of cups-filters, and the latest GIT
snapshot of pappl-retrofit (master branches of each). They all need to
be compiled (`./autogen.sh; ./configure; make`), installing not
needed. Also install the header files of all needed libraries
(installing "libcups2-dev" should do it).

In the directory with gutenprint-printer-app.c run the command line

```
gcc -o gutenprint-printer-app gutenprint-printer-app.c $PAPPL_SRC/pappl/libpappl.a $CUPS_FILTERS_SRC/.libs/libppd.a $CUPS_FILTERS_SRC/.libs/libcupsfilters.a $PAPPL_RETROFIT_SRC/.libs/libpappl-retrofit.a -ldl -lpthread  -lppd -lcups -lavahi-common -lavahi-client -lgnutls -ljpeg -lpng16 -ltiff -lz -lm -lusb-1.0 -lpam -lqpdf -lstdc++ -I. -I$PAPPL_SRC/pappl -I$CUPS_FILTERS_SRC/ppd -I$CUPS_FILTERS_SRC/cupsfilters -I$PAPPL_RETROFIT_SRC/pappl/retrofit -L$CUPS_FILTERS_SRC/.libs/ -L$PAPPL_RETROFIT_SRC/.libs/
```

There is also a Makefile, but this needs PAPPL, cups-filters 2.x, and
pappl-retrofit to be installed into your system.

Run

```
./gutenprint-printer-app --help
```

When running the non-snapped version, by default, PPD files are
searched for in

```
/usr/share/ppd/
/usr/lib/cups/driver/
/var/lib/gutenprint-printer-app/ppd/
```

You can set the `PPD_PATHS` environment variable to search other
places instead:

```
PPD_PATHS=/path/to/my/ppds:/my/second/place ./gutenprint-printer-app server
```

Simply put a colon-separated list of any amount of paths into the
variable. Creating a wrapper script is recommended.

Note that with a standard PAPPL installation only the simplified PPD
files of Gutenprint are considered, other PPD files are ignored. If
you want to use the expert PPDs of Gutenprint instead, you need to do
a simple modification on the PAPPL source code, setting
`PAPPL_MAX_VENDOR` in the pappl/printer.h to 256 instead of 32.

Printers are discovered via CUPS' backends plus Gutenprint's backend
for dye-sublimation printers using a proprietary USB communication
protocols. Printers are accepted if the model is explicitly supported,
but for some printers with common languages (especially PCL 4/5c/e)
there is also generic support.

USB Quirk rules in `/usr/share/cups/usb` and the `/etc/cups/snmp.conf`
file can get edited if needed.

Make sure you have Gutenprint and CUPS (at least its backends)
installed.

You also need Ghostscript to print PDF or PostScript jobs.

For access to the test page `testpage.ps` use the TESTPAGE_DIR
environment variable:

```
TESTPAGE_DIR=`pwd` PPD_PATHS=/path/to/my/ppds:/my/second/place ./gutenprint-printer-app server
```

or for your own creation of a test page (PostScript, PDF, PNG, JPEG,
Apple Raster, PWG Raster):

```
TESTPAGE=/path/to/my/testpage/my_testpage.ps PPD_PATHS=/path/to/my/ppds:/my/second/place ./gutenprint-printer-app server
```


## LEGAL STUFF

The Gutenprint Printer Application is Copyright © 2020 by Till Kamppeter.

It is derived from the HP PCL Printer Application, a first working model of
a raster Printer Application using PAPPL. It is available here:

https://github.com/michaelrsweet/hp-printer-app

The HP PCL Printer Application is Copyright © 2019-2020 by Michael R Sweet.

This software is licensed under the Apache License Version 2.0 with an exception
to allow linking against GPL2/LGPL2 software (like older versions of CUPS).  See
the files "LICENSE" and "NOTICE" for more information.