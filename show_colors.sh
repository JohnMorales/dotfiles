#!/bin/bash
#
#   This file echoes a bunch of color codes to the
#   terminal to demonstrate what's available.  Each
#   line is the color code of one forground color,
#   out of 17 (default + 16 escapes), followed by a
#   test use of that color on all nine background
#   colors (default + 8 escapes).
#

T='gYw'   # The test text
# Ascii escape char is 27, Hex \x1B, Octal 033

COLOR_NAMES=('' Black Red Green Yellow Blue Magenta Cyan White)
LIGHT_DARK=('' Bright)
echo -e "\n                 40m     41m     42m     43m\
     44m     45m     46m     47m";
FGS=('    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
     '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
     '  36m' '1;36m' '  37m' '1;37m')
for i in "${!FGS[@]}"
  do
  FG=${FGS[$i]// /}
  c=$((i/2))
  if [ $i -gt 2 ]; then l=$((i-2)); fi
  printf -v COLOR "%15s" "${LIGHT_DARK[$((l%2))]} ${COLOR_NAMES[$c]}"
  echo -en " $COLOR ${FGS[$i]} \033[$FG  $T  "
  for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
    do echo -en " \033[$FG\033[$BG  $T  \033[0m";
  done
  echo;
done
echo
