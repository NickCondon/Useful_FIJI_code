//Modified by Nicholas Condon (n.condon@uq.edu.au)

/*
 * Script: IPP Batch StarDist
 * 
 * Description: Takes a folder of images and uses StarDist to detect and measure/count nuclei
 * 
 * Input Requirements:
 *    input (string to file location) - AUTOPOPULATED
 *    output (string to file location) - AUTOPOPULATED
 *    suffix (string of file extension) - E.G .tif / .czi / .lif
 *    nucChannel - channel number that correlates to the nuclei (e.g. 1/2/3/4)
 *    modelChoice - StarDist Model to use for segmentation
 *    normalizeInputVar -If necessary, one can change/disable the percentile-based input image normalization
 *    percentileBottom - If necessary, one can change/disable the percentile-based input image normalization
 *    percentileTop - If necessary, one can change/disable the percentile-based input image normalization
 *    probThresh - higher values lead to fewer segmented objects, but will likely avoid false positives.
 *    nmsThresh - higher values allow segmented objects to overlap substantially.
 *    ntiles - Increase the number of tiles (in case of GPU memory limitations/errors, i.e. for larger images)
 *    boundaryExclusion
 */


//Written to run on the Institute for Molecular Bioscience & Research Computing Centre's Image Processing Portal
//https://ipp.rcc.uq.edu.au 

//This tool utilises the StarDist plugin developed by Uwe Schmidt, Martin Weigert, Coleman Broaddus, and Gene Myers
// https://github.com/stardist/stardist

// Original ImageJ Macro Script that loops through files in a directory written by Adam Dimech
// https://code.adonline.id.au/imagej-batch-process-headless/


#@ String input
#@ String output
#@ String (value=".tiff") suffix
#@ String nucChannel
#@ String (choices={"Versatile (fluorescent nuclei)", "Versatile (H&E nuclei)", "DSB 2018 (from StarDist 2D paper)"}, style="listBox") modelchoice
#@ String (value="true") normalizeInputVar
#@ String (value="1.0") percentileBottom
#@ String (value="99.8") percentileTop
#@ String (value="0.48") probThresh
#@ String (value="0.3") nmsThresh
//#@ String (choices={"ROI Manager", "Label Image", "Both"}, style="listBox") outputChoice
#@ String (value="1") ntiles
#@ String (value="2") boundaryExclusion



fs = File.separator;
outputChoice= "Both"

// Add trailing slashes
input=input+fs;
//output = input+fs+"Output"+fs;
outputDir =output
File.makeDirectory(outputDir);

print("\\Clear");
print("");print("");print("");
print("* * * * * * * * * * * * * * * * * * * * * * *");
print("");
print("IPP: Batch StarDist");
print("");
print("* * * * * * * * * * * * * * * * * * * * * * *");
print("");print("");print("");

getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
summaryFile = File.open(resultsDir+"Results_"+"_"+year+"-"+month+"-"+dayOfMonth+"_at_"+hour+"."+min+".csv");
print(summaryFile,"Image Name,  Image Number, Number of Nuclei, Nuclei #, Nuclei Area");


processFolder(input);

// Scan folders/subfolders/files to locate files with the correct suffix

function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
	//	if(File.isDirectory(input + list[i]))
	//		processFolder("" + input + list[i]);
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
run("Bio-Formats Importer", "open=["+input+file+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
//open(input+file);
nucChannel = 1;
windowtitle = getTitle(); 
getDimensions(width, height, channels, slices, frames); 
if(channels>1){
	run("Split Channels"); 
	selectWindow("C"+nucChannel+"-"1-windowtitle); 
	close("\\Others"); 
	rename(windowtitle); 
	} 
	else {rename(windowtitle);} 
getDimensions(width, height, channels, slices, frames); 
if(slices>1){
	run("Z Project...", "projection=[Max Intensity]"); 
	close("\\Others"); 
	rename(windowtitle); 
	} 
	else {rename(windowtitle);} 
if (frames!=1){exit("Multi-timepoint data is not suitable for StarDist");) 
run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'"+windowtitle+"', 'modelChoice':'"+modelchoice+"', 'normalizeInput':'"+normalizeInputVar+"', 'percentileBottom':'"+percentileBottom+"', 'percentileTop':'"+percentileTop+"', 'probThresh':'"+probThresh+"', 'nmsThresh':'"+nmsThresh+"', 'outputType':'"+outputChoice+"', 'nTiles':'"+ntiles+"', 'excludeBoundary':'"+boundaryExclusion+"', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
	numNuc = roiManager("count");
	for (k = 0; k < numNuc; k++) {
		run("Clear Results");
		roiManager("select", k);
		run("Measaure");
		nucArea = getResult("Area",0);
		print(summaryFile, windowtitle+","+(i+1)+","+numNuc+","+(k+1)+","+nucArea);
	}

	
	roiManager("save", output+fs+windowtitlenoext+"_Ch"+nucChannel+"_StarDist-ROIs.zip");
	selectWindow("Label Image");
	saveAs("Tiff", output+fs+windowtitlenoext+"_Ch"+nucChannel+"_Label-Image.tif"); 
	saveAs("JPG", output+fs+windowtitlenoext+"_Ch"+nucChannel+"_Label-Image.JPG"); 

while(nImages>0){selectImage(nImages);close();}

// Print log of activities for reference...

print (timestamp + ": Processing " + input + file); 
}

// A final statement to confirm the task is complete...

print("Task complete.");

