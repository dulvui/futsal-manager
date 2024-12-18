#!/bin/bash
# SPDX-FileCopyrightText: 2023 Simon Dalvai <info@simondalvai.org>

# SPDX-License-Identifier: AGPL-3.0-or-later


grep -rho '\b[[:upper:]_]\+\b' ../game/src/ | sort | uniq > found
grep -rho '\b[[:upper:]_]\+\b' ../game/translations/translations.csv | sort | uniq > available

grep -v -F -x -f available found > missing

