run("Clear Results");
windowtitle = getTitle();
run("Measure");
nBins = getResult("Max",0);
  run("Clear Results");
  getHistogram(values, counts, nBins);
  for (i=1; i<nBins; i++) {
     if (counts[i] >0){
     	selectWindow(windowtitle);
     	print("Threshold found ="+i);
     	run("Duplicate...", " ");
		setThreshold(i, i);
		setOption("BlackBackground", true);
		run("Convert to Mask");
		run("Create Selection");
		roiManager("Add");
		
		close();
     }   
}

