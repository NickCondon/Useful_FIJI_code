//Removes ROIs that are touching the edge
				n = roiManager("count");
				for (i=n-1; i>=0; i--) {
				     roiManager("select", i);
				     getSelectionBounds(x, y, w, h);
				     if (x<=0||y<=0||x+w>=getWidth||y+h>=getHeight)
				        roiManager("delete");
				     }
