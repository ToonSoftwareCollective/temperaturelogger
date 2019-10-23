function shiftArray(inputarray, delta) {

	for (var i = 0; i < 144; i++) {
		var j = parseFloat(inputarray[i]) + parseInt(delta);
		inputarray[i]= Math.round( 10 * j) / 10;
	}
	return inputarray;
}

function initArray(inputarray) {

	for (var i = 0; i < 144; i++) {
		inputarray[i]= -30;
	}
	return inputarray;
}

function addReading(inputarray, index, ctemp) {

	inputarray[index] = ctemp;
	return inputarray;

}

