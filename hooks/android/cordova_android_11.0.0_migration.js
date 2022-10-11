var fs = require('fs');

var projectDir = __dirname + '/../../../../';
const barcodescannerGradlePath = `${projectDir}/platforms/android/phonegap-plugin-barcodescanner/pushnotifications-barcodescanner.gradle`

const migration = () => {
    if (fs.existsSync(barcodescannerGradlePath)) {
        let text = fs.readFileSync(barcodescannerGradlePath, "utf-8");
        if (text) {
            text = text.replace(/compile\(/g, 'implementation(');
            fs.writeFileSync(barcodescannerGradlePath, text);
            console.log('migrated barcode scanner path');
        }
    }
    console.log('migrated for cordova-android 11.0.0.');
};
module.exports = migration;