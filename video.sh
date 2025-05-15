#!/usr/bin/env bash

ffmpeg -y -ss 00:07:00 -t 00:00:30 -i "$1" -c:a copy Short_1080p.mp4
ffmpeg -y -ss 00:07:00 -t 00:00:30 -i "$1" -c:v libvpx-vp9 -c:a copy Short_1080p_vp9.mp4
ffmpeg -y -ss 00:07:00 -t 00:00:30 -i "$1" -c:v libx265 -preset medium -c:a copy Short_1080p_hevc.mp4
ffmpeg -y -ss 00:07:00 -t 00:00:30 -i "$1" -c:v libaom-av1 -cpu-used 5 -c:a copy Short_1080p_av1.mp4

ffmpeg -y -ss 00:07:00 -t 00:00:30 -i "$1" -filter:v scale=-1:720 -c:a copy Short_720p.mp4
ffmpeg -y -ss 00:07:00 -t 00:00:30 -i "$1" -filter:v scale=-1:720 -c:v libvpx-vp9 -c:a copy Short_720p_vp9.mp4
ffmpeg -y -ss 00:07:00 -t 00:00:30 -i "$1" -filter:v scale=-1:720 -c:v libx265 -preset medium -c:a copy Short_720p_hevc.mp4
ffmpeg -y -ss 00:07:00 -t 00:00:30 -i "$1" -filter:v scale=-1:720 -c:v libaom-av1 -cpu-used 5 -c:a copy Short_720p_av1.mp4

ffmpeg -y -ss 00:07:00 -t 00:00:30 -i "$1" -filter:v scale=-1:576 -c:a copy Short_576p.mp4
ffmpeg -y -ss 00:07:00 -t 00:00:30 -i "$1" -filter:v scale=-1:576 -c:v libvpx-vp9 -c:a copy Short_576p_vp9.mp4
ffmpeg -y -ss 00:07:00 -t 00:00:30 -i "$1" -filter:v scale=-1:576 -c:v libx265 -preset medium -c:a copy Short_576p_hevc.mp4
ffmpeg -y -ss 00:07:00 -t 00:00:30 -i "$1" -filter:v scale=-1:576 -c:v libaom-av1 -cpu-used 5 -c:a copy Short_576p_av1.mp4
