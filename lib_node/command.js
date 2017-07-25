var spawn = require('child_process').spawn;
module.exports = function _command(cmd, dir, cb) {
  var res = spawn('bash', ['-c', cmd]);
  res.stdout.on('data', function(data) {
    cb(undefined, 'stdout: ' + data);
  });
  res.stderr.on('data', function(data) {
    cb('stderr: ' + data, res.stdout);
  });
};
