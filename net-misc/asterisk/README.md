this configures a special version of 1.4 with patches for vicidial, and allows it to compile and run on gentoo.


since we use the hardened toolchain, for grsec, and pax, we have to disable the hardened profile in gcc temporarly during this build this is due to some bug that prevents sip from actually working.


this also runs a special version of the ibc downloader. the one that comes stock with 1.4 links to a url that is no longer valid, we also want this process to be automated so it is.

drewbeer