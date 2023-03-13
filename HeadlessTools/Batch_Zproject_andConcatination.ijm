// Blank ImageJ Macro Script that loops through files in a directory
// Originally Written by Adam Dimech
// https://code.adonline.id.au/imagej-batch-process-headless/


//Modified by Nicholas Condon


// Specify global variables

#@String input
#@String suffix
#@String projectiontype
#@String conc
#@String fps
// Add trailing slashes
input=input+"\\";

outputDir = input+"Output"+"\\";
File.makeDirectory(outputDir);
output=outputDir;
processFolder(input);
concFile(input,conc,fps);
fps=fps;
//currently hardcoded variables
compression="None";
tif="1";


// Scan folders/subfolders/files to locate files with the correct suffix
function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < list.length-1; i++) {
		if(File.isDirectory(input + list[i]))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

// Loop through each file

function processFile(input, output, file) {

// Define all variables

Months = newArray("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"); // Generate month names
DayNames = newArray("Sun", "Mon","Tue","Wed","Thu","Fri","Sat"); // Generate day names
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
timestamp ="";
if (dayOfMonth<10) {timestamp = timestamp+"0";}
timestamp = ""+DayNames[dayOfWeek]+" "+Months[month]+" "+dayOfMonth+" "+year+", "+timestamp;
if (hour<10) {timestamp = timestamp+"0";}
timestamp = timestamp+""+hour;
if (minute<10) {timestamp = timestamp+"0";}
timestamp = timestamp+":"+minute+"";
if (second<10) {timestamp = timestamp+"";}
timestamp = timestamp+":"+msec;

// Do something to each file

open(input+file);
windowtitle = getTitle();
windowtitlenoext = replace(windowtitle, suffix, "");

if (projectiontype!="No Projection") {
		print("Performing Z-Projection");
		run("Z Project...", "projection=["+projectiontype+"] all");
		print("Saving .tif  (Z-Projection Type = "+projectiontype+")");
		saveAs("Tiff", output+ windowtitlenoext+"_" +projectiontype);
		
}


while(nImages>0){selectImage(nImages);close();}

// Print log of activities for reference...

print (timestamp + ": Processing " + input + file); 
}


function concFile(input,conc,fps) {
	if (conc=="1"){
		compression="None";
	output=input+"Output"+"\\";
	print("");
	print("Opening files for concatenation");
	File.openSequence(output);
	run("AVI... ", "compression="+compression+" frame="+fps+" save=[" + output +"Concatenated-MOVIE__.avi"+ "]");
}}


	
	 
	



// A final statement to confirm the task is complete...

print("Task complete.");
