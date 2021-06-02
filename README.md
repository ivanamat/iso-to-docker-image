# Kubuntu XRDP docker image

## Requirements

First, you need to install squash-fs. To do this, open a terminal window and issue the command:
```bash
sudo apt-get install squashfs-tools -y
```

You need to have Docker installed. For more information about how to install docker, visit the [official page](https://docs.docker.com/get-docker/).  

## How to mount the ISO

Download your preferred distribution. In my case, Kubuntu.  

Create the *rootfs* and *unsquashfs* folders:
```bash
mkdir rootfs unsquashfs
```

To mount the ISO image into the rootfs folder, issue the command:
```bash
sudo mount -o loop ~/Downloads/kubuntu-21.04-desktop-amd64.iso ./rootfs
```

We need to locate the directory housing the filesystem.squashfs file. To do that, change into the rootfs directory with the command:
```bash
cd ./rootfs
```

Locate the file with the command:
```bash
find . -type f | grep filesystem.squashfs
```

On the Ubuntu/Kubuntu ISO, that file should be located in the casper directory.  

Now that we know where the filesystem.squashfs file is, we can extract the necessary filesystem files from the rootfs directory into the unsquashfs directory with the commands:  

Back to previous directory:
```bash
cd ..
```

Extract the necessary filesystem files from the rootfs directory into the unsquashfs directory:
```bash
sudo unsquashfs -f -d unsquashfs/ rootfs/casper/filesystem.squashfs
```

Remember to replace casper with the directory housing your ISO filesystem.squashfs file.  

## How to compress and import the image

Finally, we can compress and import the image using Docker. To do this, issue the command:
```bash
sudo tar -C unsquashfs -c . | docker import - IMAGENAME/TAG
```

Where IMAGENAME is the name you want to give the image and TAG is a tag for the image. When the process completes, you'll see an sha256 hash for the image printed out.  

To see your Docker image listed, issue the command:
```bash
docker images
```

Your newly crafted image should appear.

## References

This was read on the [TechRepublic Blog](https://www.techrepublic.com/article/how-to-convert-an-iso-to-a-docker-image/)
