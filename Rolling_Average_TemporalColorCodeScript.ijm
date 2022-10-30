print("\\Clear");
//	MIT License
//	Copyright (c) 2022 Nicholas Condon n.condon@uq.edu.au
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.

scripttitle= "Rolling Averaged Temporal Colour Tool";
version= "0.5";
date= "10-10-2022";
description= "Utilises a modified version of the temporal colour code script by Kota Miura (EMBL) followed by a user-defined rolling average (eg for 10; 1-11, 2-12, 3-13...) to show a coloured blurred timelapse sequence.";
showMessage("Institute for Molecular Biosciences ImageJ Script", "<html>
    +"<h1><font size=6 color=Teal>ACRF: Cancer Biology Imaging Facility</h1>
    +"<h1><font size=5 color=Purple><i>The University of Queensland</i></h1>
    +"<h4><a href=http://imb.uq.edu.au/Microscopy/>ACRF: Cancer Biology Imaging Facility</a><h4>
    +"<h1><font color=black>ImageJ Script Macro: "+scripttitle+"</h1> 
    +"<p1>Version: "+version+" ("+date+")</p1>"
    +"<H2><font size=3>Created by Nicholas Condon</H2>"
    +"<p1><font size=2> contact n.condon@uq.edu.au \n </p1>" 
    +"<P4><font size=2> Available for use/modification/sharing under the "+"<p4><a href=https://opensource.org/licenses/MIT/>MIT License</a><h4> </P4>"
    +"<P4><font size=2> For more detailed instructions see "+"<p4><a href=https://www.protocols.io/edit/movie-timepoint-copytoclipboard-tool-chutt6wn>Protocols.io</a><h4> </P4>"
    +"<h3>   <h3>"    
    +"<p1><font size=3  i>"+description+"</p1>
    +"<h1><font size=2> </h1>"  
	   +"<h0><font size=5> </h0>"
    +"");
print("");
print("FIJI Macro: "+scripttitle);
print("Version: "+version+" Version Date: "+date);
print("ACRF: Cancer Biology Imaging Facility");
print("By Nicholas Condon (2022) n.condon@uq.edu.au")
print("");
getDateAndTime(year, month, week, day, hour, min, sec, msec);
print("Script Run Date: "+day+"/"+(month+1)+"/"+year+"  Time: " +hour+":"+min+":"+sec);
print("");

waitForUser("Ensure the time-series file is open, then click OK");




Dialog.create("Title");
	Dialog.addNumber("Number of frames to average together", 10);
	Dialog.addCheckbox("Save Outputs as well?", 0);
Dialog.show();


rollingsSize = Dialog.getNumber();
saveOutput = Dialog.getCheckbox();

windowtitle = getTitle();


if(saveOutput==1){
	path = getDirectory("Choose Output Directory Location");
	resultsDir = path+"_RollingAverageOutput_"+"_"+year+"-"+month+"-"+day+"_at_"+hour+"."+min+"/"; 
	File.makeDirectory(resultsDir);
	}


/*

************* Temporal-Color Coder *******************************
Color code the temporal changes.

Kota Miura (miura@embl.de)
Centre for Molecular and Cellular Imaging, EMBL Heidelberg, Germany

If you publish a paper using this macro, please acknowledge.


---- INSTRUCTION ----

1. Open a stack (8 bit or 16 bit)
2. Run the macro
3. In the dialog choose one of the LUT for time coding.
	select frame range (default is full).
	check if you want to have color scale bar.

History

080212	created ver1 K_TimeRGBcolorcode.ijm
080213	stack slice range option added.
		time color code scale option added.

		future probable addiition: none-linear assigning of gray intensity to color intensity
		--> but this is same as doing contrast enhancement before processing.
101122  plugin'ified it
101123	fixed for cases when slices > 1 and frames == 1
*****************************************************************************
*/

var Glut = "Fire";	//default LUT
var Gstartf = 1;
var Gendf = 10;
var GFrameColorScaleCheck = 1;

