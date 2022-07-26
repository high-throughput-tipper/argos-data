#!/usr/bin/env bash

Rscript R/0-integrate.R
Rscript R/1-quality-control.R
Rscript R/2-normalization.R
