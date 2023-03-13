# Description
This script is for running headless (faster/hpc) batch Z-projection processing of image files. It also can concatinate the individual Z-stacks into a single uncompressed avi file.

# Global Variables
input = string for file path to input images (note a new directory will be made in this directory called "Output"
suffix = string for the file suffix (e.g. ".tif", ".czi", ".nd2", etc)
projectiontype = "Max Intensity", "Min Intensity", "Average Intensity", "Sum Slices"
conc = boolean (0 or 1) to toggle on or off making a concatinated output file
fps = number for the frames per second of the output avi file (optional)

# Example CLI input
$ ImageJ-win64.exe --ij2 --headless --console --run '[path to script file]' "input='[path to input directory]', suffix='.tif', projectiontype='Max Intensity', conc='1', fps='1'"
