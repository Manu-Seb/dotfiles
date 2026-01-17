!#/bin/zsh
grim -g "$(slurp)" - | tee ~/Pictures/Screenshot_$(date +%s).png | wl-copy
