#!/bin/bash

HERE="$(pwd)"

sh "$HERE/module_Testable/test.sh" "$HERE/Recipes" "$HERE/Core" && \
sh "$HERE/module_Testable/test.sh" "$HERE/Recipes" "$HERE/Propriatery"