# filebot-rpi

Docker image for running FileBot on a Raspberry Pi. Based on the work of
[Pablo Fredrikson](https://github.com/pablokbs/docker-filebot-rpi).

It works by watching a directory for new files or folders, and sorting those into
another directory using hard links in a format ready for Kodi.

## Running

`docker run -d --name filebot --restart always -v /media:/media -v filebot_data:/data phrontizo/filebot-rpi:latest`

I use this on a Raspberry Pi 3B+, running LibreElec, with the Docker addon and Deluge in a separate container.

## Volumes

### media

This is a single filesystem containg both the input and output folders. It has to
be a single filesystem for the hard links to work. I use it with the following layout:

```
`-- media
    |-- Downloads
    |   |-- in-progress
    |   |   `-- Torrent download directory
    |   `-- complete
    |       `-- Have your torrent client move files here when they complete downloading (but are still seeding)
    |-- Movies
    |   `-- FileBot output directory for movies
    |-- TV Shows
    |   `-- FileBot output directory for TV shows
    |-- Music
    |   `-- FileBot output directory for music
    `-- Unsorted
        `-- FileBot output directory for unknown files
```
The input and output folders can be controlled with the following environment variables:

1. `INPUT_DIR` Is the directory into which completed downloads are placed. Default is `/media/Downloads/completed`.
2. `OUTPUT_DIR` Is the directory into which the sorted files are placed. Default is `/media`.

### data

This volume contains the FileBot data, including ignore lists and other information.
I tend to leave this ephemeral as FileBot has a habit of adding files that it
failed to process to the exclusion list. Removing and recreating the container
then clears this out and allows it to run over the same files again (with a quick
`mv` out and back into the `INPUT_DIR`).

## Environment Variables

The following variables control the operation of FileBot:

1. `SETTLE_DOWN_TIME` (default 600)  
The time (in seconds) to wait for moves to finish. If your in-progress and completed directories are on the same filesystem, this can be short.
2. `FILEBOT_ACTION` (default `hardlink`)  
The action to take for organising the files  
    * `hardlink` creates hardlinks to the original video files
    * `duplicate` creates copies

FileBot supports [others](https://www.filebot.net/cli.html), but they aren't tested at all. `hardlink` is the only one to receive extensive testing.
