//
module.exports = function(grunt) {
  require('time-grunt')(grunt);

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    coffeelint: {
      app: ['coffee/**/*.iced']
    },

    coffee: {
      app: {
        files: {
          'build/js/app.js': ['coffee/**/*.iced']
        }
      }
    },

    watch: {
      app: {
        files: ['coffee/**/*.iced'],
        tasks: ['build-coffeescript']
      }
    },

    build_node_webkit: {
      targetDir: "dist",
      nwVersion: "0.9.2",
      distFiles: ["build/**/*.*", './node_modules/**', '!./node_modules/grunt*/**',
                 '!./node_modules/nodewebkit*/**', "package.json", 'index.html'],
      name: "rockband-keyboard-gui"
    }
  });

  grunt.registerTask('publish-package-json', function() {
    grunt.file.copy('./package.json', "dist/package.json");
  });

  require('load-grunt-tasks')(grunt);

  grunt.registerTask('build-coffeescript', ['coffeelint', 'coffee:app']);
  grunt.registerTask('build', ['build-coffeescript']);

  grunt.registerTask('dist', ['build', 'bundle-node-webkit-app-mac', 'bundle-node-webkit-app-win',
  'bundle-node-webkit-app-linux32', 'bundle-node-webkit-app-linux64', 'publish-package-json']);

  grunt.registerTask('dev', ['build', 'watch:app']);
}
