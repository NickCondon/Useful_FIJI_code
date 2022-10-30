roiManager("reset");

getDimensions(width, height, channels, slices, frames);
inputImage = getTitle();




boxSize = 50;
Xnum = width/boxSize;
Ynum = height/boxSize;

Xnum=Math.ceil(Xnum);
Ynum =Math.ceil(Ynum);
count = 1;
newImage("outputImage", "RGB black", width, height, Xnum*Ynum);

for (k = 0; k < Ynum; k++) {
	boxYpos = boxSize*k;
	
	for (i = 0; i < Xnum; i++) {
		selectWindow(inputImage);
		boxXpos = boxSize*i;
		makeRectangle(boxXpos, boxYpos, boxSize, boxSize);
		roiManager("add");
			roiManager("Remove Slice Info");
			roiManager("Remove Frame Info");

		roiManager("Select", count-1);
		run("Copy");
		selectWindow("outputImage");
		
		
		
		roiManager("Select", count-1);
		setSlice(count);
		run("Paste");
		
		//roiManager("reset");
		count = count+1;
		run("Collect Garbage");
	}
}



newImage("output2Image", "RGB black", width, height, Xnum*Ynum);


for (i = 0; i < nSlices; i++) {
	selectWindow("outputImage");
	run("Z Project...", "start=0 stop="+i+" projection=[Max Intensity]");
	run("Select All");
	run("Copy");
	close();
	selectWindow("output2Image");
	setSlice(i+1);
	run("Paste");
}
