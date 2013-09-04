#!/bin/sh -e

wget -P codecs/ilbc http://www.ietf.org/rfc/rfc3951.txt

wget -q -O - http://www.ilbcfreeware.org/documentation/extract-cfile.txt | tr -d '\r' > codecs/ilbc/extract-cfile.awk

(cd codecs/ilbc && awk -f extract-cfile.awk rfc3951.txt)

echo "***"
echo "The iLBC source code download is complete."
echo "***"

exit 0
