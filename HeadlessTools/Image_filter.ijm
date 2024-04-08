//Modified by Nicholas Condon (n.condon@uq.edu.au)

/*
 * Script: IPP Batch Image Filter
 * 
 * Description: TTakes a folder of images and runs a user specified filter on them.
 * 
 * Input Requirements:
 *    input (string to file location) - AUTOPOPULATED
 *    output (string to file location) - AUTOPOPULATED
 *    suffix (string of file extension) - E.G .tif / .czi / .lif
 *    filtertype (string for filter option) - Options [ 'Mean', 'Median', 'Gaussian Blur', 'Minimum', 'Maximum']
 *    filtersize (number for filter radius) - E.G Greater radius = greater 'blur' (note: for 'Gaussian Blur' this field refers to the sigma)
 */


//Written to run on the Institute for Molecular Bioscience & Research Computing Centre's Image Processing Portal
//see ipp.rcc.uq.edu.au for more info



// Original ImageJ Macro Script that loops through files in a directory written by Adam Dimech
// https://code.adonline.id.au/imagej-batch-process-headless/

// Specify global variables/
#@ String input
#@ String output
#@ String suffix
#@ String (choices={"Mean", "Median", "Gaussian Blur", "Minimum", "Maximum"}, style="listBox") filtertype
#@ float (value=2) filtersize




fs = File.separator;
run("Bio-Formats Macro Extensions");

// Add trailing slashes
input=input+fs;
//output = input+fs+"Output"+fs;
outputDir =output
File.makeDirectory(outputDir);

print("\\Clear");
print("");print("");print("");
print("* * * * * * * * * * * * * * * * * * * * * * *");
print("");
print("IPP: Batch Image Filter");
print("");
print("* * * * * * * * * * * * * * * * * * * * * * *");
print("");print("");print("");

prefix = "radius";
if(filtertype=="Gaussian Blur"){prefex = "sigma";}


processFolder(input);

// Scan folders/subfolders/files to locate files with the correct suffix

function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
		//if(File.isDirectory(input + list[i]))
		//	processFolder("" + input + list[i]);
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
Ext.openImagePlus(input+file)
windowtitle = getTitle();
windowtitlenoext = replace(windowtitle, suffix, "");

run(filtertype+"...", prefix+"="+filtersize+" stack");

saveAs("Tiff", output+fs+windowtitlenoext+"_"+filtertype+filtersize+".tif"); 

while(nImages>0){selectImage(nImages);close();}



print (timestamp + ": Processing " + input + file); 
}

// A final statement to confirm the task is complete...
print("Task complete.");
