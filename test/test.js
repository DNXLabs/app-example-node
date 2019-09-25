const assert = require('assert');
const fs = require('fs');

describe('App', function() {
  const rawPackageJson = fs.readFileSync('package.json');
  const packageJson = JSON.parse(rawPackageJson);
  const { version } = packageJson;
  
  describe('App version 1.0.0', function() {
    it('should return correct version of the app ', function() {
      assert.equal(version, '1.0.0');
    });
  });
});