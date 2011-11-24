# Bootsummer
Bootsummer is a small bash script intended to handle the distribution of sha512 checksums of all files in /boot to ssh servers and consequently being able to verify the local files wether a change happened.
This can be useful when you run filesystem/LVM encryption while not having the whole boot partition including the most critical part: kernel and initrd unencrypted. Since they can be still modified by persons with physical access to the machine it's useful that you can verify them.

The Script will, depending on your choice, generate sha512 checksums over all files found in /boot.
After that, it proceeds uploading the generated list of sums with the current date to all servers in the cfg.
If you choose to verify the sums, the script pulls the sums back and pipes them into sha512sum -c for verification and eventually prints a warning msg.

## Configuration
The "configuration" file simply consists of a list of hosts separated by newlines. Those can be also aliases since the script is effectively uses it to connect.
It will be quite complicated to use this program not havin ssh-agent running since it does batch processing of the servers listed.
