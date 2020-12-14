// Blank ImageJ Macro Script that loops through files in a directory
// Written by Adam Dimech
// https://code.adonline.id.au/imagej-batch-process-headless/

// Specify global variables

#@String input
#@String output
#@String suffix

// Add trailing slashes
input=input+"\\";
output=output+"\\"; // This can be changed to a separate variable if need-be

processFolder(input);

// Scan folders/subfolders/files to locate files with the correct suffix

function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
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
run("Z Project...", "projection=[Max Intensity]");
title = getTitle();
setMinAndMax(0, 65535);
run("16-bit");  
saveAs(".tiff", output+title);
while(nImages>0){selectImage(nImages);close();}

// Print log of activities for reference...

print (timestamp + ": Processing " + input + file); 
}

// A final statement to confirm the task is complete...

print("Task complete.");
