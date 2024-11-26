LutList = getList("LUTs");

for (i = 0; i < LutList.length; i++) {
    // Duplicate the current image
    run("Duplicate...", "title=" + LutList[i]);

    // Set the LUT
    run(LutList[i]);
}

run("Tile");

