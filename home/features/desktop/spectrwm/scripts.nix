{pkgs, ...}: {
  # scripts
  home.packages = with pkgs; [
    iproute2
    gawk

    alsa-utils
    libcanberra-gtk3 # change volume sound

    (pkgs.writeScriptBin "startup_action" ''
      #!/usr/bin/env bash

      xrandr --output DP-2 --mode 1920x1080 --rate 144
      ~/.fehbg
    '')

    (pkgs.writeScriptBin "change_volume" ''
      #!/usr/bin/env bash

      # arbitrary but unique message tag
      msgTag="myvolume"

      # change the volume using alsa(might differ if you use pulseaudio)
      amixer set Master "$@" > /dev/null

      # query amixer for the current volume and whether or not the speaker is muted
      volume="$(amixer get Master | grep "Front Left:" | grep -o "\[[0-9]*%\]" | cut -d '[' -f 2 | cut -d '%' -f 1)"
      mute="$(amixer get Master | grep "Front Left:" | grep -o "\[[a-z]*\]$" | tr -d '[]')"
      if [[ $volume == 0 || "$mute" == "off" ]]; then
          dunstify -a "changeVolume" -u low -i audio-volume-muted -h string:x-dunst-stack-tag:$msgTag "Volume muted"
      else
          dunstify -a "changeVolume" -u low -i audio-volume-high -h string:x-dunst-stack-tag:$msgTag \
          -h int:value:"$volume" "Volume: ''\${volume}%"
      fi

      # play the volume changed sound
      canberra-gtk-play -i audio-volume-change -d "changeVolume"
    '')

    (pkgs.writeScriptBin "bar_action" ''
      #!/usr/bin/env bash

      ## LOCAL IP
      local_ip() {
        myip=`ip route get 1.1.1.1 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}'`
        echo -e "$myip"
      }

      ## RAM
      mem() {
        mem=`free | awk '/Mem/ {printf "%dM/%dM\n", $3 / 1024.0, $2 / 1024.0 }'`
        echo -e "$mem"
      }

      ## CPU
      cpu() {
        read cpu a b c previdle rest < /proc/stat
        prevtotal=$((a+b+c+previdle))
        sleep 0.5
        read cpu a b c idle rest < /proc/stat
        total=$((a+b+c+idle))
        cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
        echo -e "$cpu%"
      }

      ## BAT
      bat_cap() {
          bat=`cat /sys/class/power_supply/BAT0/capacity`
          status=`cat /sys/class/power_supply/BAT0/status`
          if [[ "$STATUS" == "Charging" ]]; then
            charging="+"
          elif [[ "$STATUS" == "Discharging" ]]; then
            charging="-"
          else
            charging="?"
          fi

          echo -e "$bat% $charging"
      }

      SLEEP_SEC=3
      #loops forever outputting a line every SLEEP_SEC secs

      # It seems that we are limited to how many characters can be displayed via
      # the baraction script output. And the the markup tags count in that limit.
      # So I would love to add more functions to this script but it makes the
      # echo output too long to display correctly.
      while :; do
          if [[ -d "/sys/class/power_supply/BAT0" ]]; then
             # Laptop
             echo "$(local_ip) | cpu $(cpu) | mem $(mem) | bat $(bat_cap)"
          else
             # Desktop
             echo "$(local_ip) | cpu $(cpu) | mem $(mem) |"
          fi
        sleep $SLEEP_SEC
      done
    '')
  ];
}
