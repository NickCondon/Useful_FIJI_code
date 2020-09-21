print("\\Clear");
//	MIT License
//	Copyright (c) 2020 Nicholas Condon n.condon@uq.edu.au
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
scripttitle= "Bio-Formats to .tif or .jpg Batch";
version= "1.0";
date= "22-09-2020";
description= "This script takes Bio-Formats image files (eg .czi, .nd2. .lif) and allows the user to convert them to .tif or .jpg. <br> <br> Note: .jpg file outputs should not be used for multi-dimensional data-sets (eg Z-stacks/time series). <br><br> Output files are put into indivdual directories and a log file is saved in the parent directory.";
showMessage("Institute for Molecular Biosciences ImageJ Script", "<html>
    +"<h1><font size=6 color=Teal>ACRF: Cancer Biology Imaging Facility</h1>
    +"<h1><font size=5 color=Purple><i>The University of Queensland</i></h1>
    +"<h4><a href=http://imb.uq.edu.au/Microscopy/>ACRF: Cancer Biology Imaging Facility</a><h4>
    +"<h1><font color=black>ImageJ Script Macro: "+scripttitle+"</h1> 
    +"<p1>Version: "+version+" ("+date+")</p1>"
    +"<H2><font size=3>Created by Nicholas Condon</H2>"
    +"<p1><font size=2> contact n.condon@uq.edu.au \n </p1>" 
    +"<P4><font size=2> Available for use/modification/sharing under the "+"<p4><a href=https://opensource.org/licenses/MIT/>MIT License</a><h4> </P4>"
    +"<h3>   <h3>"    
    +"<p1><font size=3  i>"+description+"</p1>
    +"<h1><font size=2> </h1>"  
	   +"<h0><font size=5> </h0>"
    +"");
print("");
print("FIJI Macro: "+scripttitle);
print("Version: "+version+" Version Date: "+date);
print("ACRF: Cancer Biology Imaging Facility");
print("By Nicholas Condon (2020) n.condon@uq.edu.au")
print("");
getDateAndTime(year, month, week, day, hour, min, sec, msec);
print("Script Run Date: "+day+"/"+(month+1)+"/"+year+"  Time: " +hour+":"+min+":"+sec);
print("");
print("* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *");

ext = ".nd2";

Dialog.create("Parameters");
	Dialog.addMessage("Choose the following settings for the batch conversion");
	Dialog.addMessage("");
	Dialog.addString("Input file type filter", ext);
	Dialog.addMessage("For example: .czi, .lsm, .nd2");
	Dialog.addCheckbox("Output type: .tif", true);
	Dialog.addCheckbox("Output type: .jpg", false);
	Dialog.addCheckbox("Auto Adjust Display settings", true);
Dialog.show();

ext = Dialog.getString();
typetif = Dialog.getCheckbox();
typejpg = Dialog.getCheckbox();
displayAdjust = Dialog.getCheckbox();


if (typetif ==1) {print("Chosen output filetype = .tif");}
if (typejpg ==1) {print("Chosen output filetype = .jpg");}

if (typejpg ==0 && typetif ==0){
	showMessage("ERROR: Script Exit", "<html>
    +"<h1><font color=black>ERROR: No output filetype was selected.</h1>"
    +"<br><br>"
    +"<h2>Try re-running the script with at least one output selected</h2>");
	exit
}

//Directory Warning and Instruction panel     
Dialog.create("Choosing your working directory.");
 	Dialog.addMessage("Use the next window to navigate to the directory of your images.");
  	Dialog.addMessage("(Note a sub-directory will be made within this folder for output files) ");
Dialog.show();


//Directory Location
path = getDirectory("Choose Source Directory ");
list = getFileList(path);
getDateAndTime(year, month, week, day, hour, min, sec, msec);

start = getTime();
setBatchMode(true);
//Creates Directory for output images/logs/results table
if (typetif==1){
	resultsDirTif = path+"_Results_TIF"+"_"+year+"-"+(month+1)+"-"+day+"_at_"+hour+"."+min+"/"; 
	File.makeDirectory(resultsDirTif);
}

if (typejpg ==1){
	resultsDirJPG = path+"_Results_JPG"+"_"+year+"-"+(month+1)+"-"+day+"_at_"+hour+"."+min+"/"; 
	File.makeDirectory(resultsDirJPG);
}

print("Working Directory Location: "+path);

for (z=0; z<list.length; z++) {
	if (endsWith(list[z],ext)){
		open(path+list[z]);
		windowtitle = getTitle();
		windowtitlenoext = replace(windowtitle, ext, "");
		print("Current file = "+windowtitlenoext);
		getDimensions(width, height, channels, slices, frames);
		if (displayAdjust ==1){
			for (i = 1; i<=channels; i++) {
				setSlice(i);
				run("Enhance Contrast", "saturated=0.35");
			}
		}
		if (typetif ==1){
			saveAs("Tiff", resultsDirTif+ windowtitlenoext+"_converted.tif");
		}
		if (typejpg ==1){
			if(channels >1){
				Stack.setDisplayMode("composite");
				run("RGB Color");
			}
		saveAs("Jpeg", resultsDirJPG+ windowtitlenoext+"_converted.jpg");
		}
	while (nImages>0){close();}
	}
}
print("");
print("All outputs saved and closed");
print("Total runtime was: "+(getTime()-start)/1000+" seconds"); 
selectWindow("Log");
saveAs("Text", path+"Log.txt");
//exit message to notify user that the script has finished.
title = "Batch Completed";
msg = "Put down that coffee! Your analysis is finished";
waitForUser(title, msg);