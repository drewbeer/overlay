this configures a special version of 1.4 with patches for vicidial, and allows it to compile and run on gentoo.


since we use the hardened toolchain, for grsec, and pax, we have to disable the hardened profile in gcc temporarly during this build this is due to some bug that prevents sip from actually working.


