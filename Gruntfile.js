//
module.exports = function(grunt) {
  require('time-grunt')(grunt);
  var packageJson = require('./package.json');

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    coffeelint: {
      app: ['coffee/**/*.iced']
    },

    coffee: {
      app: {
        files: {
          'build/js/app.js': ['coffee/**/*.iced', '!coffee/updater.iced'],
          'build/js/updater.js': ['coffee/updater.iced']
        }
      }
    },

    watch: {
      app: {
        files: ['coffee/**/*.iced'],
        tasks: ['build-coffeescript']
      }
    },

    concat: {
      jsLibs: {
        src: ['bower_components/jquery/dist/jquery.js',
              'bower_components/bootstrap/dist/bootstrap.js'],
        dest: 'build/js/libs.js'
      },
      cssLibs: {
        src: ['bower_components/bootstrap/dist/css/bootstrap.css',
              'bower_components/bootstrap/dist/css/bootstrap-theme.css'],
        dest: 'build/css/libs.css'
      }
    },

    build_node_webkit: {
      targetDir: "dist",
      nwVersion: "0.9.2",
      distFiles: ["build/**/*.*", "res/**/*",  './node_modules/**', '!./node_modules/grunt*/**',
                 '!./node_modules/nodewebkit*/**', '!./node_modules/archiver*/**', "package.json", 'index.html', 'update.html'],
      name: "rockband-keyboard-gui",
      osxName: "Rockband Keyboard",
      icns: "./res/icon.icns",
      version: "<%= pkg.version %>"
    }
  });

  grunt.registerTask('dist-package-json', function () {
    var projectFile = "./package.json";


    if (!grunt.file.exists(projectFile)) {
      grunt.log.error("file " + projectFile + " not found");
      return true;
    }
    var project = grunt.file.readJSON(projectFile);

    project["window"]["toolbar"] = false;

    grunt.file.write(projectFile, JSON.stringify(project, null, 2));

  });

  grunt.registerTask('publish-package-json', function() {
    grunt.file.copy('./package.json', "dist/package.json");
  });

  require('load-grunt-tasks')(grunt);

  grunt.registerTask('build-coffeescript', ['coffeelint', 'coffee:app']);

  grunt.registerTask('build-js-libs', ['concat:jsLibs']);
  grunt.registerTask('build-js', ['build-coffeescript', 'build-js-libs']);

  grunt.registerTask('build-css-libs', ['concat:cssLibs']);
  grunt.registerTask('build-css', ['build-css-libs'])

  grunt.registerTask('build', ['build-js', 'build-css']);

  grunt.registerTask('dist', ['build', 'bundle-node-webkit-app-mac', 'bundle-node-webkit-app-win',
  'bundle-node-webkit-app-linux32', 'bundle-node-webkit-app-linux64', 'dist-package-json', 'publish-package-json']);

  grunt.registerTask('dev', ['build', 'watch:app']);
}
