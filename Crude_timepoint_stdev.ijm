windowtitle = getTitle();
getDimensions(width, height, channels, slices, frames);

newImage("output", "32-bit black", width, height, frames);

for(i=0; i<(frames-1);i++){
	selectWindow(windowtitle);
	run("Duplicate...", "duplicate range="+(i+1)+"-"+(i+2));
	rename("proj");
	run("Z Project...", "projection=[Standard Deviation]");
	rename("result");
	run("Select All");
	run("Copy");
	selectWindow("output");
	setSlice(i+1);
	run("Paste");
	selectWindow("result");
	close();
	selectWindow("proj");
	close();
}
selectWindow("output");
resetMinAndMax;

waitForUser("done");