#!/bin/bash

grep -rho '\b[[:upper:]_]\+\b' ../game/src/ | sort | uniq > found
grep -rho '\b[[:upper:]_]\+\b' ../game/translations/translations.csv | sort | uniq > available

grep -v -F -x -f available found > missing

