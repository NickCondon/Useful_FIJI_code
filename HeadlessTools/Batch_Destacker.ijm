
#@String input
//#@String output
#@String suffix
#@String frames
#@String slices
#@String channels
#@String subfolders
// Add trailing slashes
input=input+"\\";

ext = suffix;
choiceFrames = frames;
choiceSlices = slices;
choiceChannels = channels;
choiceSubfolders = subfolders;
outputDir = input+"Output"+"\\";
File.makeDirectory(outputDir);
output=outputDir;
resultsDir = outputDir;


//Printing Parameters to log file
print("**** Parameters ****")
print("File extension: "+ext);
if (choiceFrames == 1) print("Reducing by Frame: ON");
if (choiceFrames == 0) print("Reducing by Frame: OFF");
if (choiceSlices == 1) print("Reducing by Slice: ON");
if (choiceSlices == 0) print("Reducing by Slice: OFF");
if (choiceChannels == 1) print("Reducing by Channel: ON");
if (choiceChannels == 0) print("Reducing by Channel: OFF");
if (choiceSubfolders == 1) print("Saving into Subfolders: ON");
if (choiceSubfolders == 0) print("Saving into Subfolders: OFF");


start = getTime();


processFolder(input);

function processFolder(input) {
	list = getFileList(input);
	for (i = 0; i < list.length-1; i++) {
		if(File.isDirectory(input + list[i]))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

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
choiceSubfolders = subfolders;
path = input+file;
// Do something to each file
//run("Bio-Formats Importer", "open=["+path+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
//open(input+file);

run("Bio-Formats Macro Extensions");
Ext.openImagePlus(input+file);

windowtitle = getTitle();
windowtitlenoext = replace(windowtitle, suffix, "");
resultsDir = outputDir+windowtitlenoext+"_Extracted/";
if(choiceSubfolders ==0){resultsDir=path;}
		
		File.makeDirectory(resultsDir);
		d = Stack.getDimensions(width, height, channels, slices, frames); 
		print("Total Number of Frames = "+frames);
		print("Total Number of Slices = "+slices);
		print("Total Number of Channels = "+channels);
		
		
		//Loops through each frame of the stack until total frames are saved out individually
		if (choiceFrames==1 && choiceSlices==0 && choiceChannels==0){
			for (i=0; i<frames; i++){
				fr=i+1;
				Stack.setFrame(i); 
				run("Reduce Dimensionality...", "slices channels keep"); 
				rename(windowtitlenoext+"_t"+fr);
			 	finalname = getTitle();
				print("Saving Frame # "+fr+" of "+frames);
				saveAs("Tiff", resultsDir+ finalname+".tif"); 
				close();}}

		//Loops through each frame and slice until all are saved		
		if (choiceFrames==1 && choiceSlices==1 && choiceChannels==0){
				for (i=0; i<frames; i++){
				fr=i+1;
				Stack.setFrame(i); 
				run("Reduce Dimensionality...", "slices channels keep"); 
				rename(windowtitlenoext+"_t"+fr);
				for (s=0; s<slices; s++){
					sl=s+1;
					Stack.setSlice(s); 
					run("Reduce Dimensionality...", "channels keep"); 
					rename(windowtitlenoext+"_t"+fr+"_z"+sl);
					finalname = getTitle();
					print("Saving Frame # "+fr+" of "+frames+" Slice # "+sl);
					saveAs("Tiff", resultsDir+ finalname+".tif"); 
					close();}
					close();
					}}

		//Loops through each frame, slice, and channel, until all are saved
		if (choiceFrames==1 && choiceSlices==1 && choiceChannels==1){
				//i=1;s=1;c=1;
				for (i=0; i<frames; i++){ 
					Stack.setFrame(i); 
					run("Reduce Dimensionality...", "slices channels keep"); 
					rename(windowtitlenoext+"_t"+i);
					fr=i+1;
				 	for (s=0; s<slices; s++){ 
				 		Stack.setSlice(s);
						run("Reduce Dimensionality...", "channels keep"); 
						rename(windowtitlenoext+"_t"+fr+"_z"+s);
						sl=s+1;
						for (c=0; c<channels; c++){
							ch=c+1;
							run("Duplicate...", "duplicate channels="+ch);
							rename(windowtitlenoext+"_t"+fr+"_z"+sl+"_c"+ch);
							finalname = getTitle();
							print("Saving Frame # "+fr+" of "+frames+" Slice # "+sl+" of "+slices+" Channel # "+ch+" of "+channels);
							saveAs("Tiff", resultsDir+ finalname+".tif"); 
							close();
							}
						close();
						}
					close(); 
						}
						}

		//saves out only channels
		if (choiceFrames==0 && choiceSlices==0 && choiceChannels==1){
				for (c=0; c<channels; c++){
					ch=c+1;
					run("Duplicate...", "duplicate channels="+ch);
					rename(windowtitlenoext+"_c"+ch);
					finalname = getTitle();
					print("Saving Channel # "+ch+" of "+channels);
							saveAs("Tiff", resultsDir+ finalname+".tif"); 
							close();
							}
		}

		//saves out slices and channels
		if (choiceFrames==0 && choiceSlices==1 && choiceChannels==0){
				for (s=0; s<slices; s++){
					sl=s+1;
					Stack.setSlice(s); 
					run("Reduce Dimensionality...", "frames channels keep"); 
					rename(windowtitlenoext+"_z"+sl);
					finalname = getTitle();
					print("Saving Slice # "+sl+" of "+slices);
					saveAs("Tiff", resultsDir+ finalname+".tif"); 
					close();}
					}

		//saves out frames and channels
		if (choiceFrames==1 && choiceSlices==0 && choiceChannels==1){
				//i=1;s=1;c=1;
				for (i=0; i<frames; i++){ 
					Stack.setFrame(i); 
					run("Reduce Dimensionality...", "slices channels keep"); 
					rename(windowtitlenoext+"_t"+i);
					fr=i+1; 	
					for (c=0; c<channels; c++){
							ch=c+1;
							run("Duplicate...", "duplicate channels="+ch);
							rename(windowtitlenoext+"_t"+fr+"_c"+ch);
							finalname = getTitle();
							print("Saving Frame # "+fr+" of "+frames+" Channel # "+ch+" of "+channels);
							saveAs("Tiff", resultsDir+ finalname+".tif"); 
							close();
							}
						close();
						}
					 
						}
	
		
		close(); 
		}

//Printing script runtime
print("");
print("Batch Completed");
print("Total Runtime was:");
print((getTime()-start)/1000); 
