#!/bin/bash

# This is a script that is run (inside the docker container) each time it is stood up / restarted.
# You may customise this script to suit your needs if you plan on adding any special config into your setup which you wish to "script".
#
# All files will be copied into the "/etc/airtime-customisations" directory inside the container.
#
################################################################

# Get the directory that this script is in...
SCRIPT_PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"



# Example: Change background image with a new custom background...

BACKGROUND_FILE="/opt/libretime/airtime_mvc/public/css/radio-page/img/background-testing-3.jpg"
rm -rf "$BACKGROUND_FILE"
#cp "$SCRIPT_PWD/login-background.jpg" "$BACKGROUND_FILE"
cp "$SCRIPT_PWD/Fiverr(3).jpg" "$BACKGROUND_FILE"
chown www-data:www-data "$BACKGROUND_FILE"



# Example: Add in custom CSS to the login/homepage only..

HOMEPAGE_TEMPLATE="/opt/libretime/airtime_mvc/application/views/scripts/index/index.phtml"
CSS_CUSTOM_FILE="/opt/libretime/airtime_mvc/public/css/radio-page/custom.css"
CSS_STRING='<link href="/css/radio-page/custom.css" rel="stylesheet" type="text/css" />'

if ! grep -q "$CSS_STRING" "$HOMEPAGE_TEMPLATE"
then
    # Only add in CSS if it's not yet in the file...
    # adding at end (no <html> or <head> /<body> tags in this one)
    echo "BOOTSTRAP: Patching hompage CSS"
    echo "$CSS_STRING" >> "$HOMEPAGE_TEMPLATE"
fi

cp "$SCRIPT_PWD/login-custom.css" "$CSS_CUSTOM_FILE"
chown www-data:www-data "$CSS_CUSTOM_FILE"

# EDIT HOPAGE EMBEDED PLAYER CSS
# USE ICECAST NOW PLAYING WITH AUTODJ RUNNNG

PLAYER_TEMPLATE="/opt/libretime/airtime_mvc/application/views/scripts/embed/player.phtml"
CSS_CUSTOM_PLAYER_FILE="/opt/libretime/airtime_mvc/public/css/radio-page/custom_player.css"
PATCH_STRING_PLAYER='<link href="/css/radio-page/custom_player.css" rel="stylesheet" type="text/css" />'

PLAYER_JS_REPLACE_CONTENT=`cat $SCRIPT_PWD/playermetadata.js`

echo "BOOTSTRAP: Begining Patch Process"
if ! grep -q "$PATCH_STRING_PLAYER" "$PLAYER_TEMPLATE"
then
    # Only add in CSS if it's not yet in the file...
    # adding at line 239
    echo "BOOTSTRAP: Patching player CSS"
    sed -i "239i\ \n $PATCH_STRING_PLAYER" "$PLAYER_TEMPLATE"

    # echo "BOOTSTRAP: Patching Plyer autoDJ metadata"
    # awk -v r="$PLAYER_JS_REPLACE_CONTENT" 'NR==309 { $0=r }1' "$PLAYER_TEMPLATE" > ./tmp_player.phtml && mv ./tmp_player.phtml "$PLAYER_TEMPLATE"
fi

cp "$SCRIPT_PWD/player-custom.css" "$CSS_CUSTOM_PLAYER_FILE"
chown www-data:www-data "$CSS_CUSTOM_PLAYER_FILE"



# EDIT HOMEPAGE EMBEDED SCHEDULE CSS

SCHEDULE_TEMPLATE="/opt/libretime/airtime_mvc/application/views/scripts/embed/weekly-program.phtml"
CSS_CUSTOM_SCHEDULE_FILE="/opt/libretime/airtime_mvc/public/css/radio-page/custom_schedule.css"
CSS_STRING_SCHEDULE='<link href="/css/radio-page/custom_schedule.css" rel="stylesheet" type="text/css" />'

if ! grep -q "$CSS_STRING_SCHEDULE" "$SCHEDULE_TEMPLATE"
then
    # Only add in CSS if it's not yet in the file...
    # adding at line 75
    echo "BOOTSTRAP: Patching schedule CSS"
    sed -i "75i\ \n $CSS_STRING_SCHEDULE" "$SCHEDULE_TEMPLATE"
fi

cp "$SCRIPT_PWD/schedule-custom.css" "$CSS_CUSTOM_SCHEDULE_FILE"
chown www-data:www-data "$CSS_CUSTOM_SCHEDULE_FILE"

# PATCH player bar images

PLAYER_IMAGE_FOLDER="/opt/libretime/airtime_mvc/public/css/radio-page/img"

declare -a img_arr=("play" "pause" "schedule" "about_us" "podcast" "rss" "login" "login-small")

echo 'BOOTSTRAP: Patching homepage images'
for i in "${img_arr[@]}"
do
    IMAGE_TO_COPY="$SCRIPT_PWD/homepage_img/"$i"_custom.png"
    IMAGE_DEST="$PLAYER_IMAGE_FOLDER/"$i".png"
    echo "BOOTSTRAP: copy $IMAGE_TO_COPY --> $IMAGE_DEST"
    cp "$IMAGE_TO_COPY" "$IMAGE_DEST"
done



# Example: Add Google Analytics tracking on the homepage...
# HOMEPAGE_TEMPLATE="/opt/libretime/airtime_mvc/application/views/scripts/index/index.phtml"
# GA_SITE_TAG='<!-- GA-SITE-TAG -->'

# # Update this with your real Google Analytics Site ID
# GA_SITE_ID="UA-126119626-1"

# if ! grep -q "$GA_SITE_TAG" "$HOMEPAGE_TEMPLATE"
# then

#     # Only add in GA Javascript if it's not yet in the file...
#     echo '<!-- GA-SITE-TAG -->
#     <script async src="https://www.googletagmanager.com/gtag/js?id=UA-126119626-1"></script>
#     <script>
#       window.dataLayer = window.dataLayer || [];
#       function gtag(){dataLayer.push(arguments);}
#       gtag("js", new Date());

#       gtag("config", "'"$GA_SITE_ID"'");
#     </script>' >> "$HOMEPAGE_TEMPLATE"

# fi


# # Example: Change CSS Colours with the schedule/calendar on the login page
# WEEKLY_PROGRAM="/opt/libretime/airtime_mvc/application/views/scripts/embed/weekly-program.phtml"
# WEEKLY_PROGRAM_TAG='<!-- IFRAME-CSS-ADDITIONS -->'

# if ! grep -q "$WEEKLY_PROGRAM_TAG" "$WEEKLY_PROGRAM"
# then

#     # Only add in GA Javascript if it's not yet in the file...
#     echo '<!-- IFRAME-CSS-ADDITIONS -->
#     <link type="text/css" rel="Stylesheet" href="/assets/css/schedule.css" />
#     ' >> "$WEEKLY_PROGRAM"

# fi

echo "BOOTSTRAP: Finishing Patch Process"
