#!/usr/bin/env bash

_detect_gpu() {
    local gpus; gpus=$(lspci | grep -i 'VGA\|3D\|Display')
    has_nvidia=false; has_amd=false; has_intel=false
    echo "$gpus" | grep -qi nvidia        && has_nvidia=true
    echo "$gpus" | grep -qi 'amd\|radeon' && has_amd=true
    echo "$gpus" | grep -qi intel         && has_intel=true
    _gpu_gpus="$gpus"
}
