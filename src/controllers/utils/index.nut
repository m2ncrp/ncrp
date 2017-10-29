include("controllers/utils/commands.nut");
//include("controllers/utils/presledovanie.nut"); // also need enable OnServerPulse event
include("controllers/utils/distanceCounter.nut");

class DataFile {
    filename = null;
    
    constructor (name, rights = "a") {
        filename = file(name, rights);
    }

    function write(data) {
        data = data.tostring();
        for (local i = 0; i < data.len(); i++) {
          filename.writen(data[i], 'b');
        }
        filename.writen('\n', 'b');
        return this;
    }

    function newline() {
        filename.writen('\n', 'b');
        return this;
    }

    function close() {
        filename.close();
    }
}


function checkrandf(from, to, ammount = 1000) {
  local valAmmount = ammount;
  local ar = array(valAmmount);
  for (local i = 0; i < (valAmmount-1); i++) {
    ar[i] = randomf(from, to);
  }

  return getMean(ar, valAmmount, true);
};

function checkrand(from, to, ammount = 1000) {
  local valAmmount = ammount;
  local ar = array(valAmmount);
  for (local i = 0; i < (valAmmount-1); i++) {
    ar[i] = random(from, to);
  }

  return getMean(ar, valAmmount);
};

function getMean(data, length, nround = false) {
  local vfile = DataFile("values.txt");
  local summ = 0;
  for (local i = 0; i < (length-1); i++) {
    if (nround) {
      data[i] = round( data[i], 2 );
    }
    vfile.write( data[i] );
    summ = summ + data[i];
  }

  local mean = summ / length;

  vfile.newline()
    .write(mean)
    .newline()
    .close();

  return mean;
}
