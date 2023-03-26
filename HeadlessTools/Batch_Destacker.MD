# Description
This script is for running headless (faster/hpc) batch destacking or 'chopping up' of your image datasets. Multi-dimensional datasets can be reduced by 
any or all of the following options; Channels, Slices, Frames.

# Global Variables
input = string for file path to input images (note a new directory will be made in this directory called "Output" <br>
suffix = string for the file suffix (e.g. ".tif", ".czi", ".nd2", etc) <br>
frames = boolean (0 or 1) to toggle on or off chopping up by frame <br>
slices = boolean (0 or 1) to toggle on or off chopping up by slice <br>
channels = boolean (0 or 1) to toggle on or off chopping up by channel <br>
subfolders = boolean (0 or 1) to toggle on or off creating subfolders for each image file <br>

# Example CLI input
~~~
ImageJ-win64.exe --ij2 --headless --console --run '[path to script file]' "input='[path to script file]', suffix='.tif', frames='1', slices='0', channels='0', subfolders='1'"
~~~