macro "Time-Lapse Color Coder" {
	Stack.getDimensions(ww, hh, channels, slices, frames);
	if (channels > 1)
		exit("Cannot color-code multi-channel images!");
	//swap slices and frames in case:
	if ((slices > 1) && (frames == 1)) {
		frames = slices;
		slices = 1;
		Stack.setDimensions(1, slices, frames);
		//print("slices and frames swapped");
	}
	Gendf = frames;
	showDialog();
	if (Gstartf <1) Gstartf = 1;
	if (Gendf > frames) Gendf = frames;
	totalframes = Gendf - Gstartf + 1;
	calcslices = slices * totalframes;
	imgID = getImageID();

	//calledFromBatchMode = is("Batch Mode");
	//if (!calledFromBatchMode)
	//	setBatchMode(true);

	newImage("colored", "RGB White", ww, hh, calcslices);
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices="
		+ slices + " frames=" + totalframes + " display=Color");
	newimgID = getImageID();

	selectImage(imgID);
	run("Duplicate...", "duplicate");
	run("8-bit");
	imgID = getImageID();

	newImage("stamp", "8-bit White", 10, 10, 1);
	run(Glut);
	getLut(rA, gA, bA);
	close();
	nrA = newArray(256);
	ngA = newArray(256);
	nbA = newArray(256);

	newImage("temp", "8-bit White", ww, hh, 1);
	tempID = getImageID();

	for (i = 0; i < totalframes; i++) {
		colorscale = floor((256 / totalframes) * i);
		for (j = 0; j < 256; j++) {
			intensityfactor = j / 255;
			nrA[j] = round(rA[colorscale] * intensityfactor);
			ngA[j] = round(gA[colorscale] * intensityfactor);
			nbA[j] = round(bA[colorscale] * intensityfactor);
		}

		for (j = 0; j < slices; j++) {
			selectImage(imgID);
			Stack.setPosition(1, j + 1, i + Gstartf);
			run("Select All");
			run("Copy");

			selectImage(tempID);
			run("Paste");
			setLut(nrA, ngA, nbA);
			run("RGB Color");
			run("Select All");
			run("Copy");
			run("8-bit");

			selectImage(newimgID);
			Stack.setPosition(1, j + 1, i + 1);
			run("Select All");
			run("Paste");
		}
	}

	selectImage(tempID);
	close();

	selectImage(imgID);
	close();

	selectImage(newimgID);

	run("Stack to Hyperstack...", "order=xyctz channels=1 slices="
		+ totalframes + " frames=" + slices + " display=Color");
	op = "start=1 stop=" + Gendf + " projection=[Max Intensity] all";
	//run("Z Project...", op);
	if (slices > 1)
		run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=" + slices
			+ " frames=1 display=Color");
	//resultImageID = getImageID();

	//selectImage(newimgID);
	//close();

	//selectImage(resultImageID);
	//if (!calledFromBatchMode)
	//	setBatchMode("exit and display");

	//if (GFrameColorScaleCheck)
	//	CreateScale(Glut, Gstartf, Gendf);




getDimensions(width, height, channels, slices, frames);
newImage("Untitled", "RGB black", width, height, slices);

selectWindow("colored");

for (i = 0; i < nSlices; i++) {
	selectWindow("colored");
	run("Z Project...", "start="+(i+1)+" stop="+(i+rollingsSize)+" projection=[Average Intensity]");
	rename("tmp");
	run("Select All");
	run("Copy");
	selectWindow("Untitled");
	setSlice(i+1);
	run("Paste");
	selectWindow("tmp");
	close();
}

selectWindow("Untitled");
rename(windowtitle+"_"+rollingsSize+"_RolledAverage");
if(saveOutput==1){
	saveAs("Tiff", windowtitle+"_"+rollingsSize+"_RolledAverage.tif");
}
}




function showDialog() {
	lutA = getList("LUTs");
 	Dialog.create("Color Code Settings");
	Dialog.addChoice("LUT", lutA);
	Dialog.addNumber("start frame", Gstartf);
	Dialog.addNumber("end frame", Gendf);
	Dialog.addCheckbox("Create Time Color Scale Bar", GFrameColorScaleCheck);
	Dialog.show();
 	Glut = Dialog.getChoice();
	Gstartf = Dialog.getNumber();
	Gendf = Dialog.getNumber();
	GFrameColorScaleCheck = Dialog.getCheckbox();
}

function CreateScale(lutstr, beginf, endf){
	ww = 256;
	hh = 32;
	newImage("color time scale", "8-bit White", ww, hh, 1);
	for (j = 0; j < hh; j++) {
		for (i = 0; i < ww; i++) {
			setPixel(i, j, i);
		}
	}
	run(lutstr);
	run("RGB Color");
	op = "width=" + ww + " height=" + (hh + 16) + " position=Top-Center zero";
	run("Canvas Size...", op);
	setFont("SansSerif", 12, "antiliased");
	run("Colors...", "foreground=white background=black selection=yellow");
	drawString("frame", round(ww / 2) - 12, hh + 16);
	drawString(leftPad(beginf, 3), 0, hh + 16);
	drawString(leftPad(endf, 3), ww - 24, hh + 16);

}

function leftPad(n, width) {
    s = "" + n;
    while (lengthOf(s) < width)
        s = "0" + s;
    return s;
}

