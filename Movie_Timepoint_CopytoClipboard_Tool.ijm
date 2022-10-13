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

scripttitle= "Movie_Timepoint_CopytoClipboard_Tool";
version= "0.1";
date= "31-08-2022";
description= "Helps the user create a figure from time-series data in a 3rd party program such as Illustrator/Powerpoint. <br><br> With the file open the user chooses what outputs they would like and they are then prompeted to move to the frames of interst.";
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




getDimensions(width, height, channels, slices, frames);


windowtitle = getTitle();
Stack.getUnits(X, Y, Z, Time, Value);
if(slices>1){
	print("Note there are more than one Z-slice in this image.");
	print("There are "+slices+" Z-slices in this image.");
	multiSlicemode =1;
}
if(channels>1){
	print("Note there are more than one channel in this image.");
	print("There are "+channels+" channels in this image.");
	multichannelmode =1;
}


labels = newArray(channels+1);
defaults = newArray(channels+1);
for (i=0; i<channels; i++) {
    labels[i] = "Channel "+i+1;
    defaults[i] = 0;
	}
labels[channels] = "Merged";
defaults[channels] = 1;

Dialog.create("Title");
	Dialog.addMessage("Select which channel(s) you would like to include:");
	Dialog.addCheckboxGroup(1, channels+1, labels, defaults);
	Dialog.addCheckbox("Save Outputs as well?", 0);
Dialog.show();

checkboxArray = newArray(channels+1);
for (i=0; i<=channels; i++) {
		checkboxArray[i] = Dialog.getCheckbox();
	}
saveOutput = Dialog.getCheckbox();

if (saveOutput==1) {
	resultsDir = getDirectory("Choose an Output Directory");
	print("Saving Outputs is ON");
}

print(" * * * * * * * * * ");
print("");

moreFrames = true;

while(moreFrames==true){
	Stack.setChannel(1);
	Stack.setDisplayMode("composite");
	waitForUser("Move to the desired timepoint, and then click OK");

	Stack.getPosition(Curchannel, Curslice, Curframe);

	if(checkboxArray[channels]==1){
	currentSliceNum = getSliceNumber();
	print("Current Frame = "+Curframe+" Time = "+((getSliceNumber*Stack.getFrameInterval)-Stack.getFrameInterval)+" "+Time);
	Stack.setDisplayMode("composite");
	run("Copy to System");
	waitForUser("Merged Channel now copied, return when pasted and click OK");
	
	if (saveOutput==1) {
		run("Select All");
		run("Duplicate...", " ");
		saveAs("Png", resultsDir+windowtitle+"_t"+Curframe+"_z"+Curslice+"_merge");
		
		close();
		}

	for (i=0; i<channels; i++) {
		if(checkboxArray[i]==1){
	
			Stack.setDisplayMode("color");
			setSlice(currentSliceNum+i);
			Stack.getPosition(Curchannel, Curslice, Curframe);
			run("Copy to System");
			waitForUser("Channel "+(1+i)+" now copied, return when pasted and click OK");
			if (saveOutput==1) {
				run("Select All");
				run("Duplicate...", " ");
				saveAs("Png", resultsDir+windowtitle+"_t"+Curframe+"_z"+Curslice+"_c"+Curchannel);
				
				close();
				}

			
		}}
		
	Dialog.create("Finished?");
	Dialog.addCheckbox("Do you have more timepoints?", 1);
	Dialog.show();
	moreFrames = Dialog.getCheckbox();
	selectWindow(windowtitle);
}}

selectWindow("Log");
saveAs("Text", resultsDir+"Log.txt");

//exit message to notify user that the script has finished.
title = "Batch Completed";
msg = "Put down that coffee! Your analysis is finished";
waitForUser(title, msg);


