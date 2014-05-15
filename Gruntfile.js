var wrench      = require('wrench'),
    http        = require('http'),
    url         = require('url'),
    fs          = require('fs'),
    ProgressBar = require('progress');

var nodeWebkitVersion = "0.9.2";

var downloadFile = function(targetFile, remoteUrl, done) {
  var parsed = url.parse(remoteUrl);

  var req = http.request({
    host: parsed.hostname,
    port: 80,
    path: parsed.path
  });

  req.on('response', function(res){
    var len = parseInt(res.headers['content-length'], 10);
    res.pipe(fs.createWriteStream(targetFile));
    console.log();
    var bar = new ProgressBar('  downloading [:bar] :percent :etas', {
      complete: '=',
      incomplete: ' ',
      width: 20,
      total: len
    });

    res.on('data', function (chunk) {
      bar.tick(chunk.length);
    });

    res.on('end', function () {
      console.log('\n');
      done();
    });
  });

  req.end();
}


function getNodeWebkitDownloadURL(osName, archName, version, format) {
  return "http://dl.node-webkit.org/v" + version + "/node-webkit-v" + version + "-" + osName + "-" + archName + "." + format;
}

function getLocalNodeWebkitDownloadPath(os, arch, format) {
  return 'dist/cache' + "/node-webkit." + os + "." + arch + "." + nodeWebkitVersion + "." + format;
}

module.exports = function(grunt) {


  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    coffeelint: {
      app: ['coffee/**/*.coffee']
    },

    coffee: {
      app: {
        files: {
          'build/js/app.js': ['coffee/**/*.coffee']
        }
      }
    }
  });

  grunt.registerTask('download-node-webkit', function(os, arch, format) {
    var done = this.async();
    var targetFolder = "dist/cache";
    var targetFile = getLocalNodeWebkitDownloadPath(os, arch, format);
    var remoteUrl = getNodeWebkitDownloadURL(os, arch, nodeWebkitVersion, format);

    wrench.mkdirSyncRecursive(targetFolder);

    if(fs.existsSync(targetFile)) {
      grunt.log.writeln('skip download: file exists: ' + targetFile);
      done();
    }

    grunt.log.writeln('Starting download.');
    downloadFile(targetFile, remoteUrl, done)
  });

  grunt.registerTask('download-node-webkit-mac', ['download-node-webkit:osx:ia32:zip']);
  grunt.registerTask('download-node-webkit-win', ['download-node-webkit:win:ia32:zip']);
  grunt.registerTask('download-node-webkit-linux32', ['download-node-webkit:linux:ia32:tar.gz']);
  grunt.registerTask('download-node-webkit-linux64', ['download-node-webkit:linux:x64:tar.gz']);


  require('load-grunt-tasks')(grunt);

  grunt.registerTask('build-coffeescript', ['coffeelint', 'coffee:app']);
}
