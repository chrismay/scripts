#!/bin/bash
awk '/Full/ {print ,}' gc.log | sed 's/[->K:\.]/ /g' | awk '{print ,}' > min_heap.csv
R --no-save < plot_min_heap.R
