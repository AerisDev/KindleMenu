#!/bin/sh
THUMBSPATH='/mnt/us/extensions/kindlegallery/bin/thumbs/' # pay attention: if changed, you must also change by hand this value in sed command below

mkdir -p "$THUMBSPATH" # create the folder if does not exist

count=0
eips 5 20 "                                     "
eips 5 21 "  Importing new images. $count found.    "
eips 5 22 "                                     "

# Set ImageMagick library path
MAGICK_HOME=/mnt/us/extensions/kindlegallery/bin/ImageMagick-6

# Prepare the image thumbnails for jpg and png files, if they don't exist already
cd /mnt/us/images
for filename in *.jpg; do [ -e "$filename" ] || continue; # This fixes a common bash pitfall
if [ ! -f "$THUMBSPATH$filename" ]; then  
    basename="$(basename "$filename" .jpg)"
    /mnt/us/extensions/kindlegallery/bin/convert -quality 70 -thumbnail 120x120^ -extent 120x120 -define jpeg:size=120x120 "$basename.jpg" "$THUMBSPATH$basename.jpg"
count=$(($count+1))
eips 5 20 "                                     "
eips 5 21 "  Importing new images. $count found.    "
eips 5 22 "                                     "
fi
done

for filename in *.JPG; do [ -e "$filename" ] || continue;
if [ ! -f "$THUMBSPATH$filename" ]; then  
    basename="$(basename "$filename" .JPG)"
    /mnt/us/extensions/kindlegallery/bin/convert -quality 70 -thumbnail 120x120^ -extent 120x120 -define jpeg:size=120x120 "$basename.JPG" "$THUMBSPATH$basename1.jpg"
mv "$THUMBSPATH$basename1.jpg" "$THUMBSPATH$basename.JPG"
count=$(($count+1))
eips 5 20 "                                     "
eips 5 21 "  Importing new images. $count found.    "
eips 5 22 "                                     "
fi
done

for filename in *.png; do [ -e "$filename" ] || continue;
if [ ! -f "$THUMBSPATH$filename" ]; then  
	    basename="$(basename "$filename" .png)"
	    /mnt/us/extensions/kindlegallery/bin/convert -quality 70 -thumbnail 120x120^ -extent 120x120  -define jpeg:size=120x120 "$basename.png" "$THUMBSPATH$basename.jpg"
		mv "$THUMBSPATH$basename.jpg" "$THUMBSPATH$basename.png"
count=$(($count+1))
eips 5 20 "                                     "
eips 5 21 "  Importing new images. $count found.    "
eips 5 22 "                                     "
fi
done

for filename in *.PNG; do [ -e "$filename" ] || continue;
if [ ! -f "$THUMBSPATH$filename" ]; then  
    basename="$(basename "$filename" .PNG)"
    /mnt/us/extensions/kindlegallery/bin/convert -quality 70 -thumbnail 120x120^ -extent 120x120 -define jpeg:size=120x120 "$basename.PNG" "$THUMBSPATH$basename.jpg"
mv "$THUMBSPATH$basename.jpg" "$THUMBSPATH$basename.PNG"
count=$(($count+1))
eips 5 20 "                                     "
eips 5 21 "  Importing new images. $count found.    "
eips 5 22 "                                     "
fi
done

for filename in *.gif; do [ -e "$filename" ] || continue;
if [ ! -f "$THUMBSPATH$filename" ]; then  
    basename="$(basename "$filename" .gif)"
    /mnt/us/extensions/kindlegallery/bin/convert -quality 70 -thumbnail 120x120^ -extent 120x120 -define jpeg:size=120x120 "$basename.gif" "$THUMBSPATH$basename.jpg"
mv "$THUMBSPATH$basename.jpg" "$THUMBSPATH$basename.gif"
count=$(($count+1))
eips 5 20 "                                     "
eips 5 21 "  Importing new images. $count found.    "
eips 5 22 "                                     "
fi
done


for filename in *.GIF; do [ -e "$filename" ] || continue;
if [ ! -f "$THUMBSPATH$filename" ]; then  
    basename="$(basename "$filename" .GIF)"
    /mnt/us/extensions/kindlegallery/bin/convert -quality 70 -thumbnail 120x120^ -extent 120x120 -define jpeg:size=120x120 "$basename.GIF" "$THUMBSPATH$basename.jpg"
mv "$THUMBSPATH$basename.jpg" "$THUMBSPATH$basename.GIF"
count=$(($count+1))
eips 5 20 "                                     "
eips 5 21 "  Importing new images. $count found.    "
eips 5 22 "                                     "
fi
done

# Build up the html page
ls /mnt/us/images > /mnt/us/extensions/kindlegallery/bin/html/body.html
cd /mnt/us/extensions/kindlegallery/bin/html/
sed -i 's|^.*$|<div class="imageOuter" onclick="showImage('\''&'\'')"><div class="imageIcon" style="background-image:url\('\''/mnt/us/extensions/kindlegallery/bin/thumbs/&'\''\)"><div class="imageName">&</div></div></div>|g' body.html
sed -i -r -n -e '/.jpg|.png|.JPG|.PNG|.gif|.GIF/p' body.html
cat header.html body.html footer.html > kindlegallery.html


# Open the gallery dialog
lipc-set-prop com.lab126.pillow customDialog '{"name": "../../../../mnt/us/extensions/kindlegallery/bin/html/kindlegallery", "clientParams": {"dismiss": true}}'

# remove thumbnails of deleted pics
cd "$THUMBSPATH"
for filename in *; do
if [ ! -f "/mnt/us/images/$filename" ]; then 
rm "$filename"
fi
done

